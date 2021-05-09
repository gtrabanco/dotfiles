#!/usr/bin/env bash

source "$DOTFILES_PATH/scripts/secrets/lib/install_needed_soft_and_vars.sh"

secrets::remove_file() {
  local start_dir
  start_dir="$(pwd)"
  cd "$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH" || return 1
  
  # If you have not commited your secrets then rm is mandatory :(
  rm -rf "$(realpath --relative-to="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH" "${1/$DOTLY_SECRETS_MODULE_PATH\//}")"

  git add .
  git stash >/dev/null 2>&1
  git filter-branch --index-filter "git rm -f --ignore-unmatch $(realpath --relative-to="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH" "${1/$DOTLY_SECRETS_MODULE_PATH\//}")" HEAD >/dev/null 2>&1
  git stash pop >/dev/null 2>&1
  cd "$start_dir" || return
}

secrets::check_exists() {
  [[ -e "$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/$1" ]] && echo "$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/$1"
}