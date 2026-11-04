---
name: qa-plan
description: Create a manual QA plan from a PRD and publish it as a HITL GitHub issue. Use only when the user explicitly invokes /qa-plan.
---

# Manual QA Plan (from PRD)

## Quick start

1. Get the PRD from context (GitHub issue or file); if not present, ask the user.
2. Read the PRD and extract user stories, key flows, and constraints.
3. Produce a manual QA checklist.
4. Publish as a HITL GitHub issue if the PRD is a GitHub issue; otherwise write `notes/qa-<prd-slug>.md`.

## Process

### 1. Locate PRD

- If the PRD is a GitHub issue (URL or #number), fetch it. If unsure about access, run `gh auth status`. If not authenticated, stop and ask the user how to proceed.
- If the PRD is a file path, read it.
- Otherwise ask the user for the PRD path before continuing.

### 2. Build the QA plan

Use the PRD’s domain language. Turn user stories into concrete manual checks.

Include:

- Happy-path flows
- Key edge cases
- Error handling and validation
- State changes / persistence checks
- Permissions/roles (if relevant)
- UX clarity (copy, empty states)
- Regression risks for adjacent areas

### 3. Publish as HITL issue or file

- If the PRD is a GitHub issue, create a **HITL** issue titled:
  - `Manual QA Plan: <PRD title>`
  - Apply the `HITL` label.
  - Update the PRD issue body to include a `## Linked QA` section with the new issue URL.
- If the PRD is a file, write `notes/qa-<prd-slug>.md` and update the PRD file to include a `## Linked QA` section with the new file path.

## Issue template

```
## PRD

- <link or path>

## Goal

What manual QA is trying to prove.

## Preconditions

Any setup needed before testing.

## Test checklist

- [ ] Scenario 1 (happy path)
- [ ] Scenario 2 (edge case)
- [ ] Scenario 3 (error handling)

## Out of scope

Anything explicitly excluded.

## Notes

Any extra context, risks, or known gaps.
```

## File fallback template

Use the same sections as the issue template.
