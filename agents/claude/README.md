# Claude Code configuration

This directory is the Git-managed home for authored Claude Code configuration.

The initial agent-install pilot deliberately leaves Claude's native configuration local until its current official configuration paths and the distinction between authored settings and runtime/auth state are verified. Add only authored resources here, then extend `bootstrap/agent-config.sh` with individual links; never link credentials, sessions, logs, caches, downloaded binaries, or other generated state.
