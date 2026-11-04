#!/usr/bin/env bash
# Own only authored agent configuration. Credentials and runtime state stay local.
set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly PI_SOURCE="$REPO_ROOT/agents/pi"
readonly COPILOT_SOURCE="$REPO_ROOT/agents/copilot"
readonly CLAUDE_SOURCE="$REPO_ROOT/agents/claude"
readonly PI_RUNTIME="$HOME/.pi/agent"
readonly COPILOT_RUNTIME="$HOME/.copilot"
readonly CLAUDE_RUNTIME="$HOME/.claude"
readonly PI_LEGACY_SOURCE="$REPO_ROOT/home-manager/pi-agent"
readonly BACKUP_SUFFIX=".dotfiles-backup.$(date +%Y%m%d-%H%M%S)"

pi_paths=(.gitignore README.md CONTEXT.md settings.json keybindings.json extensions skills prompts notes)
copilot_paths=(settings.json agents skills)
claude_paths=(settings.json commands agents skills)

usage() {
  cat <<'EOF'
Usage: bootstrap/agent-config.sh <status|migrate|link>

status   Show managed-path state without changing files.
migrate  Move existing authored Pi/Copilot configuration into agents/, preserve
         runtime state locally, then create individual symlinks.
link     Create/repair individual links from existing agents/ source directories.

The script never links or moves credentials, sessions, logs, caches, downloaded
packages, databases, or generated model state.
EOF
}

log() {
  printf '[agent-config] %s\n' "$*"
}

same_path() {
  [[ -e "$1" || -L "$1" ]] || return 1
  [[ $(readlink -f "$1") == $(readlink -f "$2") ]]
}

show_path() {
  local label="$1" source="$2" runtime="$3"
  if [[ -L "$runtime" ]] && same_path "$runtime" "$source"; then
    printf 'OK      %-10s %s -> %s\n' "$label" "$runtime" "$source"
  elif [[ -e "$runtime" || -L "$runtime" ]]; then
    printf 'LOCAL   %-10s %s\n' "$label" "$runtime"
  elif [[ -e "$source" || -L "$source" ]]; then
    printf 'MISSING %-10s source exists but runtime path is absent: %s\n' "$label" "$runtime"
  else
    printf 'ABSENT  %-10s %s\n' "$label" "$source"
  fi
}

status() {
  local relative
  printf 'Pi:\n'
  for relative in "${pi_paths[@]}"; do
    show_path "$relative" "$PI_SOURCE/$relative" "$PI_RUNTIME/$relative"
  done

  printf '\nCopilot:\n'
  for relative in "${copilot_paths[@]}"; do
    show_path "$relative" "$COPILOT_SOURCE/$relative" "$COPILOT_RUNTIME/$relative"
  done

  printf '\nClaude:\n'
  for relative in "${claude_paths[@]}"; do
    show_path "$relative" "$CLAUDE_SOURCE/$relative" "$CLAUDE_RUNTIME/$relative"
  done
}

backup_existing() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    local backup="${path}${BACKUP_SUFFIX}"
    log "Backing up existing path $path to $backup"
    mv "$path" "$backup"
  fi
}

link_path() {
  local source="$1" runtime="$2"
  mkdir -p "$(dirname "$runtime")"

  if [[ -L "$runtime" ]] && same_path "$runtime" "$source"; then
    return
  fi
  backup_existing "$runtime"
  ln -s "$source" "$runtime"
  log "Linked $runtime -> $source"
}

link_paths() {
  local source_root="$1" runtime_root="$2"
  shift 2
  local relative
  mkdir -p "$runtime_root"
  for relative in "$@"; do
    if [[ -e "$source_root/$relative" || -L "$source_root/$relative" ]]; then
      link_path "$source_root/$relative" "$runtime_root/$relative"
    fi
  done
}

move_authored_path() {
  local from_root="$1" to_root="$2" relative="$3"
  local from="$from_root/$relative" to="$to_root/$relative"
  [[ -e "$from" || -L "$from" ]] || return 0
  [[ -e "$to" || -L "$to" ]] && return
  mkdir -p "$(dirname "$to")"
  log "Migrating authored configuration $from -> $to"
  mv "$from" "$to"
}

migrate_pi() {
  if [[ -L "$PI_RUNTIME" ]] && same_path "$PI_RUNTIME" "$PI_LEGACY_SOURCE"; then
    log "Converting Home Manager's whole-directory Pi link to individual configuration links"
  elif [[ -L "$PI_RUNTIME" ]]; then
    log "Refusing to migrate Pi: $PI_RUNTIME is an unexpected symlink"
    return 1
  fi

  mkdir -p "$PI_SOURCE"
  local relative
  for relative in "${pi_paths[@]}"; do
    move_authored_path "$PI_LEGACY_SOURCE" "$PI_SOURCE" "$relative"
  done

  if [[ -L "$PI_RUNTIME" ]]; then
    unlink "$PI_RUNTIME"
  fi
  mkdir -p "$PI_RUNTIME"

  # Anything still in the former whole-directory source is explicitly runtime
  # state (auth, sessions, generated model data, installed package state, etc.).
  if [[ -d "$PI_LEGACY_SOURCE" ]]; then
    find "$PI_LEGACY_SOURCE" -mindepth 1 -maxdepth 1 -exec mv -t "$PI_RUNTIME" -- {} +
  fi

  link_paths "$PI_SOURCE" "$PI_RUNTIME" "${pi_paths[@]}"
}

migrate_copilot() {
  mkdir -p "$COPILOT_SOURCE" "$COPILOT_RUNTIME"
  local relative
  for relative in "${copilot_paths[@]}"; do
    move_authored_path "$COPILOT_RUNTIME" "$COPILOT_SOURCE" "$relative"
  done
  link_paths "$COPILOT_SOURCE" "$COPILOT_RUNTIME" "${copilot_paths[@]}"
}

migrate_claude() {
  mkdir -p "$CLAUDE_SOURCE" "$CLAUDE_RUNTIME"
  local relative
  for relative in "${claude_paths[@]}"; do
    move_authored_path "$CLAUDE_RUNTIME" "$CLAUDE_SOURCE" "$relative"
  done
  link_paths "$CLAUDE_SOURCE" "$CLAUDE_RUNTIME" "${claude_paths[@]}"
}

link() {
  if [[ -L "$PI_RUNTIME" ]]; then
    log "Refusing to link Pi paths while $PI_RUNTIME is a whole-directory symlink; run migrate first"
    return 1
  fi
  link_paths "$PI_SOURCE" "$PI_RUNTIME" "${pi_paths[@]}"
  link_paths "$COPILOT_SOURCE" "$COPILOT_RUNTIME" "${copilot_paths[@]}"
  link_paths "$CLAUDE_SOURCE" "$CLAUDE_RUNTIME" "${claude_paths[@]}"
}

main() {
  if [[ $# -ne 1 ]]; then
    usage >&2
    exit 2
  fi

  case "$1" in
    status) status ;;
    migrate)
      migrate_pi
      migrate_copilot
      migrate_claude
      status
      ;;
    link) link; status ;;
    *) usage >&2; exit 2 ;;
  esac
}

main "$@"
