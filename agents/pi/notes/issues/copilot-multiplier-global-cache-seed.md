# Global Multiplier Cache with first-run seeded bootstrap

Type: AFK
Blocked by: notes/issues/copilot-multiplier-label-baseline.md

## What to build

Introduce a global Multiplier Cache at `~/.pi/agent/copilot-multipliers.json` as the primary runtime data source, and seed it from bundled defaults when missing so first-run behavior is usable immediately without manual setup.

## Acceptance criteria

- [ ] Extension reads multipliers from `~/.pi/agent/copilot-multipliers.json` during runtime lookup.
- [ ] First run initializes the global cache from bundled seed data when the file does not exist.
- [ ] Known seeded models render deterministic multiplier labels across repeated `/model` openings.
