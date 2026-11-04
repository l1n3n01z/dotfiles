# Split /ralph-loop and add /ralph-issue marker

Type: AFK
Blocked by: None

## What to build

Split `/ralph-loop` into an orchestrator-only skill and a new `/ralph-issue` skill that handles a single issue end-to-end. The orchestrator should resolve PRD input, select the next actionable issue, and emit `/ralph-issue <issue-ref> (<PRD ref>)`. The new `/ralph-issue` must emit a final machine-readable completion marker with status (`completed|blocked|incomplete`).

## Acceptance criteria

- [x] `/ralph-loop` reads the PRD, selects the next actionable issue, and emits `/ralph-issue <issue-ref> (<PRD ref>)`.
- [x] `/ralph-loop` stops when no actionable issues remain and outputs `COMPLETE`.
- [x] `/ralph-issue` executes one issue and emits `<ralph-issue-complete status="completed|blocked|incomplete">`.
- [x] `/ralph-loop` increments its issue count on any completion marker status.
