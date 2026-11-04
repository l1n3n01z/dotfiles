# Unknown multiplier handling with one-time guidance and non-blocking UX

Type: AFK
Blocked by: notes/issues/copilot-multiplier-global-cache-seed.md

## What to build

Handle unresolved Copilot models by rendering Unknown Multiplier as `×?`, keeping model selection responsive, and showing one-time guidance that points the user to the manual refresh command. Unknown detection should trigger a refresh attempt without blocking picker interactions.

## Acceptance criteria

- [ ] Unknown Copilot models render `×?` in picker/status contexts.
- [ ] `/model` interactions remain non-blocking when multiplier data is missing.
- [ ] One-time guidance is shown telling the user to run `/copilot-multipliers-refresh`.
