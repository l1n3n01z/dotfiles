## Problem Statement

RALPH-loop sessions grow beyond ~50K tokens, degrading quality and speed. The agent can’t reliably detect context size on its own, so it won’t stop in time or reset cleanly. The current loop also lacks clear boundaries for safe resets and for running in a “degraded zone.”

## Solution

Create a pi extension that monitors token usage during `/ralph-loop`, enforces a “smart zone” (≤50K tokens), and automatically resets at safe checkpoints. Split the current `/ralph-loop` into an orchestrator plus a new `/ralph-issue` skill (single-issue execution). The extension manages state, blocks new issues in degraded zone, and creates a clean new session with a handoff message when resetting.

## User Stories

1. As a user, I want `/ralph-loop` to auto-reset when context exceeds 50K tokens, so quality stays high.
2. As a user, I want the loop to continue with the same PRD after an auto-reset, so I don’t have to re-setup.
3. As a user, I want the loop to avoid starting new issues when context is over the limit, so work stays in the smart zone.
4. As a user, I want the current issue to reach a safe checkpoint before reset, so work isn’t left in a half-done state.
5. As a user, I want incomplete or blocked work to be noted on the issue, so progress is visible.
6. As a user, I want a runaway guard (time/turn limit) so a stuck issue doesn’t stall the reset forever.
7. As a user, I want a cap on issues per session, so a long run doesn’t spiral.
8. As a user, I want a cap on auto-resets per PRD run, so it doesn’t loop forever.
9. As a user, I want a status command to see the extension state, so I can debug what it’s doing.
10. As a user, I want `/ralph-loop` to refuse to run if the extension is not active, so I don’t accidentally run without safeguards.
11. As a user, I want `/ralph-loop` to refuse to run when token usage is unavailable, so I don’t operate blind.
12. As a user, I want `/ralph-loop` to use the same PRD-detection flow as today, so it feels consistent.
13. As a user, I want the orchestrator to be read-only, so issue selection stays safe and local.
14. As a user, I want `/ralph-issue` to emit a completion marker, so resets are reliable.
15. As a user, I want counters to persist across auto-resets for the same PRD, so caps are enforced.

## Implementation Decisions

- Create a pi extension that:
  - Uses `ctx.getContextUsage()` and token count only (no percent). Default threshold: 50K tokens.
  - Refuses to run `/ralph-loop` if token usage is unavailable; instructs user to use `/ralph-issue` manually.
  - Tracks last PRD ref, issue count, reset count via `pi.appendEntry()` and carries counters across auto-resets for the same PRD; resets counters when PRD changes.
  - Enforces a fixed issue cap per session: 25 attempted issues (counts all statuses).
  - Enforces a fixed auto-reset cap per PRD run: 25 resets; after cap, notify and continue without further resets, still blocking new issues while over limit.
  - Enters a “degraded zone” when over limit:
    - Blocks starting a new `/ralph-issue` while over limit.
    - If no issue is active, injects a pause message (“Paused due to context cap; waiting for reset”).
    - Allows the current `/ralph-issue` to reach a safe checkpoint and brief post-issue cleanup (bookkeeping only: counters/status), then resets.
    - Safe checkpoint: issue may be incomplete, but add a comment noting incomplete status; attempt tests for changes and note if they cannot complete.
    - Runaway guard: if a `/ralph-issue` exceeds 10 turns or 10 minutes after entering degraded zone, abort, comment “aborted due to context cap,” and reset.
  - Creates a clean new session via `ctx.newSession` (no old-session file access) and injects a handoff message (reason + PRD ref), then re-issues `/ralph-loop` with the same PRD.
  - Skips compaction entirely (fresh session instead).
  - Registers a user command `/ralph-loop-status` to print PRD ref, issue count, reset count, token usage, and zone.
  - Injects a lightweight context marker (e.g., “ralph-loop-extension: active”) so `/ralph-loop` can detect extension presence.

- Split skills:
  - `/ralph-loop` becomes an orchestrator only:
    - Resolves PRD (from stored ref → recent context → PRD-labeled issues → prompt for path).
    - Reads PRD linked issues and selects next actionable issue (priority rules, skip HITL/blocked).
    - Emits `/ralph-issue <issue-ref> (<PRD ref>)`.
    - Increments issue count on `<ralph-issue-complete ...>` regardless of status.
    - Stops after 25 issues per session or when no actionable issues remain (emit `COMPLETE`).
    - Read-only repo inspection allowed for selection (`read`, `git log/status/diff`).
    - Refuses to run unless extension marker is present.
  - `/ralph-issue` executes a single issue:
    - Explore → plan → execute → verify → commit → close/comment.
    - Emits `<ralph-issue-complete status="completed|blocked|incomplete">` at the end.

- PRD progress tracking stays in issue comments/status; do not edit PRD linked-issues list for status updates.

## Testing Decisions

- Manual test: start `/ralph-loop`, push context over 50K, confirm degraded zone blocks new issues and allows current issue to reach safe checkpoint.
- Manual test: verify auto-reset creates a clean session with a handoff message and re-invokes `/ralph-loop` with the same PRD.
- Manual test: hit issue cap (25), verify `/ralph-loop` stops selecting new issues.
- Manual test: hit auto-reset cap (25), verify notification and no further resets.
- Manual test: simulate token usage unavailable; verify `/ralph-loop` refuses and suggests `/ralph-issue`.
- Manual test: runaway guard triggers after 10 turns/10 minutes, comments “aborted due to context cap,” then resets.
- Manual test: `/ralph-loop-status` reports expected state.

## Out of Scope

- Manual reset prompts.
- Changes beyond splitting `/ralph-loop` into `/ralph-loop` + `/ralph-issue`.
- Non-`/ralph-loop` workflows.

## Further Notes

- This PRD defines the ralph-loop harness; it supersedes earlier draft PRDs.

## Linked Issues

- /home/nonni/.pi/notes/issues/ralph-loop-split-ralph-issue.md
- /home/nonni/.pi/notes/issues/ralph-loop-extension-baseline.md
- /home/nonni/.pi/notes/issues/ralph-loop-degraded-zone-reset.md
- /home/nonni/.pi/notes/issues/ralph-loop-caps-runaway-guard.md

## Linked QA

- (to be filled by /qa-plan)
