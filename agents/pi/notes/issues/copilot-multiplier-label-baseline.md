# Copilot multiplier label baseline in picker and status line

Type: AFK
Blocked by: notes/issues/copilot-extension-hitl-skill.md

## What to build

Add a standalone extension that enriches model labels only for provider `github-copilot` so `/model` picker entries and the persistent status-line model label show a compact Copilot Model Multiplier suffix using `×N` formatting for known models. Leave non-Copilot providers unchanged.

## Acceptance criteria

- [ ] `/model` shows multiplier suffixes for known `github-copilot` models.
- [ ] Status-line model label includes the same multiplier suffix for the selected `github-copilot` model.
- [ ] Non-Copilot providers do not display multiplier UI.
