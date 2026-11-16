#!/usr/bin/env bash
# Read-only registration checks; install.sh owns registration writes.
check_registration() {
  local repo_dir="$1" file="$2" escaped
  [[ -r "$file" ]] || return 1
  escaped="${repo_dir//\\/\\\\}"
  escaped="${escaped//\"/\\\"}"
  escaped="${escaped//\$/\\\$}"
  escaped="${escaped//\`/\\\`}"
  [[ "$(awk '/^[[:space:]]*export[[:space:]]+OMARCHY_THEME_VAULT_DIR=/ {n++} END {print n+0}' "$file")" == 1 ]] || return 1
  [[ "$(awk '/^[[:space:]]*alias[[:space:]]+omarchy-theme-vault=/ {n++} END {print n+0}' "$file")" == 1 ]] || return 1
  grep -Fxq "export OMARCHY_THEME_VAULT_DIR=\"$escaped\"" "$file" || return 1
  grep -Fxq 'alias omarchy-theme-vault="cd \$OMARCHY_THEME_VAULT_DIR"' "$file" || return 1
  return 0
}
