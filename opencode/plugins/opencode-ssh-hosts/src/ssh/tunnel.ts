import { spawn, type ChildProcess } from "node:child_process"
import { createServer, connect } from "node:net"

const CONNECT_TIMEOUT = 15_000

export type Tunnel = {
  readonly url: string
  /** Resolves with the failure reason when the tunnel drops. */
  readonly exited: Promise<string>
  close(): void
}

export async function openTunnel(
  host: string,
  targetHost: string,
  targetPort: number,
  signal: AbortSignal,
): Promise<Tunnel> {
  const port = await freePort()
  const child = spawn(
    "ssh",
    [
      "-N",
      "-o",
      "BatchMode=yes",
      "-o",
      "ExitOnForwardFailure=yes",
      "-o",
      "ConnectTimeout=10",
      "-o",
      "ServerAliveInterval=15",
      "-o",
      "ServerAliveCountMax=3",
      "-L",
      `127.0.0.1:${port}:${targetHost}:${targetPort}`,
      host,
    ],
    { stdio: ["ignore", "ignore", "pipe"] },
  )

  let stderr = ""
  let closing = false

  child.stderr.on("data", (chunk: Buffer) => {
    stderr += chunk.toString()
  })

  const exited = new Promise<string>((resolve) => {
    child.on("error", (cause) => resolve(stderr.trim() || cause.message))
    child.on("close", (code) => {
      if (closing) return resolve("")
      resolve(stderr.trim() || `ssh exited with code ${code}.`)
    })
  })

  const close = () => {
    if (closing) return

    closing = true
    child.kill("SIGTERM")
    signal.removeEventListener("abort", close)
  }

  signal.addEventListener("abort", close, { once: true })

  try {
    await waitForPort(port, child, () => stderr, signal)
  } catch (cause) {
    close()
    throw cause
  }

  return { url: `http://127.0.0.1:${port}`, exited, close }
}

async function waitForPort(
  port: number,
  child: ChildProcess,
  stderr: () => string,
  signal: AbortSignal,
): Promise<void> {
  const deadline = Date.now() + CONNECT_TIMEOUT

  while (Date.now() < deadline) {
    if (signal.aborted) throw new Error("The SSH tunnel was cancelled.")
    if (child.exitCode !== null || child.signalCode !== null) {
      throw new Error(stderr().trim() || `ssh exited with code ${child.exitCode}.`)
    }
    if (await accepts(port)) return
    await delay(100)
  }

  throw new Error("Timed out opening the SSH tunnel.")
}

function accepts(port: number): Promise<boolean> {
  return new Promise((resolve) => {
    const socket = connect({ host: "127.0.0.1", port })
    const done = (value: boolean) => {
      socket.destroy()
      resolve(value)
    }

    socket.setTimeout(250, () => done(false))
    socket.once("connect", () => done(true))
    socket.once("error", () => done(false))
  })
}

function freePort(): Promise<number> {
  return new Promise((resolve, reject) => {
    const server = createServer()

    server.once("error", reject)
    server.listen(0, "127.0.0.1", () => {
      const address = server.address()

      if (address === null || typeof address === "string") {
        server.close()
        reject(new Error("Could not reserve a local port."))
        return
      }

      server.close(() => resolve(address.port))
    })
  })
}

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms))
}
