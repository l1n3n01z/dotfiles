# Agent tooling and WSL bootstrap plan

Implement the workstation-tool-ownership decision in two reversible phases. This is a personal dotfiles plan, not a PRD or issue tracker.

## Phase 1 — evergreen agent cohort and fresh WSL bootstrap

### Pilot on the existing Ubuntu 24.04 WSL distribution

- [x] Research each tool's current official Linux installer, update command, installation location, and verification mechanism:
  - Pi
  - Claude Code
  - GitHub Copilot CLI
- [x] Prefer verifiable upstream release artifacts; when a vendor provides only an official installer, document that explicit exception and report its source/version.
- [x] Add a small `bootstrap/` command surface:
  - [ ] WSL host-readiness doctor: WSL2, systemd, DNS/HTTPS, GitHub reachability, and optional browser/WSLg diagnostics.
  - [ ] WSL bootstrap: only APT bootstrap prerequisites, Nix installation when absent, and Home Manager activation. Never run Ubuntu package, release, or `full-upgrade` updates.
  - [ ] Agent installation/update command: update Pi, Claude Code, and Copilot CLI independently; continue after an individual failure; report previous/resulting version and verification result; exit non-zero if any tool failed.
  - [ ] Agent configuration status/link command: create only allowlisted configuration links, back up known existing regular paths with a timestamp before replacement, no-op for correct links, and report unknown candidate files without modifying them.
- [x] Keep all agent authentication interactive. Bootstrap may report login commands and browser/device-code fallback but must never copy credentials, tokens, browser session state, or SSH private keys.
- [ ] Keep current Home Manager Pi/Copilot/Node setup as a fallback during the pilot. Make upstream agent selection explicit so same-named commands cannot silently race on `PATH`.
- [x] Verify Pi loads its existing authored extensions after every Pi update. Keep the newest Pi and fail loudly on an extension incompatibility; do not silently roll back.
- [x] Observe existing WSL browser-opening behavior during real agent logins before changing browser/WSLg helpers.

### Agent configuration cutover

- [x] Create Git-managed configuration roots:
  - [ ] `agents/pi/`
  - [ ] `agents/copilot/`
  - [ ] `agents/claude/` with an initial README/configuration mapping once Claude's current paths are known.
- [x] Move authored Pi settings, keybindings, extensions, skills, prompts, and future package declarations into `agents/pi/`.
- [x] Treat Pi `models-store.json`, `auth.json`, sessions, logs, package caches, and installed package state as local runtime data. A future authored `models.json` is eligible for version control.
- [x] Move Copilot `settings.json`, custom agents, and skills into `agents/copilot/`; do not move `config.json`, auth, session databases/history, logs, caches, or version/app state.
- [ ] Commit authored agent resources; explicitly ignore generated/runtime state.
- [x] Link individual authored paths into each tool's conventional native configuration directory. Do not symlink an entire runtime directory.
- [x] Remove Home Manager ownership of `~/.pi/agent` after link migration succeeds.
- [x] Remove Nix-managed Pi, Copilot CLI, global Node, and the Pi-specific `nixpkgs` master input/overlay only after upstream tools/configuration are proven.

### Fresh-distribution acceptance

- [ ] Create a disposable WSL2 distribution from the newest Ubuntu LTS; systemd is a hard prerequisite. WSLg/browser checks are warnings, not blockers.
- [ ] Start by installing the short APT prerequisite set, authenticate to GitHub interactively with GitHub CLI over HTTPS, and clone dotfiles.
- [ ] Generate a new ed25519 SSH key for that WSL distribution, register its public key with GitHub, then verify SSH Git access. Do not require copied/shared private keys.
- [ ] Run the documented WSL doctor and bootstrap.
- [ ] Verify Home Manager stable configuration, linked Pi/Copilot configuration, and latest-stable Pi/Claude/Copilot installation.
- [ ] Complete agent logins manually and verify normal operation, including Pi extension loading.
- [ ] Verify ordinary interactive `node` and `npm` are absent from `PATH`. Agent-owned private runtimes are acceptable only when they are not exposed as general developer tools.
- [ ] Record and fix any hidden dependency discovered by the clean distribution; do not mutate the existing migration distribution to mask it.

## Phase 2 — project-local SDK overrides

- [ ] Install mise from the flake-pinned Nix/Home Manager environment.
- [ ] Constrain mise to its reviewed/core .NET and Node backends; do not add third-party plugins, automatic project tasks, or remote bootstrap logic.
- [ ] Keep Home Manager's Nix Python environment unchanged. It supports personal scripts/agent use with scientific packages and no portable Python project currently defines a project contract.
- [ ] Keep one Nix-provided current-LTS .NET SDK as the workstation baseline.
- [ ] Use mise only as a project-local .NET/Node override. Ensure mise activation prevents Nix `DOTNET_ROOT` from selecting the baseline host for a project-owned SDK.
- [ ] Trial mise with `~/work/gleipnir` without changing Home Manager's existing mixed .NET setup:
  - [ ] Verify its `global.json` selects/obtains a compatible .NET SDK.
  - [ ] Verify restore, build, and the smallest relevant test.
  - [ ] Establish a tested exact Node version for its frontend.
  - [ ] Add a minimal committed `mise.toml` containing that exact Node version if repository policy permits; do not duplicate `global.json` or add task-runner abstraction.
  - [ ] Verify Node is available only in the project activation context and absent again outside it.
- [ ] After project override validation, reduce Home Manager from its mixed Nix .NET SDK set to exactly one current-LTS baseline SDK. Keep legacy SDKs project-local through mise.
- [ ] Defer Python project tooling until a maintained Python project has a standard manifest/lockfile; do not introduce a synthetic Python migration.

## Operating rules

- Nix/Home Manager owns stable workstation configuration and tools.
- Upstream mechanisms own latest-stable Pi, Claude Code, and Copilot CLI.
- Agent configuration is Git-managed; credentials and runtime state are local.
- Project contracts use ecosystem-native files first (`global.json`, lockfiles); `mise.toml` is only a thin cross-language runtime declaration where it adds value.
- Nix flakes may remain optional Linux conveniences but must not be the only project setup path.
