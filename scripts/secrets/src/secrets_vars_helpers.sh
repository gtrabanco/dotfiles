#!/usr/bin/env bash

. "$DOTFILES_PATH/scripts/secrets/src/install_needed_soft_and_vars.sh"
. "$DOTFILES_PATH/scripts/secrets/src/secrets_helpers.sh"

SECURITY_BIN="$(command -v security || true)"

secrets::var_exists() {
  [[ -z "${1:-}" ]] && return 1

  if platform::is_macos && [[ "${DOTLY_SECRETS_VAR_MACOS_STORE:-filepath}" == "keychain" ]]; then
    security find-generic-password -s "$1" -w &> /dev/null
  else
    secrets::check_exists "vars/$1"
  fi
}

secrets::var() {
  local var_path var_name var_file_path
  var_name="$1"
  shift
  var_path="$(secrets::var_exists "$var_name")"
  var_file_path="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/vars/$var_name"
  value="${*:-}"

  [[ -z "${var_name:-}" ]] && return

  if platform::is_macos && [[ "${DOTLY_SECRETS_VAR_MACOS_STORE:-filepath}" == "keychain" ]]; then
    if [[ -n "$value" ]] && "$SECURITY_BIN" find-generic-password -s "$var_name" -w &> /dev/null; then
      "$SECURITY_BIN" delete-generic-password -a "$USER" -s "$var_name" &> /dev/null
      "$SECURITY_BIN" add-generic-password -a "$USER" -s "$var_name" -w "$value" 2> /dev/null
      touch "$var_file_path"
    elif [[ -n "$value" ]]; then
      "$SECURITY_BIN" add-generic-password -a "$USER" -s "$var_name" -w "$value" 2> /dev/null
      touch "$var_file_path"
    else
      "$SECURITY_BIN" find-generic-password -s "$var_name" -w 2> /dev/null || echo -n ''
    fi
  elif [[ -n "$value" ]]; then
    echo "$value" >| "$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/vars/$var_name"
  elif [[ -n "$var_path" ]]; then
    cat "$var_path"
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
