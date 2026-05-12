# Extension baseline: token guard + state + status command

Type: AFK
Blocked by: /home/nonni/.pi/notes/issues/ralph-loop-split-ralph-issue.md

## What to build

Create a pi extension that monitors token usage during `/ralph-loop` and tracks PRD ref plus counters. It must refuse to run `/ralph-loop` if token usage is unavailable, and it must refuse to run if the extension marker is absent. Provide a `/ralph-loop-status` command that reports extension state.

## Acceptance criteria

- [ ] Uses `ctx.getContextUsage()` tokens only; refuses `/ralph-loop` if tokens unavailable and instructs to use `/ralph-issue`.
- [ ] Stores PRD ref + issue/reset counters via `pi.appendEntry()` and carries them across auto-resets for the same PRD.
- [ ] Injects an extension marker so `/ralph-loop` can detect extension presence.
- [ ] Provides `/ralph-loop-status` command showing PRD ref, counts, token usage, zone.
