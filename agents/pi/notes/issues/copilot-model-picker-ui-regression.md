# Bug: custom `/copilot-model` picker causes oversized UI and editor jump after close

Type: HITL
Blocked by: None

## What to build

Fix the extension model picker UX regression where the custom `/copilot-model` selector renders much larger than the built-in `/model` picker and, after closing, the editor/input area shifts upward unexpectedly. The picker should behave like native model selection in size and teardown stability.

## Acceptance criteria

- [ ] Opening `/copilot-model` shows a compact selector similar in visible height/behavior to native `/model` (limited visible rows with scrolling).
- [ ] Closing the picker (select or cancel) does not shift the editor/input position.
- [ ] Repeating open/close across two `/reload` cycles keeps layout stable.
- [ ] If root cause is in pi extension UI APIs rather than extension code, issue includes a minimal reproducible case and explicit upstream follow-up note.
