#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ensure_theme_vault_env() {
  local repo_dir="$1"
  # An explicit registry path lets fixtures avoid the real home directory.
  local env_file="${2:-$HOME/.dotfiles-env.sh}"
  local escaped_repo_dir temporary
  escaped_repo_dir="${repo_dir//\\/\\\\}"
  escaped_repo_dir="${escaped_repo_dir//\"/\\\"}"
  escaped_repo_dir="${escaped_repo_dir//\$/\\\$}"
  escaped_repo_dir="${escaped_repo_dir//\`/\\\`}"
  local expected_export="export OMARCHY_THEME_VAULT_DIR=\"$escaped_repo_dir\""
  local expected_alias='alias omarchy-theme-vault="cd \$OMARCHY_THEME_VAULT_DIR"'

  mkdir -p -- "$(dirname -- "$env_file")/Projects/home" || return 1
  [[ -e "$env_file" ]] || touch -- "$env_file" || return 1
  temporary="$(mktemp "${env_file}.XXXXXX")" || return 1
  # ENVIRON preserves literal backslashes; awk -v would interpret them.
  if ! DOTFILES_REGISTER_EXPORT="$expected_export" \
       DOTFILES_REGISTER_ALIAS="$expected_alias" awk '
    BEGIN {
      desired_export = ENVIRON["DOTFILES_REGISTER_EXPORT"]
      desired_alias = ENVIRON["DOTFILES_REGISTER_ALIAS"]
    }
    $0 ~ /^[[:space:]]*export[[:space:]]+OMARCHY_THEME_VAULT_DIR=/ {
      if (!seen_export++) print desired_export
      next
    }
    $0 ~ /^[[:space:]]*alias[[:space:]]+omarchy-theme-vault=/ {
      if (!seen_alias++) print desired_alias
      next
    }
    { print }
    END {
      if (!seen_export) print desired_export
      if (!seen_alias) print desired_alias
    }
  ' "$env_file" > "$temporary"; then
    rm -f -- "$temporary"
    return 1
  fi
  if ! mv -- "$temporary" "$env_file"; then
    rm -f -- "$temporary"
    return 1
  fi
  export OMARCHY_THEME_VAULT_DIR="$repo_dir"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  ensure_theme_vault_env "$SCRIPT_DIR"
  printf '%s\n' "✅ OMARCHY_THEME_VAULT_DIR: $OMARCHY_THEME_VAULT_DIR"
  printf '%s\n' "✅ Alias 'omarchy-theme-vault' persisted in $HOME/.dotfiles-env.sh"
  printf '%s\n' 'Open a new shell or source ~/.dotfiles-env.sh.'
fi
