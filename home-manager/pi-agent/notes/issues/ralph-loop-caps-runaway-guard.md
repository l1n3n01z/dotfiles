# Caps + runaway guard behaviors

Type: AFK
Blocked by: /home/nonni/.pi/notes/issues/ralph-loop-extension-baseline.md, /home/nonni/.pi/notes/issues/ralph-loop-degraded-zone-reset.md

## What to build

Add caps and runaway guards to the extension: fixed issue cap per session, fixed auto-reset cap per PRD run, and a time/turn runaway cutoff after entering degraded zone.

## Acceptance criteria

- [ ] Issue cap: stop selecting new issues after 25 attempts per session.
- [ ] Auto-reset cap: after 25 resets per PRD run, notify and continue without further resets (still block new issues while over limit).
- [ ] Runaway guard: if a `/ralph-issue` exceeds 10 turns or 10 minutes after entering degraded zone, comment “aborted due to context cap” and reset.
