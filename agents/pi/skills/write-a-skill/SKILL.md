---
name: write-a-skill
description: Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use only when the user explicitly invokes /write-a-skill.
---

# Writing Skills

## Quick start

1. Ask whether this is a coding skill or non-coding skill.
2. Gather requirements (task/domain, use cases, scripts vs instructions, references).
3. Draft SKILL.md + any reference files/scripts.
4. Review with the user.

See [REFERENCE.md](REFERENCE.md) for templates, checklists, and detailed guidance.

## Coding-Skill Constraints (only for coding skills)

### Hard bans (no exceptions without explicit user approval)

- No mediator/dispatcher frameworks.
- No DI containers or inversion-heavy architecture.
- No magic/implicit reflection, hidden codegen, or action-at-a-distance behavior.
- No dependency sprawl: keep third-party libraries to a minimum.
- No architectural layers or abstractions without immediate, local payoff.

### Positive preferences (do these)

- Locality-of-behavior: keep logic near its use.
- Simple procedures and explicit data flow.
- Small, cohesive modules with direct dispatch (plain if/else/switch).
- Boring, readable code that reads top-to-bottom.
- Clear naming over cleverness.
