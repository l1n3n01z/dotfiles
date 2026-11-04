---
name: pi-extension-hitl
description: Human-in-the-loop workflow for building and debugging pi extensions safely from inside a running pi session. Use when working on pi extensions, /reload loops, recovery from bad extension edits, or when the user must validate UI behavior (notify/status/model picker) between iterations.
---

# Pi Extension HITL Loop

Use this when extension work needs live user verification and safe reload/recovery.

## Quick start

1. Confirm scope + expected visible signal (picker label, status line, notify, command output).
2. Implement the smallest change.
3. Ask user to run `/reload`.
4. Ask user to report exactly what they saw.
5. Decide: keep, patch, or rollback.

## Coding guardrails

- Keep logic local and procedural.
- Prefer tiny edits over broad refactors.
- No DI containers, mediator layers, or reflection/magic.
- Avoid abstractions unless they pay off immediately.
- Docs-first for pi extension work: read `docs/extensions.md` and relevant examples before implementation.
- Inspect runtime/internal code only when docs leave an explicit API gap, and state that reason before doing so.

## Loop (must follow)

### 1) Safety preflight

- Keep extension in auto-discovered path (`~/.pi/agent/extensions/` or `.pi/extensions/`) so `/reload` works.
- Add a temporary debug prefix for all diagnostics, e.g. `[copilot-mult]`.
- Define one rollback action before editing.

### 2) Add observable diagnostics

Use at least one visible signal per iteration:
- `ctx.ui.notify()` for one-shot checkpoints.
- `ctx.ui.setStatus()` for persistent state.
- Optional debug command (`/ext-debug`) to print current in-memory/cache state.

### 3) Reload as a terminal step

- Apply code change.
- Ask user to run `/reload`.
- Treat reload as terminal for that step (no assumptions until user confirms observations).

### 4) Structured user feedback

Always ask for:
- exact command/action used,
- exact text rendered,
- whether signal appeared once or repeatedly,
- whether behavior changed after a second `/reload`.

### 5) Decide next move

- If observed == expected: remove noisy debug output, keep one durable status signal if useful.
- If mismatch: patch one variable only, rerun loop.
- If broken: execute rollback plan first, then continue with smaller change.

## Recovery playbook

Use fastest safe recovery first:
1. Revert latest extension edit.
2. Temporarily disable extension by renaming file/folder (`*.disabled`) and run `/reload`.
3. If runtime is wedged, restart pi after disabling the extension on disk.

## Done criteria

- Behavior verified by user in live UI.
- Reload is repeatable (works across two reloads).
- Temporary debug notifications removed or gated behind a debug flag.
