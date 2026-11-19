import { spawn } from "node:child_process"

export function varmintName(host: string): string {
  if (!host.startsWith("vm-")) throw new Error("Screen control is only available for varmint VMs.")

  return host.slice(3)
}

export function openStream(host: string) {
  return spawn("vm", ["stream", varmintName(host), "--fps", "30"], {
    stdio: ["ignore", "pipe", "pipe"],
  })
}

export function openInput(host: string) {
  return spawn("vm", ["input", varmintName(host)], {
    stdio: ["pipe", "ignore", "pipe"],
  })
}

export type VideoFrame = {
  readonly keyframe: boolean
  readonly width: number
  readonly height: number
  readonly data: Buffer
}

/**
 * Parses the framed stdout of `vm stream`:
 * video = 0, width u32, height u32, keyframe u8, length u32, H.264 Annex B
 * audio = 1, length u32, Opus packet
 */
export function parseVideo(rest: Buffer, chunk: Buffer): { rest: Buffer; frames: VideoFrame[] } {
  let data = rest.length > 0 ? Buffer.concat([rest, chunk]) : chunk
  const frames: VideoFrame[] = []

  while (data.length > 0) {
    const kind = data[0]

    if (kind === 0) {
      if (data.length < 14) break

      const width = data.readUInt32LE(1)
      const height = data.readUInt32LE(5)
      const keyframe = data[9] === 1
      const length = data.readUInt32LE(10)

      if (data.length < 14 + length) break

      frames.push({ keyframe, width, height, data: data.subarray(14, 14 + length) })
      data = data.subarray(14 + length)
      continue
    }

    if (kind === 1) {
      if (data.length < 5) break

      const length = data.readUInt32LE(1)

      if (data.length < 5 + length) break

      data = data.subarray(5 + length)
      continue
    }

    data = Buffer.alloc(0)
  }

  return { rest: data, frames }
}
