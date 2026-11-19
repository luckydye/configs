import { createEffect, createSignal, onCleanup, Show } from "solid-js"
import { usePlugin, type MountedSession } from "@opencode/plugin/gui"

import { SshHosts } from "./contract"
import type { definition } from "./definition"

const KEYS: Record<string, number> = {
  Escape: 1,
  Digit1: 2,
  Digit2: 3,
  Digit3: 4,
  Digit4: 5,
  Digit5: 6,
  Digit6: 7,
  Digit7: 8,
  Digit8: 9,
  Digit9: 10,
  Digit0: 11,
  Minus: 12,
  Equal: 13,
  Backspace: 14,
  Tab: 15,
  KeyQ: 16,
  KeyW: 17,
  KeyE: 18,
  KeyR: 19,
  KeyT: 20,
  KeyY: 21,
  KeyU: 22,
  KeyI: 23,
  KeyO: 24,
  KeyP: 25,
  BracketLeft: 26,
  BracketRight: 27,
  Enter: 28,
  ControlLeft: 29,
  KeyA: 30,
  KeyS: 31,
  KeyD: 32,
  KeyF: 33,
  KeyG: 34,
  KeyH: 35,
  KeyJ: 36,
  KeyK: 37,
  KeyL: 38,
  Semicolon: 39,
  Quote: 40,
  Backquote: 41,
  ShiftLeft: 42,
  Backslash: 43,
  KeyZ: 44,
  KeyX: 45,
  KeyC: 46,
  KeyV: 47,
  KeyB: 48,
  KeyN: 49,
  KeyM: 50,
  Comma: 51,
  Period: 52,
  Slash: 53,
  ShiftRight: 54,
  NumpadMultiply: 55,
  AltLeft: 56,
  Space: 57,
  CapsLock: 58,
  F1: 59,
  F2: 60,
  F3: 61,
  F4: 62,
  F5: 63,
  F6: 64,
  F7: 65,
  F8: 66,
  F9: 67,
  F10: 68,
  NumLock: 69,
  ScrollLock: 70,
  F11: 87,
  F12: 88,
  ControlRight: 97,
  AltRight: 100,
  Home: 102,
  ArrowUp: 103,
  PageUp: 104,
  ArrowLeft: 105,
  ArrowRight: 106,
  End: 107,
  ArrowDown: 108,
  PageDown: 109,
  Insert: 110,
  Delete: 111,
  MetaLeft: 125,
  MetaRight: 126,
}

