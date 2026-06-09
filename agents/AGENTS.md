## Codestyle

- Less code is better than more code.
- No fallback mechanisms — they hide real failures. Instead of a fallback branch in a condition, use assertions or throw and error please!
- Avoid race conditions at all costs. Espcially infinite loops.
- Default exports are bad, only use named exports.
- Always seperate UI rendering from data handling. Data and logic should be provided to a UI component, not computed inside the component.
- Avoid private functions and fields.
- Avoid debug logging.
- Do not worry about backwards compatibility.
- Always use Conventional Commits syntax for commit messages, examples: `feat: Added blend modes` or `fix: Crop not working`
- You are NOT allowed in install arbitrary npm packages!!!
- ALWAYS mark backwards compatible code paths or depricated functions as deprecated

### Tests

- Do not write unit-tests. Tests should be on an integration level. Testing individual units is not useful for most cases, since it will never catch errors in a combination things.
- You should prefere writing integration tests. For example, testing a cli should consist of a bash script actually using the cli and expecting a certain output. Or taking a snapshot of visual output, to compare to. etc.

## Browser use

If the user provides a URL, ESPECIALLY a localhost url, consider haveing a look with `agent-browser` cli!

- `snapshot -i` lists interactive elements, `click @ref` to interact
- Delete output file before recording (`record start` won't overwrite)
- Use `sleep` between steps for visible pauses in the video, average sleep duration should be 500ms at maximum
- Always record the video to .mp4 format.

## Tmux

I use tmux to run all my tasks and processes, capture logs by using tmux command like `tmux capture-pane -t 0 -S - -p`.

## Knowledge Base

I use thymer to store notes and all my documentation, as well as my todos.
