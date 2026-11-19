import { Command, MenuItem, Server, SettingsPage, type Plugin } from "@opencode/plugin/gui"

import { SshHosts, type HostPhase } from "./contract"
import type { definition } from "./definition"
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
