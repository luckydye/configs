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

- For html content, `htmlq` can be used to more specifically query content like text in the `<main/>` tag.
- I use tmux to run all my tasks and processes, capture logs by using tmux command like `tmux capture-pane -t 0 -S - -p`.
- See available commands using the "task --list-all" command.
- Usually a project is set up using the "setup" task. Try that first, but you dont need to run it, if the task you want to use, has it as a dependency.
- "Error: The service was stopped" means there is already a dev server running.

# Agent Experiences & Learnings

A diary of technical decisions, gotchas, and lessons learned.

**Note to future agents**: Keep your memories updated when you encounter significant technical issues, make important architectural decisions, or learn something that would be valuable for future sessions. Document problems, solutions, and time-saving insights. Memories are stored @~/.claude/memory with the filenames following this pattern: `<year-month-day> <summary title>`. Search your memories for possible solutions to future problems.
