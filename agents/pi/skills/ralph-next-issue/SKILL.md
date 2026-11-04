---
name: ralph-next-issue
description: Select a single next actionable issue from a PRD using the ralph-loop selection rules. Use only when the user explicitly invokes /ralph-next-issue.
---

# RALPH Next Issue (one-shot selector + optional execution)

## Style guardrails

- Prefer simple procedures and explicit data flow.
- Keep behavior close to where it's used.
- Minimize dependencies; avoid new frameworks.
- Hard bans: mediator/dispatcher frameworks, DI containers, magic/reflection/codegen, action-at-a-distance.
- Avoid abstractions or layers without immediate, local payoff.

## Quick start

1. Resolve the PRD reference (stored ref → recent context → PRD-labeled issues → prompt for path).
2. Read the PRD `## Linked Issues` list.
3. Select the next actionable issue using ralph-loop priority/skip rules.
4. If the issue is AFK and confidence is high, execute it end-to-end (like `/ralph-issue`).
5. If the issue is HITL or confidence is low, present the issue and ask the user for guidance.
6. If no issue remains, output `COMPLETE`.

## PRD resolution

1. Use a stored PRD ref in recent context if available.
2. If inside a git repo and GitHub access works, list open issues with the `PRD` label and ask which to use.
3. Otherwise ask the user for the PRD file path.

## Selection rules

Priority order:

1. **Bug fixes** — broken behavior affecting users
2. **Tracer bullets** — thin end‑to‑end slices that prove an approach works
3. **Polish** — small UX/docs/error improvements
4. **Refactors** — internal cleanup with no user‑visible change

Skip any issue that is blocked. Do **not** skip HITL; instead, route to human collaboration.

## Output

- If executing AFK: summarize plan, then execute and report completion in plain language (no machine markers).
- If HITL or low confidence: output the issue reference and a short prompt for the user to decide next steps.
- If none remain, output `COMPLETE`.

## Confidence rubric (auto-execute when all apply)

- Scope is small and localized.
- Acceptance criteria are clear and testable.
- No external dependencies or ambiguous product decisions.
- No risky data migrations or irreversible changes.
- Tests are straightforward and fast to run.

## Execution steps (when running AFK)

1. **Explore** — read the issue, pull the PRD, and read relevant code/tests.
2. **Plan** — smallest viable change; keep it local.
3. **Execute** — implement. Tests only when they lock the behavior without ceremony.
4. **Verify** — run the fastest relevant checks. Prefer repo‑specific commands; if .NET, default to `dotnet test` or the smallest affected project.
5. **Commit** — single commit using the hybrid human-first format below.

   Subject: `<plain-English summary> · <type>(<scope>)`
   - Put human-readable summary first (imperative, specific, ≤72 chars before metadata where possible).
   - Required metadata in subject: `<type>(<scope>)`, where type ∈ {feat, fix, refactor, docs, test, chore}.
   Body (required for non-trivial changes):
   - `Why:` 1–2 short bullets
   - `What:` 1–3 short bullets

   Footers:
   - `Refs: <issue-ref>` (required)
   - `PRD: <prd-ref>` (include when available)

   Keep messages compact. Prefer 1-line body bullets.
   Do not include raw file lists in the commit message.

   Concise examples:

   Trivial change (subject only):
   - `Handle empty tracking id · fix(api)`

   Non-trivial change:
   ```
   Handle empty tracking id · fix(api)

   Why: avoid 500 on empty carrier payload.
   What: return 400; add validation test.

   Refs: #123
   PRD: #45
   ```

   Avoid:
   - `RALPH: <issue> (<PRD ref>)`
   - Multi-paragraph commit essays
6. **Close/Comment** — close the issue or comment with status and summary.

## Rules

- If executing: follow the execution steps above.
- If HITL: collaborate with the user to resolve decisions, then proceed when unblocked.
- If unsure, ask before making risky changes.
