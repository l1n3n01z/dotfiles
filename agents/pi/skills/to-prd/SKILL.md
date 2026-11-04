---
name: to-prd
description: Turn the current conversation context into a PRD. Use only when the user explicitly invokes /to-prd.
---

This skill takes the current conversation context and codebase understanding and produces a PRD. Do NOT run a full interview — just synthesize what you already know, then do a brief confirmation check if needed.

## Style guardrails for implementation

- Prefer simple procedures and explicit data flow.
- Keep behavior close to where it's used. Locality of behavior.
- Minimize dependencies; avoid new frameworks.
- Hard bans: mediator/dispatcher frameworks, magic/reflection/codegen, action-at-a-distance.
- Avoid abstractions or layers without immediate, local payoff.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary throughout the PRD, and respect any ADRs in the area you're touching.

If you need to read or update a GitHub issue and you're unsure you have access, run `gh auth status` and proceed based on the result.

2. Sketch out the major modules you will need to build or modify to complete the implementation. Prefer cohesive modules with simple interfaces; avoid layering for its own sake.

If expectations are unclear, do a **short checkpoint** with the user (one or two questions max) to confirm modules and testing scope.

3. Decide PRD storage, then write the PRD using the template below.

- If inside a git repo, run `gh auth status`.
  - If authenticated, create a GitHub issue and apply the `PRD` label.
  - If not authenticated, stop and ask the user whether to fix auth or fall back to a file.
- If not inside a git repo, write to a local file:
  - Walk up from the current directory to repo root looking for a `notes/` directory.
  - If found, write to `notes/prd/<slug>.md` (create `prd/` if missing).
  - If no `notes/` found, ask the user where to put the PRD.
- Infer `<slug>` from the feature name or problem statement. If unclear, ask the user.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

## Linked Issues

- (to be filled by /to-issues)

## Linked QA

- (to be filled by /qa-plan)

</prd-template>
