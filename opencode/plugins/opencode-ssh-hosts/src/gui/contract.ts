import { Schema } from "effect"
import { Ipc } from "@opencode/plugin/gui"

export const HostPhase = Schema.Literals(["stopped", "starting", "installing", "ready", "failed"])

export const HostState = Schema.Struct({
  name: Schema.String,
  phase: HostPhase,
  ignored: Schema.Boolean,
  installed: Schema.optional(Schema.Boolean),
  detail: Schema.optional(Schema.String),
  url: Schema.optional(Schema.String),
  password: Schema.optional(Schema.String),
})

export const HostsSnapshot = Schema.Struct({
  ready: Schema.Boolean,
  error: Schema.optional(Schema.String),
  hosts: Schema.Array(HostState),
})

export type HostPhase = typeof HostPhase.Type
export type HostState = typeof HostState.Type
export type HostsSnapshot = typeof HostsSnapshot.Type

export const SshHosts = Ipc.define({
  id: "opencode-ssh-hosts.hosts",
  state: HostsSnapshot,
  methods: {
    refresh: {},
    connect: { input: Schema.String, output: Schema.Boolean },
    disconnect: { input: Schema.String },
    install: { input: Schema.String, output: Schema.Boolean },
    ignore: { input: Schema.Struct({ name: Schema.String, ignored: Schema.Boolean }) },
    reconnect: {
      input: Schema.String,
      output: Schema.Struct({ url: Schema.String, password: Schema.optional(Schema.String) }),
    },
    retry: { input: Schema.String, output: Schema.Boolean },
  },
})
