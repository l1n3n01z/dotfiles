---
name: ralph-issue
description: Execute a single issue end-to-end for /ralph-loop and emit a completion marker. Use only when the user explicitly invokes /ralph-issue.
---

# RALPH Issue (single issue executor)

## Style guardrails

- Prefer simple procedures and explicit data flow.
- Keep behavior close to where it's used.
- Minimize dependencies; avoid new frameworks.
- Hard bans: mediator/dispatcher frameworks, DI containers, magic/reflection/codegen, action-at-a-distance.
- Avoid abstractions or layers without immediate, local payoff.

## Quick start

1. Read the issue and PRD reference from the command args.
2. Explore relevant code/tests.
3. Plan the smallest viable change.
4. Execute, verify, commit, and close/comment.
5. Emit the completion marker.

## Execution loop

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
6. **Close** — close the issue with a short summary of what changed.

## Status outcomes

- **completed** — change merged and issue closed.
- **blocked** — missing context, failing tests you can’t fix, external deps.
- **incomplete** — partial progress; add a comment with current state and next steps.

## Rules

- One issue only.
- If blocked, comment on the issue and stop.
- If you discover missing work that needs a new issue, create it via `/to-issues` and update the PRD’s **Linked Issues** before proceeding.
- Do not leave TODOs or commented‑out code.

## Completion marker

Emit exactly one marker at the end of the run:

<ralph-issue-complete status="completed|blocked|incomplete">
