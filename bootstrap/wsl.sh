#!/usr/bin/env bash
# Provision a supported WSL Ubuntu distribution from a checked-out dotfiles repo.
set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly NIX_INSTALLER_URL="https://nixos.org/nix/install"
readonly HOME_MANAGER_REF="github:nix-community/home-manager"
readonly HOME_MANAGER_FLAKE="$REPO_ROOT/home-manager#nonni"

log() {
  printf '[wsl-bootstrap] %s\n' "$*"
}

require_sudo() {
  if ! sudo -v; then
    printf 'sudo is required to install Ubuntu bootstrap prerequisites and Nix.\n' >&2
    exit 1
  fi
}

ensure_systemd() {
  if [[ $(ps -p 1 -o comm= 2>/dev/null | tr -d '[:space:]') == systemd ]]; then
    return
  fi

  if [[ -e /etc/wsl.conf ]]; then
    cat >&2 <<'EOF'
Systemd is not PID 1 and /etc/wsl.conf already exists.

Review that file and enable:
  [boot]
  systemd=true

Then run `wsl --terminate <this-distro>` from Windows, reopen this distro, and rerun bootstrap/wsl.sh.
EOF
    return 75
  fi

  require_sudo
  log 'Enabling systemd for this fresh WSL distribution'
  sudo tee /etc/wsl.conf >/dev/null <<'EOF'
[boot]
systemd=true
EOF
  cat >&2 <<'EOF'
Systemd has been configured, but WSL must restart before it takes effect.

From PowerShell or Windows Terminal, terminate only this distribution:
  wsl --terminate <distro-name>

Reopen this Ubuntu distribution, then rerun:
  ~/dotfiles/bootstrap/wsl.sh
EOF
  return 75
}

install_apt_prerequisites() {
  log 'Installing Ubuntu bootstrap prerequisites'
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl git openssh-client

  # wslu provides wslview on Ubuntu releases that package it. Ubuntu 26 can use
  # explorer.exe directly, so do not make browser bridging depend on wslu.
  if ! command -v wslview >/dev/null 2>&1 && apt-cache show wslu >/dev/null 2>&1; then
    sudo apt-get install -y wslu
  fi

  # GitHub CLI should normally be available from current Ubuntu LTS. Do not add
  # a third-party APT source if it is absent: GitHub authentication can be
  # completed manually before rerunning this script.
  if ! command -v gh >/dev/null 2>&1; then
    if apt-cache show gh >/dev/null 2>&1; then
      sudo apt-get install -y gh
    else
      log 'GitHub CLI is not available from configured Ubuntu APT sources; install it manually, authenticate, and rerun if needed.'
    fi
  fi
}

load_existing_nix_profile() {
  if ! command -v nix >/dev/null 2>&1 && [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # Make a prior interrupted Nix installation visible before deciding whether
    # Nix is absent. This is safe to source repeatedly.
    # shellcheck disable=SC1091
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}

install_nix_if_absent() {
  load_existing_nix_profile
  if command -v nix >/dev/null 2>&1; then
    log "Nix already installed: $(nix --version)"
    return
  fi

  local temp_dir installer checksum status
  temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-nix.XXXXXX")
  installer="$temp_dir/install"

  log "Downloading official Nix installer from $NIX_INSTALLER_URL"
  if ! curl --fail --location --silent --show-error --proto '=https' --tlsv1.2 "$NIX_INSTALLER_URL" --output "$installer"; then
    rm -rf "$temp_dir"
    return 1
  fi
  checksum=$(sha256sum "$installer" | awk '{print $1}')
  log "Nix installer SHA-256: $checksum"
  log 'Running Nix multi-user installer; follow any installer prompts.'
  sh "$installer" --daemon || status=$?
  rm -rf "$temp_dir"
  if [[ ${status:-0} -ne 0 ]]; then
    return "$status"
  fi

  # Make Nix available to this bootstrap process without requiring a new shell.
  # shellcheck disable=SC1091
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}

enable_nix_flakes() {
  local config=/etc/nix/nix.conf
  if sudo test -f "$config" && sudo grep -Eq '^extra-experimental-features[[:space:]]*=.*\bflakes\b' "$config"; then
    return
  fi

  log 'Enabling nix-command and flakes in /etc/nix/nix.conf'
  printf '\n# Managed by dotfiles bootstrap\nextra-experimental-features = nix-command flakes\n' \
    | sudo tee -a "$config" >/dev/null
}

activate_home_manager() {
  log "Activating Home Manager configuration $HOME_MANAGER_FLAKE"
  nix run "$HOME_MANAGER_REF" -- switch --flake "$HOME_MANAGER_FLAKE"
}

configure_distro_ssh_identity() {
  if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
    log 'GitHub CLI is not authenticated; run gh auth login --web --git-protocol https, then register an SSH key with gh ssh-key add.'
    return
  fi

  local key_path="$HOME/.ssh/id_ed25519"
  if [[ ! -e "$key_path" && ! -L "$key_path" ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    log "Generating a new distro SSH identity at $key_path"
    ssh-keygen -q -t ed25519 -N '' -f "$key_path"
  fi

  if ! gh ssh-key list >/dev/null 2>&1; then
    cat >&2 <<'EOF'
GitHub authentication does not have permission to manage SSH public keys.

Run:
  gh auth refresh -h github.com -s admin:public_key

Then rerun bootstrap/wsl.sh. The generated private key remains local.
EOF
    return 1
  fi

  local public_key
  public_key=$(<"$key_path.pub")
  if gh ssh-key list | grep -Fq "$public_key"; then
    log "Existing distro SSH identity is already registered: $key_path"
    return
  fi

  local distro_name="${WSL_DISTRO_NAME:-wsl}"
  gh ssh-key add "$key_path.pub" --title "${HOSTNAME}-${distro_name}"
  log 'Registered the new distro SSH public key with GitHub'
}

configure_agents() {
  log 'Linking Git-managed agent configuration'
  "$REPO_ROOT/bootstrap/agent-config.sh" link
  log 'Installing/updating evergreen agent cohort'
  "$REPO_ROOT/bootstrap/agents.sh" sync
}

main() {
  ensure_systemd
  "$REPO_ROOT/bootstrap/wsl-doctor.sh"
  require_sudo
  install_apt_prerequisites
  install_nix_if_absent
  enable_nix_flakes
  activate_home_manager
  configure_distro_ssh_identity
  configure_agents

  cat <<'EOF'

Bootstrap completed. Open a new Windows Terminal tab before validating normal shell behavior.

Use a profile command line shaped like:
  wsl.exe -d <distro-name> --cd ~ -- /home/<linux-user>/.nix-profile/bin/fish -l

Then validate:
  command -v pi claude copilot
  command -v node npm  # both should be absent
  ~/dotfiles/bootstrap/agents.sh verify

Agent authentication remains interactive: start pi, claude, and copilot, then complete each normal login flow.
EOF
}

main "$@"