export function ScreenPanel(props: { readonly session: MountedSession }) {
  const ctx = usePlugin<typeof definition>()
  const ipc = ctx.main(SshHosts)
  const [active, setActive] = createSignal(false)
  const [error, setError] = createSignal<string>()

  let root: HTMLDivElement | undefined
  let canvas: HTMLCanvasElement | undefined
  let context: CanvasRenderingContext2D | null | undefined
  let decoder: VideoDecoder | undefined
  let timestamp = 0
  let opened: string | undefined
  let lastMove = 0

  const target = () => {
    const prefix = `${ctx.id}:`
    const id = props.session.server.id

    if (!id.startsWith(prefix)) return undefined

    const host = id.slice(prefix.length)

    return host.startsWith("vm-") ? host : undefined
  }

  const reset = () => {
    decoder?.close()
    decoder = undefined
    context = undefined

    if (canvas) {
      canvas.width = 0
      canvas.height = 0
    }
  }

  const draw = (video: VideoFrame) => {
    const element = canvas

    if (!element) {
      video.close()
      return
    }

    if (element.width !== video.displayWidth || element.height !== video.displayHeight) {
      element.width = video.displayWidth
      element.height = video.displayHeight
      context = element.getContext("2d")
    }

    context ??= element.getContext("2d")
    context?.drawImage(video, 0, 0)
    video.close()

    if (!active()) setActive(true)
  }

  const decode = (data: string, keyframe: boolean) => {
    if (typeof VideoDecoder === "undefined") {
      setError(ctx.t("screen.unsupported"))
      return
    }

    if (!decoder && !keyframe) return

    const bytes = base64(data)

    if (!decoder) {
      const created = new VideoDecoder({
        output: draw,
        error: (cause) => {
          setError(String(cause))
          reset()
          setActive(false)
        },
      })

      decoder = created

      try {
        created.configure({
          codec: codecFromAnnexB(bytes) ?? "avc1.42E01E",
          optimizeForLatency: true,
          hardwareAcceleration: "prefer-software",
          avc: { format: "annexb" },
        } as VideoDecoderConfig)
      } catch (cause) {
        setError(String(cause))
        reset()
        return
      }
    }

    try {
      decoder.decode(
        new EncodedVideoChunk({
          type: keyframe ? "key" : "delta",
          timestamp: (timestamp += 1000),
          data: bytes,
        }),
      )
    } catch (cause) {
      setError(String(cause))
      reset()
      setActive(false)
    }
  }

  const offFrame = ipc.on("frame", (frame) => {
    if (frame.host !== target()) return

    decode(frame.data, frame.keyframe)
  })

  const offEnded = ipc.on("screenEnded", (ended) => {
    if (ended.host !== target()) return

    setError(ended.message)
    setActive(false)
  })

  onCleanup(offFrame)
  onCleanup(offEnded)

  const open = () => {
    const host = target()

    if (!host) return

    reset()
    setActive(false)
    setError(undefined)

    void ipc.screenOpen(host).catch((cause) => setError(message(cause)))
  }

  createEffect(() => {
    const next = target()

    if (next === opened) return
    if (opened) void ipc.screenClose(opened).catch(() => {})

    opened = next
    open()
  })

  const send = (event: unknown) => {
    if (!opened) return

    void ipc.screenInput({ host: opened, line: JSON.stringify(event) }).catch((cause) => setError(message(cause)))
  }

  const point = (event: PointerEvent) => {
    const element = event.currentTarget as HTMLCanvasElement
    const rect = element.getBoundingClientRect()

    return {
      x: clamp(Math.round(((event.clientX - rect.left) / rect.width) * element.width), element.width),
      y: clamp(Math.round(((event.clientY - rect.top) / rect.height) * element.height), element.height),
    }
  }

  const move = (event: PointerEvent) => {
    if (!active()) return

    const now = performance.now()

    if (now - lastMove < 30) return

    lastMove = now
    send({ move: point(event) })
  }

  const button = (event: PointerEvent) => (event.button === 2 ? 273 : event.button === 1 ? 274 : 272)

  const down = (event: PointerEvent) => {
    if (!active()) return

    root?.focus()
    ;(event.currentTarget as HTMLCanvasElement).setPointerCapture(event.pointerId)
    send({ button: { button: button(event), down: true } })
  }

  const up = (event: PointerEvent) => {
    if (!active()) return

    send({ button: { button: button(event), down: false } })
  }

  const wheel = (event: WheelEvent) => {
    if (!active()) return

    event.preventDefault()

    if (event.deltaX !== 0) send({ scroll: { value: event.deltaX > 0 ? 1 : -1, horizontal: true } })
    if (event.deltaY !== 0) send({ scroll: { value: event.deltaY > 0 ? -1 : 1, horizontal: false } })
  }

  const key = (down: boolean) => (event: KeyboardEvent) => {
    if (!active()) return

    const code = KEYS[event.code]

    if (code === undefined) return

    event.preventDefault()
    event.stopPropagation()
    send({ key: { code, down } })
  }

  onCleanup(() => {
    if (opened) void ipc.screenClose(opened).catch(() => {})

    reset()
  })

  return (
    <div
      class="ssh-screen"
      ref={(element) => (root = element)}
      tabIndex={0}
      onKeyDown={key(true)}
      onKeyUp={key(false)}
    >
      <canvas
        ref={(element) => (canvas = element)}
        onPointerMove={move}
        onPointerDown={down}
        onPointerUp={up}
        onContextMenu={(event) => event.preventDefault()}
        onWheel={wheel}
      />
      <Show when={!active() && !error()}>
        <div class="ssh-screen-status">{ctx.t("screen.waiting")}</div>
      </Show>
      <Show when={error()}>
        <div class="ssh-screen-status">
          <span>{error()}</span>
          <ctx.ui.Button size="small" onClick={open}>
            {ctx.t("screen.retry")}
          </ctx.ui.Button>
        </div>
      </Show>
    </div>
  )
}

function clamp(value: number, size: number): number {
  return Math.max(0, Math.min(size - 1, value))
}

function message(cause: unknown): string {
  return cause instanceof Error ? cause.message : String(cause)
}

function base64(value: string): Uint8Array {
  const binary = atob(value)
  const bytes = new Uint8Array(binary.length)

  for (let index = 0; index < binary.length; index++) bytes[index] = binary.charCodeAt(index)

  return bytes
}

function codecFromAnnexB(data: Uint8Array): string | undefined {
  for (let index = 0; index + 7 < data.length; index++) {
    if (data[index] !== 0 || data[index + 1] !== 0) continue

    const start = data[index + 2] === 1 ? 3 : data[index + 2] === 0 && data[index + 3] === 1 ? 4 : 0

    if (!start) continue

    const header = data[index + start]

    if ((header & 0x1f) !== 7) continue

    return `avc1.${hex(data[index + start + 1])}${hex(data[index + start + 2])}${hex(data[index + start + 3])}`
  }

  return undefined
}

function hex(value: number): string {
  return value.toString(16).padStart(2, "0").toUpperCase()
}
