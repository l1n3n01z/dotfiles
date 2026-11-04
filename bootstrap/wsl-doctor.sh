#!/usr/bin/env bash
# Read-only readiness checks for the supported WSL provisioning path.
set -u -o pipefail

failures=0
warnings=0

pass() { printf 'PASS  %s\n' "$*"; }
warn() { printf 'WARN  %s\n' "$*"; warnings=$((warnings + 1)); }
fail() { printf 'FAIL  %s\n' "$*"; failures=$((failures + 1)); }

if grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
  pass "running under WSL"
else
  fail "not running under WSL"
fi

if [[ $(ps -p 1 -o comm= 2>/dev/null | tr -d '[:space:]') == systemd ]]; then
  pass "systemd is PID 1"
else
  fail "systemd is not PID 1; enable systemd in /etc/wsl.conf and restart WSL"
fi

if getent ahosts github.com >/dev/null 2>&1; then
  pass "DNS resolves github.com"
else
  fail "DNS cannot resolve github.com"
fi

if curl --fail --head --silent --show-error --max-time 10 https://github.com >/dev/null 2>&1; then
  pass "HTTPS reaches github.com"
else
  fail "HTTPS cannot reach github.com"
fi

if command -v git >/dev/null 2>&1; then
  pass "git is available"
else
  warn "git is absent; bootstrap will install it from Ubuntu APT"
fi

if command -v gh >/dev/null 2>&1; then
  pass "GitHub CLI is available"
else
  warn "GitHub CLI is absent; bootstrap will install it from Ubuntu APT when available"
fi

if [[ -S /mnt/wslg/runtime-dir/wayland-0 ]]; then
  pass "WSLg Wayland socket is available"
else
  warn "WSLg is unavailable; terminal workflows work, but Linux GUI browser fallback may not"
fi

if command -v wslview >/dev/null 2>&1; then
  pass "wslview is available for Windows-browser bridging"
elif [[ -x /mnt/c/Windows/explorer.exe ]]; then
  pass "Windows explorer.exe is available for browser bridging"
else
  warn "no Windows-browser bridge found; use printed URLs or device-code login if automatic browser opening fails"
fi

printf '\nResult: %d failure(s), %d warning(s).\n' "$failures" "$warnings"
exit "$failures"
