#!/usr/bin/env bash
# Install, update, and verify the explicitly managed evergreen agent cohort.
# The vendor installers remain the owner of their binaries and private runtimes.
set -u -o pipefail

readonly PI_INSTALLER_URL="https://pi.dev/install.sh"
readonly CLAUDE_INSTALLER_URL="https://claude.ai/install.sh"
readonly COPILOT_INSTALLER_URL="https://gh.io/copilot-install"
readonly USER_BIN="${XDG_BIN_HOME:-$HOME/.local/bin}"
readonly PI_MANAGED_AGENT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pi-managed"

failures=0

usage() {
  cat <<'EOF'
Usage: bootstrap/agents.sh <sync|verify>

sync     Install missing agents and update Pi, Claude Code, and GitHub Copilot
         CLI independently to their current stable releases.
verify   Print installed versions and configuration locations.

Authentication is intentionally not automated.
EOF
}

log() {
  printf '[agents] %s\n' "$*"
}

command_version() {
  local command_name="$1"
  local command_path="$2"
  if [[ ! -x "$command_path" ]]; then
    printf 'not installed'
    return 0
  fi

  "$command_path" --version 2>/dev/null \
    || "$command_path" version 2>/dev/null \
    || printf 'installed (version command unavailable)'
}

run_vendor_installer() {
  local label="$1"
  local url="$2"
  shift 2

  local temp_dir installer checksum status
  temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-${label}.XXXXXX")
  installer="$temp_dir/install.sh"

  log "Downloading ${label} installer from ${url}"
  if ! curl --fail --location --silent --show-error --proto '=https' --tlsv1.2 "$url" --output "$installer"; then
    rm -rf "$temp_dir"
    return 1
  fi
  checksum=$(sha256sum "$installer" | awk '{print $1}')
  log "${label} installer SHA-256: ${checksum}"

  bash "$installer" "$@" || status=$?
  rm -rf "$temp_dir"
  return "${status:-0}"
}

install_pi() {
  # Pi's official installer normally detects apt and may install Node system-wide.
  # Hide apt-cache and all existing Nix tools from this invocation so Pi selects
  # its checksum-verified private Node runtime instead. The managed launcher adds
  # that runtime only for Pi and Pi child processes.
  local shim_dir status
  shim_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-pi-path.XXXXXX")
  printf '#!/bin/sh\nexit 127\n' > "$shim_dir/apt-cache"
  chmod 755 "$shim_dir/apt-cache"

  mkdir -p "$USER_BIN"
  log "Installing Pi with a private Node runtime and managed install root ${PI_MANAGED_AGENT_DIR}"
  PATH="$USER_BIN:$shim_dir:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    PI_CODING_AGENT_DIR="$PI_MANAGED_AGENT_DIR" \
    run_vendor_installer pi "$PI_INSTALLER_URL" || status=$?
  rm -rf "$shim_dir"
  return "${status:-0}"
}

update_pi() {
  if [[ -x "$USER_BIN/pi" ]]; then
    log "Updating Pi through its managed updater"
    "$USER_BIN/pi" update
  else
    install_pi
  fi
}

install_claude() {
  log "Installing Claude Code through Anthropic's checksum-verifying installer"
  run_vendor_installer claude "$CLAUDE_INSTALLER_URL" stable
}

install_copilot() {
  log "Installing GitHub Copilot CLI through GitHub's checksum-verifying installer"
  # The official installer defaults to ~/.local/bin for a non-root user.
  # Do not set PREFIX: it appends /bin to the supplied prefix.
  run_vendor_installer copilot "$COPILOT_INSTALLER_URL"
}

run_tool() {
  local name="$1"
  shift

  log "--- ${name}: starting ---"
  if "$@"; then
    log "--- ${name}: succeeded ---"
  else
    log "--- ${name}: failed ---"
    failures=$((failures + 1))
  fi
}

verify_tool() {
  local name="$1"
  local path="$2"
  printf '%-14s %s\n' "$name" "$(command_version "$name" "$path")"
}

verify() {
  verify_tool "Pi" "$USER_BIN/pi"
  verify_tool "Claude Code" "$USER_BIN/claude"
  verify_tool "Copilot CLI" "$USER_BIN/copilot"
  printf '\n'
  printf 'Pi config:       %s\n' "$HOME/.pi/agent"
  printf 'Copilot config:  %s\n' "$HOME/.copilot"
  printf 'Claude config:   %s\n' "$HOME/.claude"
  printf '\n'
  printf 'Authentication is manual: run Pi /login, claude login, and copilot login as needed.\n'
}

main() {
  # Vendor installers should discover user-local agent binaries without changing
  # shell profiles. This affects only the bootstrap process, not the caller.
  export PATH="$USER_BIN:$PATH"

  if [[ $# -ne 1 ]]; then
    usage >&2
    exit 2
  fi

  case "$1" in
    sync)
      run_tool "Pi" update_pi
      run_tool "Claude Code" install_claude
      run_tool "GitHub Copilot CLI" install_copilot
      verify
      ;;
    verify)
      verify
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac

  if [[ $failures -ne 0 ]]; then
    log "${failures} tool operation(s) failed"
    exit 1
  fi
}

main "$@"
