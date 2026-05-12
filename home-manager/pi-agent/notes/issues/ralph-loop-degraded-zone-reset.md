# Degraded zone + auto-reset + handoff

Type: AFK
Blocked by: /home/nonni/.pi/notes/issues/ralph-loop-split-ralph-issue.md, /home/nonni/.pi/notes/issues/ralph-loop-extension-baseline.md

## What to build

Implement degraded-zone behavior in the extension: block new `/ralph-issue` starts while over the token limit, allow the current issue to reach a safe checkpoint, perform brief bookkeeping, then auto-reset into a clean session with a handoff message and re-invoke `/ralph-loop` with the same PRD.

## Acceptance criteria

- [ ] Over limit triggers degraded zone and blocks starting new `/ralph-issue`.
- [ ] If no issue is active, a pause message is injected (“Paused due to context cap; waiting for reset”).
- [ ] Current issue can reach safe checkpoint (comment incomplete, attempt tests, note failures).
- [ ] After completion marker + brief bookkeeping, extension starts a clean new session and re-issues `/ralph-loop` with the same PRD ref.
- [ ] Handoff message is injected in the new session explaining the reset.
