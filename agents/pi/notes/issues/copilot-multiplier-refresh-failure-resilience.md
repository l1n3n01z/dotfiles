# Refresh failure resilience and manual fallback guidance

Type: AFK
Blocked by: notes/issues/copilot-multiplier-unknown-and-guidance.md, notes/issues/copilot-multiplier-refresh-command.md

## What to build

Ensure refresh failures degrade gracefully: keep last known cache values, never block `/model`, and provide fallback guidance to manually edit the global cache so users can recover quickly.

## Acceptance criteria

- [ ] Refresh failures do not block `/model` usage.
- [ ] Existing cache values are retained when refresh fails.
- [ ] Failure output includes manual cache-edit fallback guidance.
