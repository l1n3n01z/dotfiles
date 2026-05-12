## Problem Statement

RALPH-loop sessions can grow beyond ~50K context, causing slowdowns and degraded behavior. The agent itself can’t see context size, so it won’t reliably stop or reset.

## Solution

Add a pi extension that monitors context usage and auto-resets at a safe checkpoint during `/ralph-loop`. Split the current `/ralph-loop` into orchestration + a new `/ralph-issue` skill that tackles one issue end-to-end, so the extension can manage resets between issues. The extension should start a fresh session and re-invoke `/ralph-loop` with the same PRD reference.

## User Stories

1. As a user, I want `/ralph-loop` to auto-reset when context exceeds 50K tokens, so quality stays high.
2. As a user, I want the loop to continue with the same PRD after an auto-reset, so I don’t have to re-setup.
3. As a user, I want auto-resets only during `/ralph-loop`, so other workflows aren’t interrupted.
4. As a user, I want a safe checkpoint (comment if incomplete, attempt tests, note failures) before resetting.
5. As a user, I want a hard cap on auto-resets per PRD run, so it doesn’t loop forever.
6. As a user, I want a cap on issues per session, so a long run doesn’t spiral.
7. As a user, I want `/ralph-loop` to orchestrate and `/ralph-issue` to handle one issue, so resets happen between issues.

## Implementation Decisions

- Extension hooks into pi session events to read context usage from the runtime (token/context usage surfaced in pi state).
- Threshold is token-based only, default 50K tokens. If token usage is unavailable, the extension refuses to run `/ralph-loop` and instructs the user to run manually (e.g., `/ralph-issue` or `/ralph-once`).
- Add an issue-count cap per session: 25 issues (fixed hard cap).
- Add a hard cap on auto-resets per PRD run: 25 resets.
- Modify `/ralph-loop` to orchestrate only (issue selection + PRD context), delegating execution to `/ralph-issue`.
- `/ralph-loop` may perform read-only repo inspection (read files, `git log/status/diff`) to aid issue selection.
- Add `/ralph-issue` skill for single-issue flow (explore → plan → execute → verify → commit → close) and emit a final machine-readable marker like `<ralph-issue-complete status="completed|blocked|incomplete">`.
- When threshold exceeded or issue cap hit and `/ralph-loop` is active:
  - enter “degraded zone”: **block** starting a new `/ralph-issue` while over the limit.
  - if no issue is active, inject a pause message (“Paused due to context cap; waiting for reset”).
  - allow the current `/ralph-issue` run to reach a safe checkpoint and permit brief post-issue cleanup (bookkeeping only: counters/status), then auto-start a new session and re-issue `/ralph-loop` with the same PRD reference.
  - Safe checkpoint: issue may be incomplete, but add a comment noting incomplete status; attempt tests for changes and note if they cannot complete.
  - Runaway guard: if a `/ralph-issue` exceeds 10 turns or 10 minutes after entering degraded zone, abort, comment “aborted due to context cap”, and reset.
- If the auto-reset cap is reached, emit a notification and continue without further resets (still avoiding starting new issues when already over the limit).
- The extension stores last PRD reference and counters (auto-reset count, issue count) in session-local state and carries them across auto-resets for the same PRD; reset counters when a different PRD ref is invoked.
- On auto-reset, start a clean session via `newSession` and inject a brief handoff message (why reset + PRD ref).
- Provide a user command `/ralph-loop-status` that prints extension state (PRD ref, issue count, reset count, token usage, zone).

## Testing Decisions

- Manual test: start `/ralph-loop`, simulate context usage above threshold, verify safe checkpoint then auto-reset starts a new session with same PRD.
- Manual test: hit issue cap, verify safe checkpoint then auto-reset starts a new session with same PRD.
- Manual test: hit auto-reset cap, verify it stops auto-resetting and emits a notification.
- Verify no auto-reset occurs outside `/ralph-loop`.

## Out of Scope

- Prompt-driven/manual resets (this is automatic only).
- Changes beyond splitting `/ralph-loop` into `/ralph-loop` + `/ralph-issue` (only this refactor is in scope).
- Non-`/ralph-loop` workflows.

## Guardrails

- `/ralph-loop` must refuse to run unless the extension is active; otherwise instruct to use `/ralph-issue` manually.

## Further Notes

- If pi does not expose context usage to extensions, fall back to detecting message count or approximate token size.
