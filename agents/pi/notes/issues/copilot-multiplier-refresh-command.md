# Manual refresh command for Copilot multipliers

Type: AFK
Blocked by: notes/issues/copilot-multiplier-global-cache-seed.md

## What to build

Add `/copilot-multipliers-refresh` to refresh multiplier data on demand and write results to the global cache. Command output should summarize outcomes concisely so users can trust what changed.

## Acceptance criteria

- [ ] `/copilot-multipliers-refresh` runs and updates the global Multiplier Cache when new data is available.
- [ ] Command output reports concise result states (for example updated count, unchanged, failed).
- [ ] Refresh can be run independently of `/model` interactions.
