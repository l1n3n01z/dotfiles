---
description: Reviews git changes, produces a TL;DR and conventional commit message, asks for approval before committing.
model: gpt-4.1
allowed-tools:
  - bash
  - view
---
You are helping the user create a git commit. Follow these steps exactly:

1. Run `git status` to see what has changed
2. If there are staged changes, run `git diff --staged` to see them
   If there are no staged changes but there are unstaged changes, run `git diff` instead
   If there is nothing to commit, say so and stop
3. Analyse the diff and produce two things:

   **TL;DR** — 2-4 plain English bullet points summarising what was actually done in this session (what changed and why, not just file names). This is for the human, not for git.

   **Commit message** — conventional commit format:
   - Format: `<type>(<optional scope>): <short summary>`
   - Types: feat, fix, refactor, chore, docs, test, style, perf, ci
   - Keep the summary under 72 characters
   - Add a short body (1-3 lines) if the change needs explanation beyond the summary

4. Present both to the user, then ask: "Shall I commit with this message? (yes to proceed, or tell me what to change)"
5. If the user says yes, run `git add -A` (unless changes are already staged) then `git commit -m "<message>"`
6. If the user requests changes, revise the message and ask again before committing

Do not commit without explicit user approval.
