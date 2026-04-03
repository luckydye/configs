## Codestyle

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

### Issue tracking

Use the `work` terminal command to query and list issues for various projects.
Use `work inspect <ticket-id>` to see more details on a ticket.

### Browser use

agent-browser for Demo Recording.

```bash
agent-browser open "http://localhost:3001/iframe.html?id=story-id"
agent-browser wait --load networkidle
agent-browser record start /path/to/output.webm   # file must not exist
sleep 2 && agent-browser eval "/* step 1 */"
sleep 3 && agent-browser eval "/* step 2 */"
sleep 3 && agent-browser record stop
```

- `snapshot -i` lists interactive elements, `click @ref` to interact
- `screenshot /tmp/check.png` for quick visual checks
- `eval` runs JS in page context but LitElement constructors fail — use `document.createElement` instead
- Delete output file before recording (`record start` won't overwrite)
- Use `sleep` between steps for visible pauses in the video, average sleep duration should be 500ms at maximum
- Always record the video to .mp4 format.

## Tmux

I use tmux to run all my tasks and processes, capture logs by using tmux command like `tmux capture-pane -t 0 -S - -p`.

## Knowledge Base

I use thymer to store notes and all my documentation, as well as my todos.

## Output 

Why waste time say lot word when few word do trick?

