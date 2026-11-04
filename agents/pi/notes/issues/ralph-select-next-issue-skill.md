# Add single-issue selector skill (PRD → next issue)

Type: AFK
Blocked by: None

## What to build

Add a new skill that selects a single next actionable issue using the same PRD-resolution and issue-selection mechanics as `/ralph-loop`, then emits the chosen issue reference. This is a one-shot selector meant for manual control or external orchestration.

## Acceptance criteria

- [ ] Skill resolves PRD using the same flow as `/ralph-loop` (stored ref → recent context → PRD-labeled issues → prompt for path).
- [ ] Skill reads the PRD `## Linked Issues` list and applies the same priority/skip rules as `/ralph-loop` (skip HITL/blocked).
- [ ] Skill outputs a single selected issue ref (no looping, no execution).
- [ ] If no actionable issues remain, outputs `COMPLETE`.
