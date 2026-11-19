import { glob, readFile } from "node:fs/promises"
import { homedir } from "node:os"
import { isAbsolute, join } from "node:path"

const MAX_INCLUDE_DEPTH = 8

/**
 * Reads every `Host` alias from the user's SSH config, following `Include` directives the way OpenSSH does.
 * Wildcard and negated patterns are skipped because they are not machines the user can connect to by name.
 */
export async function readSshHosts(home = homedir()): Promise<readonly string[]> {
  const sshDir = join(home, ".ssh")
  const hosts: string[] = []
  const seen = new Set<string>()
  const visited = new Set<string>()

  await readConfig(join(sshDir, "config"), home, sshDir, hosts, seen, visited, 0)

  return hosts
}

async function readConfig(
  file: string,
  home: string,
  sshDir: string,
  hosts: string[],
  seen: Set<string>,
  visited: Set<string>,
  depth: number,
): Promise<void> {
  if (depth > MAX_INCLUDE_DEPTH || visited.has(file)) return
  visited.add(file)

  const text = await readFile(file, "utf8").catch((cause: NodeJS.ErrnoException) => {
    if (cause.code === "ENOENT") return ""
    throw cause
  })

  for (const raw of text.split(/\r?\n/)) {
    const line = raw.trim()

    if (!line || line.startsWith("#")) continue

    const [keyword, ...tokens] = line.replace(/\s*=\s*/, " ").split(/\s+/)
    const key = keyword.toLowerCase()

    if (key === "include") {
      const files = await expandInclude(tokens, home, sshDir)

      for (const included of files) {
        await readConfig(included, home, sshDir, hosts, seen, visited, depth + 1)
      }

      continue
    }

    if (key !== "host") continue

    for (const pattern of tokens) {
      if (pattern.startsWith("!") || /[*?%]/.test(pattern)) continue
      if (seen.has(pattern)) continue

      seen.add(pattern)
      hosts.push(pattern)
    }
  }
}

async function expandInclude(tokens: readonly string[], home: string, sshDir: string): Promise<readonly string[]> {
  const files: string[] = []

  for (const token of tokens) {
    const pattern = resolvePath(token.replace(/^"(.*)"$/, "$1").replace(/^'(.*)'$/, "$1"), home, sshDir)

    if (!/[*?[]/.test(pattern)) {
      files.push(pattern)
      continue
    }

    for await (const match of glob(pattern)) files.push(match)
  }

  return files.sort()
}

function resolvePath(token: string, home: string, sshDir: string): string {
  const path = token.replaceAll("%d", home)

  if (path === "~") return home
  if (path.startsWith("~/")) return join(home, path.slice(2))
  if (isAbsolute(path)) return path

  return join(sshDir, path)
}
