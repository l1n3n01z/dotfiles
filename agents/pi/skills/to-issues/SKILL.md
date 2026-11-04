---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable GitHub issues using tracer-bullet vertical slices. Use only when the user explicitly invokes /to-issues.
---

# To Issues

Break a plan into independently-grabbable issues using vertical slices (tracer bullets).

## Style guardrails for implementation

- Prefer simple procedures and explicit data flow.
- Keep behavior close to where it's used.
- Minimize dependencies; avoid new frameworks.
- Hard bans: mediator/dispatcher frameworks, DI containers, magic/reflection/codegen, action-at-a-distance.
- Avoid abstractions or layers without immediate, local payoff.

## Process

### 1. Find the PRD

Work from whatever is already in the conversation context.

- If the PRD is a GitHub issue (URL or #number), fetch it from GitHub and read its full body and comments. If you're unsure you have GitHub access, run `gh auth status` and proceed based on the result.
- If the PRD is a file path, read it.
- If no PRD is in context:
  - If inside a git repo and GitHub access works, list open issues with the `PRD` label and ask the user which one to use.
  - Otherwise ask the user for the PRD file path.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible. When publishing issues, apply a `HITL` label to HITL slices.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Publish the issues

If the PRD is a GitHub issue, publish the issues in dependency order (blockers first). Apply the `HITL` label to HITL slices. Then update the PRD issue body to include a `## Linked Issues` section with the new issue URLs.

If the PRD is a file, write issue files under `notes/issues/` (create the directory if missing). Use the file template below and include `Type: HITL` or `Type: AFK` at the top. Then update the PRD file to include a `## Linked Issues` section with the new file paths.

### 6. Optional triage

If the user wants agent briefs or state labels beyond HITL/AFK, run `/triage` on the new issues to add brief comments or set `ready-for-agent`.

<issue-template>
## Parent

A reference to the parent issue on the issue tracker (if the source was an existing issue, otherwise omit this section).

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

Avoid specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it here and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- A reference to the blocking ticket (if any)

Or "None - can start immediately" if no blockers.
</issue-template>

Do NOT close or modify any parent issue.

## File issue template

```
# <Title>

Type: HITL | AFK
Blocked by: <issue file path or "None">

## What to build

[Concise end-to-end behavior]

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3
```
