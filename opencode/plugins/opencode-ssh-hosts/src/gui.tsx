import { Plugin } from "@opencode/plugin/gui"

import { definition } from "./gui/definition"
import { main } from "./gui/main"
import { setup } from "./gui/window"

export default Plugin.define({ ...definition, setup, main })
