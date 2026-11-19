import { Schema } from "effect"
import type { Plugin } from "@opencode/plugin/gui"

import { SshHosts, type HostPhase, type HostsSnapshot } from "./contract"
import { readSshHosts } from "../ssh/config"
import { discoverService, installOpenCode, verifyTunnel } from "../ssh/remote"
import { openTunnel, type Tunnel } from "../ssh/tunnel"

const SCAN_INTERVAL = 15_000
const RETRY_DELAY = 10_000
const MAX_RETRY_DELAY = 5 * 60_000
const CONNECT_CONCURRENCY = 4

type Runtime = {
  name: string
  phase: HostPhase
  ignored: boolean
  installed?: boolean
  detail?: string
  url?: string
  password?: string
  tunnel?: Tunnel
  attempt?: { readonly generation: number; readonly promise: Promise<boolean> }
  reconnecting?: Promise<{ url: string; password?: string }>
  generation: number
  retries: number
  retryAt: number
  reconnectAt: number
  lastAttempt: number
  blocked: boolean
}

export const main: Plugin.MainSetup = (ctx) => {
  const ignored = ctx.storage.store("ignored", { schema: Schema.Array(Schema.String), initial: [] })
  const known = ctx.storage.store("known", { schema: Schema.Array(Schema.String), initial: [] })
  const runtimes = new Map<string, Runtime>()
  let ready = false
  let error: string | undefined
  let refreshing = false
  let disposed = false

  ctx.log.write("info", "ssh-hosts: main started")

  const ignoredNames = new Set(ignored.value)

  for (const name of known.value) {
    runtimes.set(name, {
      name,
      phase: "stopped",
      ignored: ignoredNames.has(name),
      generation: 0,
      retries: 0,
      retryAt: 0,
      reconnectAt: 0,
      lastAttempt: 0,
      blocked: false,
    })
  }

  const snapshot = (): HostsSnapshot => ({
    ready,
    error,
    hosts: [...runtimes.values()].map((runtime) => ({
      name: runtime.name,
      phase: runtime.phase,
      ignored: runtime.ignored,
      installed: runtime.installed,
      detail: runtime.detail,
      url: runtime.url,
      password: runtime.password,
    })),
  })

  const provider = ctx.provide(SshHosts, {
    state: () => snapshot(),
    refresh: () => refresh(),
    connect: (name) => connect(name),
    disconnect: (name) => disconnect(name),
    install: (name) => install(name),
    ignore: (input) => ignore(input.name, input.ignored),
    reconnect: (name) => reconnect(name),
    retry: (name) => retry(name),
  })

  function push() {
    provider.changed()
  }

  async function refresh(): Promise<void> {
    if (refreshing || disposed) return

    refreshing = true

    try {
      const names = await readSshHosts()
      const present = new Set(names)
      const ignoredNames = new Set(ignored.value)

      ctx.log.write("info", "ssh-hosts: scan", { hosts: names })

      for (const [name, runtime] of runtimes) {
        if (present.has(name) || runtime.phase === "stopped") continue

        runtime.generation++
        runtime.tunnel?.close()
        runtime.tunnel = undefined
        runtime.url = undefined
        runtime.password = undefined
        runtime.phase = "stopped"
        runtime.detail = undefined
        push()
      }

      const knownNames = new Set(known.value)

      for (const name of names) knownNames.add(name)

      if (knownNames.size !== known.value.length) known.set([...knownNames])

      const added: string[] = []

      for (const name of names) {
        const existing = runtimes.get(name)

        if (existing) {
          existing.ignored = ignoredNames.has(name)
          if (existing.phase === "stopped" && !existing.ignored) added.push(name)
          continue
        }

        runtimes.set(name, {
          name,
          phase: "stopped",
          ignored: ignoredNames.has(name),
          generation: 0,
          retries: 0,
          retryAt: 0,
          reconnectAt: 0,
          lastAttempt: 0,
          blocked: false,
        })
        added.push(name)
      }

      error = undefined
      ready = true
      push()

      void mapLimit(
        added.filter((name) => !ignoredNames.has(name)),
        CONNECT_CONCURRENCY,
        connect,
      )

      for (const runtime of runtimes.values()) {
        if (runtime.ignored || runtime.phase !== "failed") continue
        if (runtime.blocked) continue
        if (Date.now() < runtime.retryAt) continue

        void connect(runtime.name)
      }
    } catch (cause) {
      error = message(cause)
      ready = true
      push()
    } finally {
      refreshing = false
    }
  }

  async function connect(name: string, force = false): Promise<boolean> {
    const runtime = runtimes.get(name)

    if (!runtime) return false
    if (runtime.ignored) return false
    if (runtime.phase === "installing") return false
    if (runtime.phase === "ready") return true
    if (runtime.attempt) return runtime.attempt.promise
    if (!force && runtime.phase === "failed" && Date.now() < runtime.retryAt) return false
    if (Date.now() - runtime.lastAttempt < 1_000) return false

    runtime.lastAttempt = Date.now()
    const generation = runtime.generation
    runtime.blocked = false

    const attempt = (async () => {
      runtime.phase = "starting"
      runtime.detail = undefined
      push()

      try {
        const found = await discoverService(name, ctx.signal)

        if (runtime.generation !== generation) return false

        if (!found.ok) {
          runtime.phase = "failed"
          runtime.installed = found.installed
          runtime.detail = found.message
          runtime.blocked = !found.installed
          runtime.retries = found.installed ? runtime.retries + 1 : 0
          runtime.retryAt = Date.now() + retryDelay(runtime.retries)
          ctx.log.write("warn", "ssh-hosts: connect failed", { host: name, detail: found.message })
          push()
          return false
        }

        const url = new URL(found.service.url)
        const targetHost = url.hostname === "0.0.0.0" ? "127.0.0.1" : url.hostname
        const tunnel = await openTunnel(name, targetHost, port(url), ctx.signal)

        if (runtime.generation !== generation) {
          tunnel.close()
          return false
        }

        await verifyTunnel(tunnel.url, found.service.password).catch((cause: unknown) => {
          tunnel.close()
          throw cause
        })

        if (runtime.generation !== generation) {
          tunnel.close()
          return false
        }

        runtime.tunnel = tunnel
        runtime.url = tunnel.url
        runtime.password = found.service.password
        runtime.installed = true
        runtime.phase = "ready"
        runtime.detail = found.service.version
        runtime.retries = 0
        runtime.blocked = false
        ctx.log.write("info", "ssh-hosts: connected", { host: name, url: tunnel.url, version: found.service.version })
        push()

        void tunnel.exited.then((reason) => {
          if (!reason || runtime.tunnel !== tunnel) return

          runtime.tunnel = undefined
          runtime.url = undefined
          runtime.password = undefined
          runtime.phase = "failed"
          runtime.detail = reason
          runtime.retries++
          runtime.blocked = false
          runtime.retryAt = Date.now() + retryDelay(runtime.retries)
          push()
        })

        return true
      } catch (cause) {
        if (runtime.generation !== generation) return false

        runtime.phase = "failed"
        runtime.detail = message(cause)
        runtime.retries++
        runtime.blocked = false
        runtime.retryAt = Date.now() + retryDelay(runtime.retries)
        ctx.log.write("warn", "ssh-hosts: connect failed", { host: name, detail: runtime.detail })
        push()
        return false
      } finally {
        if (runtime.attempt?.generation === generation) runtime.attempt = undefined
      }
    })()

    runtime.attempt = { generation, promise: attempt }

    return attempt
  }

  function disconnect(name: string): void {
    const runtime = runtimes.get(name)

    if (!runtime) return

    runtime.generation++
    runtime.tunnel?.close()
    runtime.tunnel = undefined
    runtime.url = undefined
    runtime.password = undefined
    runtime.phase = "stopped"
    runtime.detail = undefined
    runtime.lastAttempt = 0
    push()
  }

  async function reconnect(name: string): Promise<{ url: string; password?: string }> {
    const runtime = runtimes.get(name)

    if (!runtime) throw new Error("The SSH host is gone.")

    if (runtime.reconnecting) return runtime.reconnecting

    if (runtime.attempt) {
      const connected = await runtime.attempt.promise

      if (!connected || !runtime.url) throw new Error(runtime.detail ?? "Could not reconnect the SSH host.")

      return { url: runtime.url, password: runtime.password }
    }

    if (Date.now() < runtime.reconnectAt) throw new Error(runtime.detail ?? "The SSH host is reconnecting.")

    runtime.reconnectAt = Date.now() + 10_000

    const promise = (async () => {
      disconnect(name)

      const connected = await connect(name, true)

      if (!connected || !runtime.url) throw new Error(runtime.detail ?? "Could not reconnect the SSH host.")

      return { url: runtime.url, password: runtime.password }
    })()

    runtime.reconnecting = promise

    try {
      return await promise
    } finally {
      if (runtime.reconnecting === promise) runtime.reconnecting = undefined
    }
  }

  async function retry(name: string): Promise<boolean> {
    const runtime = runtimes.get(name)

    if (!runtime) return false

    runtime.retryAt = 0
    runtime.blocked = false
    runtime.lastAttempt = 0

    return connect(name, true)
  }

  async function install(name: string): Promise<boolean> {
    const runtime = runtimes.get(name)

    if (!runtime) return false

    const generation = ++runtime.generation

    runtime.phase = "installing"
    runtime.detail = undefined
    push()

    const result = await installOpenCode(name, ctx.signal)

    if (runtime.generation !== generation) return false

    if (!result.ok) {
      runtime.phase = "failed"
      runtime.installed = false
      runtime.detail = result.message
      runtime.blocked = true
      push()
      return false
    }

    runtime.installed = true
    runtime.retries = 0
    runtime.blocked = false
    runtime.retryAt = 0
    push()

    return connect(name)
  }

  function ignore(name: string, value: boolean): void {
    const runtime = runtimes.get(name)

    if (!runtime) return

    const next = new Set(ignored.value)

    if (value) next.add(name)
    else next.delete(name)

    ignored.set([...next])
    runtime.ignored = value

    if (value) disconnect(name)
    else void connect(name)

    push()
  }

  void refresh()

  const timer = setInterval(() => void refresh(), SCAN_INTERVAL)

  ctx.onCleanup(() => {
    disposed = true
    clearInterval(timer)

    for (const runtime of runtimes.values()) {
      runtime.generation++
      runtime.tunnel?.close()
    }

    runtimes.clear()
  })
}

function port(url: URL): number {
  if (url.port) return Number(url.port)
  if (url.protocol === "https:") return 443
  if (url.protocol === "http:") return 80

  throw new Error(`Unsupported service URL: ${url.href}`)
}

function message(cause: unknown): string {
  return cause instanceof Error ? cause.message : String(cause)
}

function retryDelay(retries: number): number {
  return Math.min(MAX_RETRY_DELAY, RETRY_DELAY * 2 ** retries)
}

async function mapLimit<T>(items: readonly T[], limit: number, run: (item: T) => Promise<unknown>): Promise<void> {
  const queue = [...items]

  const worker = async () => {
    for (let item = queue.shift(); item !== undefined; item = queue.shift()) {
      await run(item)
    }
  }

  await Promise.all(Array.from({ length: Math.min(limit, queue.length) }, worker))
}
