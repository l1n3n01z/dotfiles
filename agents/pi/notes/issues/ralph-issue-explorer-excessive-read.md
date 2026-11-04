# Bug: issue explorer reads excessively during next-issue selection

Type: AFK
Blocked by: None

## What to build

Reduce read volume in the ralph issue-selection path so selecting the next actionable issue does not read full issue documents unless needed. The selector should use lightweight metadata first (linked-issue order, type, blocked status) and only read deeper content when required to break ties or resolve ambiguity.

## Acceptance criteria

- [ ] Next-issue selection avoids full-file reads for every linked issue in the common case.
- [ ] Selector determines actionable ordering from minimal data: bug/tracer/polish/refactor priority and blocked status.
- [ ] File reads are bounded and proportional to ambiguity (for example: header-only read first, escalate only when needed).
- [ ] Existing selection behavior remains correct (same chosen issue for existing ralph PRD issue sets).
- [ ] Add a short note in the implementation describing the read-minimization approach.
