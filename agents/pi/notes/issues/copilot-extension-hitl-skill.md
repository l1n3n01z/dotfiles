# Add pi extension HITL skill for reload/debug/recovery

Type: AFK
Blocked by: None

## What to build

Create and adopt a dedicated skill for pi extension work that enforces a human-in-the-loop reload cycle, explicit observable diagnostics, and a recovery path when an extension edit breaks runtime behavior. The workflow should require user verification after `/reload` so extension development does not run blind.

## Acceptance criteria

- [x] A skill exists for pi extension HITL development with guidance for `/reload`, user feedback collection, and rollback.
- [x] The workflow explicitly recommends visible diagnostics (for example `notify`/status) during iteration.
- [x] The workflow includes a practical recovery playbook (disable extension, reload/restart, recover safely).
