#!/usr/bin/env bash
# Fast, non-mutating smoke checks for dotfiles bootstrap helpers.
set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

scripts=(
  bootstrap/agents.sh
  bootstrap/agent-config.sh
  bootstrap/wsl-doctor.sh
  bootstrap/wsl.sh
  bootstrap/bin/xdg-open
)

for script in "${scripts[@]}"; do
  bash -n "$REPO_ROOT/$script"
done

if rg -n 'trap .*[R]ETURN' "$REPO_ROOT/bootstrap"; then
  printf 'RETURN traps are forbidden in bootstrap helpers because they outlive function-local cleanup variables.\n' >&2
  exit 1
fi

"$REPO_ROOT/bootstrap/agent-config.sh" status
"$REPO_ROOT/bootstrap/agents.sh" verify

printf '\nBootstrap smoke checks passed.\n'
