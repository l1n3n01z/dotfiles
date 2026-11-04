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

install_apt_prerequisites() {
  log 'Installing Ubuntu bootstrap prerequisites'
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl git wslu

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

install_nix_if_absent() {
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

configure_agents() {
  log 'Linking Git-managed agent configuration'
  "$REPO_ROOT/bootstrap/agent-config.sh" link
  log 'Installing/updating evergreen agent cohort'
  "$REPO_ROOT/bootstrap/agents.sh" sync
}

main() {
  "$REPO_ROOT/bootstrap/wsl-doctor.sh"
  require_sudo
  install_apt_prerequisites
  install_nix_if_absent
  enable_nix_flakes
  activate_home_manager
  configure_agents

  cat <<'EOF'

Bootstrap completed. Complete these interactive steps:
  1. gh auth login --web --git-protocol https   # if GitHub CLI is not already authenticated
  2. Generate/register this distro's SSH key before SSH Git use.
  3. Start pi, claude, and copilot; complete each tool's normal login flow.
  4. Run bootstrap/agents.sh verify.
EOF
}

main "$@"
