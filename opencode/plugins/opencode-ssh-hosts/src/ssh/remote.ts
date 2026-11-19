import { spawn } from "node:child_process"
import { request } from "node:http"

export type RemoteService = {
  readonly url: string
  readonly password?: string
  readonly version?: string
}

export type DiscoverResult =
  | { readonly ok: true; readonly service: RemoteService }
  | { readonly ok: false; readonly installed: boolean; readonly message: string }

const INSTALL_SCRIPT = "curl -fsSL https://opencode.ai/v2/install | bash"

const DISCOVER_SCRIPT = `export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$HOME/.local/share/mise/shims:$HOME/.bun/bin:$HOME/.npm-global/bin:/usr/local/bin:$PATH"
if [ -x "$HOME/.opencode/bin/opencode" ]; then
  OC="$HOME/.opencode/bin/opencode"
elif command -v opencode >/dev/null 2>&1; then
  OC="$(command -v opencode)"
else
  echo '{"error":"not-installed"}'
  exit 0
fi
if ! "$OC" service start >/dev/null 2>&1; then
  echo '{"error":"start-failed","installed":true}'
  exit 0
fi
if ! STATE="$("$OC" debug paths state 2>/dev/null)"; then
  echo '{"error":"paths-failed","installed":true}'
  exit 0
fi
if [ ! -f "$STATE/service.json" ]; then
  echo '{"error":"no-service-file","installed":true}'
  exit 0
fi
cat "$STATE/service.json"`

type RunResult = {
  readonly code: number
  readonly stdout: string
  readonly stderr: string
}

export async function discoverService(host: string, signal: AbortSignal): Promise<DiscoverResult> {
  const result = await run(["ssh", ...sshArgs(host, DISCOVER_SCRIPT)], 30_000, signal)

  if (result.code !== 0) {
    return { ok: false, installed: false, message: describeFailure(result) }
  }

  const line = lastLine(result.stdout)

  if (!line) return { ok: false, installed: false, message: "The host returned no service information." }

  let value: unknown

  try {
    value = JSON.parse(line)
  } catch {
    return { ok: false, installed: false, message: line }
  }

  if (typeof value !== "object" || value === null) {
    return { ok: false, installed: false, message: "The host returned no service information." }
  }

  const record = value as Record<string, unknown>

  if (typeof record.error === "string") {
    return {
      ok: false,
      installed: record.installed === true,
      message: errorMessage(record.error),
    }
  }

  if (typeof record.url !== "string") {
    return { ok: false, installed: false, message: "The host returned no service URL." }
  }

  return {
    ok: true,
    service: {
      url: record.url,
      password: typeof record.password === "string" ? record.password : undefined,
      version: typeof record.version === "string" ? record.version : undefined,
    },
  }
}

export function verifyTunnel(url: string, password: string | undefined): Promise<void> {
  return new Promise((resolve, reject) => {
    const headers = password
      ? { authorization: `Basic ${Buffer.from(`opencode:${password}`).toString("base64")}` }
      : undefined

    const req = request(`${url}/api/info`, { headers, timeout: 5_000 }, (res) => {
      res.resume()

      if (res.statusCode === 200) resolve()
      else reject(new Error(`The remote server answered with HTTP ${res.statusCode}.`))
    })

    req.on("timeout", () => req.destroy(new Error("The remote server did not answer.")))
    req.on("error", reject)
    req.end()
  })
}

export async function installOpenCode(
  host: string,
  signal: AbortSignal,
): Promise<{ readonly ok: boolean; readonly message: string }> {
  const result = await run(["ssh", ...sshArgs(host, INSTALL_SCRIPT)], 10 * 60_000, signal)

  if (result.code === 0) return { ok: true, message: "" }

  return { ok: false, message: describeFailure(result) }
}

function sshArgs(host: string, script: string): readonly string[] {
  return [
    "-o",
    "BatchMode=yes",
    "-o",
    "ConnectTimeout=10",
    "-o",
    "ServerAliveInterval=15",
    "-o",
    "ServerAliveCountMax=3",
    host,
    script,
  ]
}

function run(command: readonly string[], timeout: number, signal: AbortSignal): Promise<RunResult> {
  return new Promise((resolve) => {
    const child = spawn(command[0]!, command.slice(1), {
      stdio: ["ignore", "pipe", "pipe"],
      timeout,
      signal,
    })

    let stdout = ""
    let stderr = ""

    child.stdout.on("data", (chunk: Buffer) => {
      stdout += chunk.toString()
    })

    child.stderr.on("data", (chunk: Buffer) => {
      stderr += chunk.toString()
    })

    child.on("error", (cause) => {
      resolve({ code: -1, stdout, stderr: stderr || cause.message })
    })

    child.on("close", (code) => {
      resolve({ code: code ?? -1, stdout, stderr })
    })
  })
}

function describeFailure(result: RunResult): string {
  const detail = lastLine(result.stderr)

  if (detail) return detail
  if (result.code === -1) return "ssh could not start."

  return `ssh exited with code ${result.code}.`
}

function errorMessage(error: string): string {
  if (error === "not-installed") return "OpenCode is not installed on this host."
  if (error === "start-failed") return "The OpenCode service could not start on this host."
  if (error === "paths-failed") return "The host could not report its OpenCode paths."
  if (error === "no-service-file") return "The OpenCode service did not register itself on this host."

  return error
}

function lastLine(text: string): string {
  const lines = text.trim().split(/\r?\n/)

  return lines[lines.length - 1]?.trim() ?? ""
}
