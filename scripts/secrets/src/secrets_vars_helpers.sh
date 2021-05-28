#!/usr/bin/env bash

. "$DOTFILES_PATH/scripts/secrets/src/install_needed_soft_and_vars.sh"
. "$DOTFILES_PATH/scripts/secrets/src/secrets_helpers.sh"

secrets::var_exists() {
  secrets::check_exists "vars/$1"
}

secrets::var() {
  local var_path var_name
  var_name="$1"; shift
  var_path="$(secrets::var_exists "$var_name")"
  value="${*:-}"

  if [[ -n "$value" ]]; then
    echo "$value" >| "$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/vars/$var_name"
  elif [[ -n "$var_path" ]]; then
    cat "$var_path"
  fi
}

secrets::var_delete() {
  local var_path
  var_path="$(secrets::var_exists "$1")"; shift
  [[ -n "$var_path" ]] && secrets::remove_file "$var_path"
}
