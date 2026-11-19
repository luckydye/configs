# opencode-ssh-hosts

An OpenCode Desktop extension that finds every machine in your SSH config and lists it as an OpenCode server. No per-VM setup: start a VM, and its sessions appear in the desktop app.

## What it does

- Reads `~/.ssh/config` and every file it includes (for example the generated `~/.vm/ssh_config`). Wildcard and negated host patterns are skipped.
- Connects to each host over SSH, starts that host's shared OpenCode background service if needed, and opens a local SSH tunnel to it.
- Feeds the tunnel to OpenCode Desktop through the GUI plugin `Server` registry, so sessions can be listed, opened, and created for every host.
- Re-scans the SSH config every 15 seconds, so VMs that start or stop are picked up automatically.
- Adds **Settings > Servers > Machines** with per-host status, retry, an automatic-connect switch, and a one-click **Install** for hosts that do not have OpenCode yet.
- Adds **Refresh SSH hosts** to the command palette and the **Add server** menu.

The remote server keeps the host's own session data and configuration, so a session created in a VM stays in that VM. Authentication uses the password from the host's `~/.local/state/opencode/service.json`, the same mechanism the desktop app uses for a local server. Tunnels bind to `127.0.0.1` only.

## Requirements

- OpenCode Desktop 2.3 or later.
- SSH access to each host with keys that do not prompt (the extension runs `ssh` with `BatchMode=yes`).
- OpenCode installed on the host. Use the **Install** button in Settings, or install it once yourself:

  ```sh
  ssh <host> 'curl -fsSL https://opencode.ai/v2/install | bash'
  ```

## Build

```sh
npm install
npm run build
```

The GUI bundle is written to `dist/gui-experimental.cjs`. For development, `npm run dev` rebuilds it whenever a source file changes, and the desktop app reloads the plugin.

## Install

Add the plugin directory to the global `~/.config/opencode/opencode.jsonc`:

```jsonc
{
  "plugins": ["/absolute/path/to/opencode-ssh-hosts"]
}
```

The desktop app only loads GUI plugins from the global config. Restart the app once, then check **Settings > Extensions > Plugins**.

## Known behavior

- A connected host keeps an SSH tunnel open. With the `vm` tool this also keeps the VM from idle-suspending, because a tunnel counts as an attached client.
- The extension starts the shared OpenCode background service on the host, matching what the local CLI does. It never installs OpenCode without confirmation.
- A failed host is retried with exponential backoff, up to one attempt every five minutes. A host without OpenCode waits for **Install** or **Retry** instead of retrying in the background.
