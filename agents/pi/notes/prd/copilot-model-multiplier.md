## Problem Statement

When selecting models in pi, GitHub Copilot models do not show the Copilot Model Multiplier. This makes it hard to understand model cost impact during `/model` selection and when viewing the current model in the status line. Because GitHub’s multiplier table changes over time, hardcoded values quickly drift.

## Solution

Add a dedicated extension that enriches `github-copilot` model labels with a Copilot Model Multiplier shown as `×N` (or `×?` when unknown). The extension uses a global Multiplier Cache at `~/.pi/agent/copilot-multipliers.json`, seeded for first-run usability, with manual refresh support and soft-failure behavior so `/model` stays fast and never blocks.

## User Stories

1. As a Copilot user, I want to see a Copilot Model Multiplier in the `/model` picker, so I can choose models with cost awareness.
2. As a Copilot user, I want the current-model status line to include the Copilot Model Multiplier, so I can continuously see cost context.
3. As a Copilot user, I want multiplier formatting to be compact (`×N`), so the UI stays readable.
4. As a Copilot user, I want unknown multipliers shown as `×?`, so uncertainty is explicit.
5. As a Copilot user, I want unknown multipliers to not block model selection, so workflow remains fast.
6. As a Copilot user, I want first-run multiplier values to work immediately, so setup is zero-friction.
7. As a Copilot user, I want a seeded cache that can be updated later, so initial UX is good and data can evolve.
8. As a Copilot user, I want the cache to be global, so multiplier behavior is consistent across all projects.
9. As a Copilot user, I want a manual refresh command, so I can update data when GitHub changes multipliers.
10. As a Copilot user, I want refresh command output to summarize what happened, so I can trust update results.
11. As a Copilot user, I want one-time guidance when a multiplier is unknown, so I know to run refresh.
12. As a Copilot user, I want refresh failures to degrade gracefully, so I can keep working with last known data.
13. As a Copilot user, I want refresh failures to point to manual cache editing fallback, so I can recover quickly.
14. As a user of other providers, I want no multiplier UI for non-Copilot providers, so unrelated providers remain unchanged.
15. As a maintainer, I want a separate extension module for this behavior, so it is isolated and easy to disable.
16. As a maintainer, I want no coupling to ralph-loop behavior, so unrelated workflows are unaffected.
17. As a maintainer, I want a simple data model and direct lookup path, so behavior stays local and easy to reason about.
18. As a maintainer, I want the extension to avoid background refresh on every `/model`, so picker latency stays low.
19. As a maintainer, I want refresh to trigger only on unknown model or manual command, so network usage stays intentional.
20. As a maintainer, I want deterministic UI rendering for known models, so repeated picker openings stay stable.

## Implementation Decisions

- Build a standalone extension focused on Copilot multiplier presentation only.
- Limit provider matching to exact `github-copilot`.
- Introduce Copilot Model Multiplier rendering in two places:
  - `/model` picker label
  - persistent status-line model label
- Use Unicode multiplication sign `×` in UI (`×1`, `×1.25`, `×2`, `×?`).
- Add a global Multiplier Cache file at `~/.pi/agent/copilot-multipliers.json` as primary runtime source.
- Ship a seeded multipliers dataset bundled with the extension and use it on first run when no global cache exists.
- Keep refresh policy intentionally narrow for speed:
  - no stale-on-open refresh
  - refresh on unknown Copilot model detection
  - refresh via `/copilot-multipliers-refresh`
- On unknown model:
  - render `×?`
  - trigger a refresh attempt
  - show a one-time guidance message to run `/copilot-multipliers-refresh`
- On refresh failure:
  - retain existing cache values
  - never block `/model` interactions
  - include fallback guidance to manually edit global cache.
- Refresh command returns concise result states such as updated count, unchanged, or failed.
- Keep implementation procedural and local: load cache, lookup by provider/model, render label, optionally refresh.

## Testing Decisions

- Good tests validate external behavior (display labels, command outcomes, fallback behavior), not internal helpers.
- Cover extension behavior modules:
  - cache load/seed/fallback behavior
  - Copilot-only label enrichment
  - unknown model handling and one-time guidance
  - refresh command result messaging
  - non-blocking `/model` behavior under failure
- Prefer focused tests around event handlers and command output, with lightweight fixture data for seeded/global cache.
- Manual verification should confirm:
  - `/model` picker shows `×N` for known Copilot models
  - status-line model label includes `×N`
  - unknown model shows `×?` and guidance appears once
  - `/copilot-multipliers-refresh` prints concise result and updates cache when successful.

## Out of Scope

- General pricing display for non-Copilot providers.
- Real-time background polling on timer.
- Blocking model selection on stale or missing multiplier data.
- Building a generic pricing framework across providers.
- Changes to ralph-loop orchestration or issue automation.

## Further Notes

- GitHub multiplier docs are expected to evolve; this design prioritizes local resilience and manual control.
- Domain terms in this PRD align with the repo context language: Copilot Model Multiplier, Multiplier Cache, and Unknown Multiplier.

## Linked Issues

- notes/issues/copilot-extension-hitl-skill.md
- notes/issues/copilot-multiplier-label-baseline.md
- notes/issues/copilot-multiplier-global-cache-seed.md
- notes/issues/copilot-multiplier-unknown-and-guidance.md
- notes/issues/copilot-multiplier-refresh-command.md
- notes/issues/copilot-multiplier-refresh-failure-resilience.md
- notes/issues/copilot-model-picker-ui-regression.md

## Linked QA

- (to be filled by /qa-plan)
