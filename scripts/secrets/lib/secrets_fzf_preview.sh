#!/usr/bin/env bash

source "$DOTFILES_PATH/scripts/core/_main.sh"
source "$DOTFILES_PATH/scripts/secrets/lib/secrets_helpers.sh"
source "$DOTFILES_PATH/scripts/secrets/lib/secrets_json.sh"

secrets::preview() {
  local file file_alias
  file="$1"
  output::write "Press Tab+Shift to select multiple options."
  output::write "Press Ctrl+C to exit with no selection."
  output::empty_line

  if secrets::check_exists "files/$file" > /dev/null; then
    file_alias="$(secrets::get_alias_by_stored_file "$DOTLY_SECRETS_MODULE_PATH/files/$file")"
    output::write "Alias for this file is:"
    [[ -n "$file_alias" ]] && output::write "\t$file_alias" || output::error "This file has no alias"
    output::empty_line
    output::empty_line
  elif secrets::get_stored_file_by_alias "$file" > /dev/null; then
    output::write "This alias point to:"
    output::empty_line
    echo -n "\t"
    secrets::get_stored_file_by_alias "$file"
    output::empty_line
    output::empty_line
  fi

  output::write "⚠️⚠️ CONTENT IS NOT SHOW DUE TO SECURITY REASONS ⚠️⚠️"
}