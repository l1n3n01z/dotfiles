---
name: ralph-loop
description: Autonomous loop that takes a PRD and works through its linked GitHub issues one by one, implementing and closing each. Use only when the user explicitly invokes /ralph-loop.
---

# RALPH Loop (PRD → Issues)

## Style guardrails

- Prefer simple procedures and explicit data flow.
- Keep behavior close to where it's used.
- Minimize dependencies; avoid new frameworks.
- Hard bans: mediator/dispatcher frameworks, DI containers, magic/reflection/codegen, action-at-a-distance.
- Avoid abstractions or layers without immediate, local payoff.

## Quick start

1. Get the PRD from context (GitHub issue or file). If not present:
   - If inside a git repo and GitHub access works, list open issues with the `PRD` label and ask which to use.
   - Otherwise ask the user for the PRD file path.
2. If the PRD is a GitHub issue, read its `## Linked Issues` section for issue URLs.
3. If the PRD is a file, read its `## Linked Issues` section for file paths.
4. If no linked issues are found, ask the user for the issue list.
5. Select the next actionable issue using the priority rules below.
6. Emit `/ralph-issue <issue-ref> (<PRD ref>)` and wait for the completion marker.
7. On any completion marker status, increment the issue count and select the next issue.

## Priority order

1. **Bug fixes** — broken behavior affecting users
2. **Tracer bullets** — thin end‑to‑end slices that prove an approach works
3. **Polish** — small UX/docs/error improvements
4. **Refactors** — internal cleanup with no user‑visible change

Pick the highest‑priority issue that is not blocked and is not labeled `HITL`. For file-based issues, skip any with `Type: HITL`.

## Orchestrator loop

1. **Explore** — read the issue list, PRD, and issue metadata (read-only).
2. **Select** — choose the next actionable issue.
3. **Dispatch** — output `/ralph-issue <issue-ref> (<PRD ref>)`.
4. **Observe** — wait for `<ralph-issue-complete status="completed|blocked|incomplete">`.
5. **Advance** — record one issue attempt and continue selection.

## Rules

- Orchestrator only: read-only repo inspection (`read`, `git log/status/diff`). Do not edit files, run tests, or commit.
- One issue per iteration.
- If no actionable issues remain, output `COMPLETE`.
