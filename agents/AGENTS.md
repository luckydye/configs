## General Guidelines

- Less code is better than more code.
- No fallback mechanisms — they hide real failures.
- Instead of a fallback branch in a condition, use assertions or throw and error please!
- Avoid race conditions at all costs. Espcially infinite loops.
- If only one function changes, just show that one.
- Default exports are bad, only use named exports.
- Always seperate UI rendering from data handling. Data and logic should be provided to a UI component, not computed inside the component.
- Avoid private functions and fields.
- Avoid debug logging.
- DO NOT CREATE SUMMARY OR DOCUMENTATION READMES, pls. instead write usage examples etc in code comments.
- Do not worry about backwards compatibility.

## Tooling

- I use tmux to run all my tasks and processes, capture logs by using tmux command like `tmux capture-pane -t 0 -S - -p`.
- Most of the projects use task. See all commands using the "task --list-all" command.
- "Error: The service was stopped" means there is already a dev server running.

### Issue tracking

Use the `work` terminal command to query and list issues for various projects.

### Isolated workspaces

You may use the `spaces` terminal command to create a reusable, sandboxed workspace for projects. This reduces the risk of port conflicts and system confuration mismatches.

## Agent Experiences & Learnings

Keep your memories updated when you encounter significant technical issues, make important architectural decisions, or learn something that would be valuable for future sessions. Document problems, solutions, and time-saving insights. Memories are stored in ~/memory with the filenames following this pattern: `<year-month-day> <summary title>`. Search your memories for possible solutions to future problems.