import { createSignal, For, Show } from "solid-js"
import { usePlugin } from "@opencode/plugin/gui"

import { SshHosts, type HostState } from "./contract"
import type { definition } from "./definition"

export function SshSettings() {
  const ctx = usePlugin<typeof definition>()
  const ipc = ctx.main(SshHosts)
  const ui = ctx.ui
  const [busy, setBusy] = createSignal<string>()

  const hosts = () => ipc.state()?.hosts ?? []
  const error = () => ipc.state()?.error

  const notify = (cause: unknown) =>
    ctx.toast.show({ variant: "error", title: cause instanceof Error ? cause.message : String(cause) })

  const describe = (host: HostState): string => {
    if (host.phase === "ready") return ctx.t("settings.ready", { version: host.detail ? ` · ${host.detail}` : "" })
    if (host.phase === "starting") return ctx.t("settings.starting")
    if (host.phase === "installing") return ctx.t("settings.installing")
    if (host.phase === "failed") {
      return host.installed === false ? ctx.t("settings.notInstalled") : host.detail ?? ctx.t("settings.failed")
    }

    return ctx.t("settings.stopped")
  }

  const perform = async (name: string, action: () => Promise<unknown>) => {
    setBusy(name)

    try {
      await action()
    } catch (cause) {
      notify(cause)
    } finally {
      setBusy(undefined)
    }
  }

  const install = async (host: HostState) => {
    const confirmed = await ctx.dialogs.confirm({
      title: ctx.t("install.title"),
      description: ctx.t("install.description", { host: host.name }),
      confirm: ctx.t("install.confirm"),
    })

    if (!confirmed) return

    await perform(host.name, async () => {
      const ok = await ipc.install(host.name)

      ctx.toast.show(
        ok
          ? { variant: "success", title: ctx.t("install.done", { host: host.name }) }
          : { variant: "error", title: ctx.t("install.failed", { host: host.name }) },
      )
    })
  }

  return (
    <ui.SettingsSection
      title={ctx.t("settings.section")}
      footer={
        <div style={{ display: "flex", "align-items": "center", gap: "12px" }}>
          <ui.Button size="small" onClick={() => void ipc.refresh().catch(notify)}>
            {ctx.t("settings.refresh")}
          </ui.Button>
          <Show when={error()}>
            <span>{error()}</span>
          </Show>
        </div>
      }
    >
      <Show
        when={hosts().length > 0}
        fallback={<ui.SettingsRow title={ctx.t("settings.empty")} />}
      >
        <For each={hosts()}>
          {(host) => (
            <ui.SettingsRow title={host.name} description={describe(host)}>
              <div style={{ display: "flex", "align-items": "center", gap: "8px" }}>
                <Show when={!host.ignored && host.installed === false && host.phase === "failed"}>
                  <ui.Button size="small" busy={busy() === host.name} onClick={() => void install(host)}>
                    {ctx.t("settings.install")}
                  </ui.Button>
                </Show>
                <Show when={!host.ignored && (host.phase === "failed" || host.phase === "stopped")}>
                  <ui.Button
                    size="small"
                    busy={busy() === host.name}
                    disabled={host.ignored}
                    onClick={() => void perform(host.name, () => ipc.retry(host.name))}
                  >
                    {ctx.t("settings.retry")}
                  </ui.Button>
                </Show>
                <ui.Switch
                  label={ctx.t("settings.include")}
                  hideLabel
                  checked={!host.ignored}
                  onChange={(checked) => void ipc.ignore({ name: host.name, ignored: !checked }).catch(notify)}
                />
              </div>
            </ui.SettingsRow>
          )}
        </For>
      </Show>
    </ui.SettingsSection>
  )
}
