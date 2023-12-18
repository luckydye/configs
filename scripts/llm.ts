#!/usr/bin/env bun

import fs from "fs";
import fg from "fast-glob";
import enq from "enquirer";
import chalk from "chalk";
import { spawnSync } from "child_process";

const info = (...args: string[]) => {
  console.log(chalk.grey(...args));
};

async function getIndex() {
  const entries = await fg(["**/*.(md)"], {
    dot: true,
    ignore: ["**/node_modules/**"],
  });

  console.log(entries);

  info(`> Read ${entries.length} files.`);

  let systemPrompt = `
Answer in short and concise sentences.

`;

  for (const entry of entries) {
    const code = fs.readFileSync(entry, "utf8");
    let markdown = `\n${code}\n\n`;
    systemPrompt += markdown;
  }

  return systemPrompt;
}

const systemPrompt = await getIndex();

let model = "mistral";

const args = process.argv.slice(2);

if(args.includes("--mistral")) {
  model = "mistral";
}
if(args.includes("--llama")) {
  model = "codellama";
}

info(`> Using model '${model}'.`);
info(`> Set system prompt with ${systemPrompt.split(" ").length} tokens.`);

let context;
let currentResponse = "";

while (true) {
  const input = await enq.prompt<{
    prompt: string;
  }>({
    type: "input",
    name: "prompt",
    message: "Enter prompt",
  });

  await fetch("http://127.0.0.1:11434/api/generate", {
    method: "POST",
    body: JSON.stringify({
      model,
      context: context ? context : undefined,
      system: systemPrompt,
      prompt: input.prompt,
    }),
  }).then((res) => {
    return new Promise<void>((resolve) => {
      let lastChunkPartial: string | undefined;

      res.body?.pipeTo(
        new WritableStream({
          write(chunk: Uint8Array) {
            let text = new TextDecoder("utf-8").decode(chunk);
            try {
              if (lastChunkPartial) {
                text = lastChunkPartial + text;
              }

              const json = JSON.parse(text) as {
                model: string;
                created_at: string;
                response: string;
                done: boolean;
                context?: number[];
              };
              currentResponse += json.response;
              process.stdout.write(json.response);

              if (json.context) {
                context = json.context;
              }
            } catch (e) {
              lastChunkPartial = text;
            }
          },

          close() {
            console.log("\n");

            // spawnSync("glow", ["-"], {
            //   input: currentResponse,
            //   stdio: "inherit",
            // });

            resolve();
          },
        })
      );
    });
  });
}
