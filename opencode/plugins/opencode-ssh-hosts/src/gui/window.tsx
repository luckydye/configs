import {
  Command,
  MenuItem,
  Panel,
  Server,
  SettingsPage,
  Style,
  type PanelTab,
  type Plugin,
} from "@opencode/plugin/gui"

import { SshHosts, type HostPhase } from "./contract"
import type { definition } from "./definition"
import { ScreenPanel } from "./screen"
import { SshSettings } from "./settings"

export const setup: Plugin.Setup<typeof definition> = (ctx) => {
  if (ctx.app.platform !== "desktop") return

  const ipc = ctx.main(SshHosts)
  const hosts = () => ipc.state()?.hosts ?? []

  const refresh = async () => {
    try {
      await ipc.refresh()
      ctx.toast.show({ title: ctx.t("toast.refreshed") })
    } catch (cause) {
      ctx.toast.show({ variant: "error", title: cause instanceof Error ? cause.message : String(cause) })
    }
  }

  ctx.add(Server, () => {
    const snapshot = ipc.state()

    return {
      ready: snapshot?.ready ?? false,
      entries: (snapshot?.hosts ?? []).map((host) => ({
          id: host.name,
          name: host.name,
          label: "SSH",
          state: serverPhase(host.phase),
          listed: !host.ignored && host.phase !== "failed" && host.phase !== "stopped",
          http: host.phase === "ready" && host.url ? { url: host.url, password: host.password } : undefined,
          connect: () => ipc.connect(host.name),
          reconnect: (signal: AbortSignal) => ipc.reconnect(host.name, { signal }),
          remove: () => ipc.ignore({ name: host.name, ignored: true }),
        })),
    }
  })

  ctx.add(
    Command,
    (): Command => ({
      id: "refresh",
      title: ctx.t("command.refresh"),
      keywords: "ssh vm remote machine server",
      run: refresh,
    }),
  )

  ctx.add(
    Command,
    (): Command => ({
      id: "screen",
      title: ctx.t("screen.command"),
      keywords: "ssh vm screen remote control desktop",
      enabled: !!screenHost(ctx.id, ctx.sessions.current()?.server.id),
      run: () => {
        const session = ctx.sessions.current()

        if (session && screenHost(ctx.id, session.server.id)) ctx.layout.open(`${ctx.id}:screen`, session)
      },
    }),
  )

  const screenTab: PanelTab = {
    id: "screen",
    get title() {
      return ctx.t("screen.title")
    },
    closable: "compact",
  }

  ctx.add(Style, `
    .ssh-screen {
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
      width: 100%;
      height: 100%;
      min-height: 0;
      overflow: hidden;
      background: #000;
    }
    .ssh-screen:focus { outline: none; }
    .ssh-screen canvas {
      display: block;
      max-width: 100%;
      max-height: 100%;
      width: auto;
      height: auto;
      object-fit: contain;
      cursor: crosshair;
      user-select: none;
    }
    .ssh-screen-status {
      position: absolute;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      padding: 16px;
      color: #aaa;
      font-size: 12px;
      text-align: center;
      background: rgba(0, 0, 0, 0.65);
    }
  `)

  ctx.add(Panel, {
    id: "screen",
    region: "side",
    mobile: {
      get title() {
        return ctx.t("screen.title")
      },
      order: 50,
      kind: "menu",
      icon: "monitor",
    },
    list: (input) =>
      input.open.includes("screen") && screenHost(ctx.id, input.session.server.id) ? [screenTab] : [],
    render: (props) => <ScreenPanel session={props.session} />,
  })

  ctx.add(
    MenuItem,
    (): MenuItem | undefined => {
      const session = ctx.sessions.current()

      if (!session || !screenHost(ctx.id, session.server.id)) return undefined

      return {
        menu: "session.panel",
        id: "screen",
        title: ctx.t("screen.title"),
        description: ctx.t("screen.description"),
        icon: "monitor",
        opened: ctx.layout.state(`${ctx.id}:screen`, session) !== "closed",
        run: () => {
          const current = ctx.sessions.current()

          if (current && screenHost(ctx.id, current.server.id)) ctx.layout.open(`${ctx.id}:screen`, current)
        },
      }
    },
  )

  ctx.add(
    MenuItem,
    (): MenuItem => ({
      menu: "server.add",
      id: "refresh",
      title: ctx.t("menu.refresh"),
      run: () => void refresh(),
    }),
  )

  ctx.add(
    MenuItem,
    (): MenuItem => ({
      menu: "server.row",
      id: "reconnect",
      title: ctx.t("menu.reconnect"),
      when: (server) => server.startsWith(`${ctx.id}:`),
      run: (server) =>
        void ipc.reconnect(server.slice(ctx.id.length + 1)).catch((cause: unknown) => {
          ctx.toast.show({
            variant: "error",
            title: cause instanceof Error ? cause.message : String(cause),
          })
        }),
    }),
  )

  ctx.add(SettingsPage, {
    id: "ssh-hosts",
    page: "servers",
    get title() {
      return ctx.t("settings.title")
    },
    get entries() {
      return [
        {
          id: "ssh-hosts",
          title: ctx.t("settings.section"),
          keywords: "ssh vm remote machine server",
        },
      ]
    },
    render: () => <SshSettings />,
  })
}

function serverPhase(phase: HostPhase): "stopped" | "starting" | "ready" | "failed" {
  if (phase === "installing") return "starting"

  return phase
}

function screenHost(plugin: string, server: string | undefined): string | undefined {
  if (!server) return undefined

  const prefix = `${plugin}:`

  if (!server.startsWith(prefix)) return undefined

  const host = server.slice(prefix.length)

  return host.startsWith("vm-") ? host : undefined
}
