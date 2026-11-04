# WSL bootstrap

This directory provisions a supported WSL Ubuntu developer environment. It targets the newest Ubuntu LTS on WSL2 with systemd enabled. The existing Ubuntu 24.04 distribution is a supported migration environment, not the fresh-provisioning target.

## Fresh distribution

Before cloning this private repository, install the minimum Ubuntu tools and authenticate to GitHub interactively:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl git gh

gh auth login --web --git-protocol https --scopes admin:public_key
gh repo clone l1n3n01z/dotfiles ~/dotfiles -- --branch main
```

The GitHub CLI browser flow may print a URL/code when WSL cannot open the Windows browser. Complete it manually. The `admin:public_key` scope lets bootstrap register a newly generated per-distro SSH public key; no token or SSH private key belongs in this repository.

Then run:

```bash
cd ~/dotfiles
./bootstrap/wsl.sh
```

On its first run in a fresh distribution, `wsl.sh` configures `/etc/wsl.conf` for systemd and stops. Run `wsl --terminate <distro-name>` from PowerShell or Windows Terminal, reopen that distribution, then rerun `./bootstrap/wsl.sh`. The script runs the doctor after systemd is active.

`wsl.sh` installs only bootstrap APT prerequisites, installs Nix in daemon mode if absent, enables flakes, activates Home Manager, creates a per-distro SSH key when GitHub CLI is authenticated, links managed agent configuration, and synchronizes Pi, Claude Code, and Copilot CLI.

It never runs `apt upgrade`, `full-upgrade`, or an Ubuntu release upgrade.

## Routine commands

```bash
./bootstrap/check.sh          # non-mutating smoke checks
./bootstrap/agents.sh sync    # current stable Pi, Claude Code, Copilot CLI
./bootstrap/agents.sh verify  # versions and configuration locations
./bootstrap/agent-config.sh status
```

Agent authentication remains interactive. Agent configuration is linked from `agents/`; credentials, sessions, caches, downloaded packages, and logs remain local in the vendor-native directories.
