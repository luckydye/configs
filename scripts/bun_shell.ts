import { $ } from "bun";
import chalk from 'chalk';

const tasks = (await $`task --list --json`.json()).tasks;

async function gitName() {
  return await $`basename $(git rev-parse --show-toplevel)`.quiet().text();
}

while (true) {
  const prefix = chalk.cyan((await gitName()).trim());
  const input = prompt(`${prefix} ${chalk.green('〉')}`);

  if (input) {
    const args = input.split(' ');
    const suffix = args.slice(1).join(' ');

    if(tasks.find(t => t.name === args[0])) {
      // is a task
      await $`task ${args[0]} ${suffix}`;
    } else {
      await $`${input}`;
    }
  }
}
