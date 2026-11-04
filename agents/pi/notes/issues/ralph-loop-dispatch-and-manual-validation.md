# Fix ralph-loop dispatch + validate completed issues with HITL feedback

Type: HITL
Blocked by: None

## What to build

Make `/ralph-loop` dispatch observable and reliable in sessions where auto-execution does not trigger, then run a manual validation pass for issues currently marked completed. Use user-driven checks and record feedback to confirm real completion status.

## Acceptance criteria

- [ ] Running `/ralph-loop` clearly dispatches one issue at a time with visible next-step instructions for the user.
- [ ] If auto-execution is unavailable, the workflow explicitly asks the user to run the emitted `/ralph-issue ...` command and waits for feedback.
- [ ] A manual validation checklist exists for issues currently marked completed.
- [ ] User feedback is collected per completed issue (`confirmed`, `incomplete`, or `blocked`).
- [ ] Any issue found incomplete is re-opened as a follow-up issue with concrete remaining work.

## Suggested manual validation checklist

1. Run `/ralph-loop` from the PRD context.
2. Confirm whether dispatch is visible and actionable.
3. Execute one emitted `/ralph-issue ...` command manually.
4. Verify whether expected completion behavior occurs.
5. Repeat quick spot checks for issues marked completed.
6. Record status and gaps for each checked issue.
