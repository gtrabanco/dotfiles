#!/usr/bin/env bash

. "$DOTFILES_PATH/scripts/secrets/src/install_needed_soft_and_vars.sh"
. "$DOTFILES_PATH/scripts/secrets/src/secrets_helpers.sh"

SECURITY_BIN="$(command -v security || true)"


secrets::store_var() {
  local -r var_name="${1:-}"
  local -r value="${2:-}"
  local -r var_file_path="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/vars/$var_name"

  if platfor::is_macos && [[ "${DOTLY_SECRETS_VAR_MACOS_STORE:-filepath}" == "keychain" ]]; then
    if "$SECURITY_BIN" find-generic-password -s "$var_name" -w &> /dev/null; then
      "$SECURITY_BIN" delete-generic-password -a "$USER" -s "$var_name" &> /dev/null
    fi
    
    "$SECURITY_BIN" add-generic-password -a "$USER" -s "$var_name" -w "$value" 2> /dev/null
    touch "$var_file_path"
  else
    echo "$value" | tee "$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/vars/$var_name"
  fi
}

secrets::var() {
  local var_path var_name
  var_name="$1"
  shift
  value="${*:-}"
  [[ -z "${var_name:-}" ]] && return

  local -r var_file_path="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/vars/$var_name"

  if [[ -z "$value" ]]; then
    if platform::is_macos && [[ "${DOTLY_SECRETS_VAR_MACOS_STORE:-filepath}" == "keychain" ]]; then
      "$SECURITY_BIN" find-generic-password -s "$var_name" -w 2> /dev/null || echo -n ''
    else
      if [[ -n "$var_file_path" ]]; then
        cat "$var_file_path"
      fi
    fi
  else
    secrets::store_var "$var_name" "$value"
  fi
}

secrets::var_delete() {
  local var_name var_path
  var_name="${1:-}"

  [[ -z "$var_name" ]] && return 1

  if platform::is_macos && [[ "${DOTLY_SECRETS_VAR_MACOS_STORE:-filepath}" == "keychain" ]]; then
    "$SECURITY_BIN" delete-generic-password -a "$USER" -s "$var_name" &> /dev/null
  else
    var_path="$(secrets::var_exists "$var_name")"
    [[ -f "$var_path" ]] && secrets::remove_file "$var_path"
  fi
}
