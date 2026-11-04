# pi-agent

This directory is symlinked to `~/.pi/agent` by Home Manager via an out-of-store symlink.

Tracked here:
- `keybindings.json`
- `settings.json`

Ignored/generated here:
- `auth.json`
- `sessions/`
- package install state (`git/`, `npm/`)

After changing files, run `/reload` in pi.
After changing Home Manager wiring, run `home-manager switch --flake .#nonni`.
