#!/usr/bin/env bash

. "$DOTFILES_PATH/scripts/secrets/src/install_needed_soft_and_vars.sh"
. "$DOTFILES_PATH/scripts/secrets/src/secrets_helpers.sh"
. "$DOTFILES_PATH/scripts/secrets/src/secrets_json.sh"

secrets::find () {
  local find_relative_path exclude_itself arguments

  case "$1" in
    --exclude)
      exclude_itself=true; shift
    ;;
    *)
      exclude_itself=false
    ;;
  esac

  find_relative_path="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/"
  arguments=()

  if [ -e "$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/${1:-}" ]; then
    find_relative_path="$find_relative_path${1:-}"; shift
  fi

  if $exclude_itself; then
    arguments+=(-not -path "$find_relative_path")
  fi

  arguments+=("$@")

  find "$find_relative_path" -not -iname ".*" "${arguments[@]}" -print | while read -r item; do
    printf "%s\n" "${item/$find_relative_path\//}"
  done
}

secrets::fzf() {
  local piped_values
  piped_values="$(</dev/stdin)"

  printf "%s\n" ${piped_values[@]} | fzf -m --extended \
    --header "$1"\
    --preview "source \"$DOTFILES_PATH/scripts/secrets/lib/secrets_fzf_preview.sh\";secrets::preview {}" # CHANGE FOR DOTLY_PATH
}

secrets::apply() {
  local file_path
  file_path="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/symlinks/secrets.json"
  if [[ -f "$file_path" ]]; then
    echo
    "$DOTLY_PATH/modules/dotbot/bin/dotbot" -d "$DOTFILES_PATH" -c "$file_path" "$@"
    echo
  fi
}

secrets::relative_path() {
  local item
  item="$(realpath -q --logical --no-symlinks -m "$1")"
  item="${item//$DOTFILES_PATH\//}"
  echo "${item//$HOME/\~}"
}

secrets::purge_secrets_json() {
  local item
  jq -r\
    '.[] | select( .link != null) | .link | map_values(.) | keys[1:] | .[]'\
    "$SECRETS_JSON" |\
    while read -r item; do
      secrets::remove_secrets_json_link_by_symlink "$item"
  done
}

secrets::revert() {
  local start_dir item
  
  start_dir="$(pwd)"
  cd "$DOTFILES_PATH" || return 1

  if [[ -f "$SECRETS_JSON" ]]; then
    jq -r '.[] | select( .link != null) | .link | keys[1:] | .[]' "$SECRETS_JSON" |\
      while read -r item; do
        output::answer "Remove symlink: $item"
        # We use eval to resolve kind of links like ~/my_symlink
        eval rm -f "$item" 
      done
  fi

  cd "$start_dir" || return
}

secrets::remove_symlink_by_stored_file() {
  local item start_dir relative_path_to_remove file_path file_alias
  relative_path_to_remove="$DOTLY_SECRETS_MODULE_PATH/files/$1"
  file_alias="$(secrets::get_alias_by_stored_file "$relative_path_to_remove")"
  start_dir="$(pwd)"
  cd "$DOTFILES_PATH" || return 1

  output::empty_line
  output::answer "Removing file 'files/$1' from storage"
  secrets::remove_file "files/$1"

  output::empty_line
  output::answer "Removing alias '$file_alias'"
  eval rm -f "$file_alias"

  output::empty_line
  secrets::remove_secrets_json_link_by_stored_file "$relative_path_to_remove"

  output::empty_line
  output::solution "File '$1' was completely removed"

  cd "$start_dir" || return
}

secrets::store_file() {
  local secret_files_path item_symlink_path secret_link
  item_symlink_path="$(secrets::relative_path "$1")"
  
  if [[ -n "$2" ]]; then
    secret_files_path="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/files/$2"
    secret_link="$DOTLY_SECRETS_MODULE_PATH/files/$2/$(basename "$1")"
  else
    secret_files_path="$DOTFILES_PATH/$DOTLY_SECRETS_MODULE_PATH/files"
    secret_link="$DOTLY_SECRETS_MODULE_PATH/files/$(basename "$1")"
  fi

  if [[ -e "$secret_files_path/$(basename "$1")" ]]; then
    output::error "Already exists a file with this name, try adding a different secrets relative path"
    return 1
  fi

  output::answer "Moving the file to your secrets path"
  mkdir -p "$secret_files_path/"
  mv -n "$1" "$secret_files_path/"

  output::answer "Linking your file '$item_symlink_path'"
  eval ln -s "$secret_files_path/$(basename "$item_symlink_path")" "$item_symlink_path"

  # Add to json secrets file
  output::answer "Adding the link to your secrets file"
  secrets::append_or_update_value_of_link "$item_symlink_path" "$secret_link"

  output::solution "Stored '$item_symlink_path' in secrets."
}

secrets::restore_by_alias() {
  local file_alias stored_file start_dir
  file_alias="$1"

  [[ -z "$file_alias" ]] && return 1

  stored_file="$(secrets::get_stored_file_by_alias "$file_alias")"

  [[ -z "$stored_file" ]] && return 1

  start_dir="$(pwd)"
  cd "$DOTFILES_PATH" || exit 1

  output::answer "Removing '$file_alias' aliases"
  eval rm -f "$DOTFILES_PATH/$file_alias"

  output::answer "Copying the file to '$file_alias'"
  [[ -e "$DOTFILES_PATH/$stored_file" ]] && eval cp -i -R "$DOTFILES_PATH/$stored_file" "$file_alias"
  
  output::answer "Removing the file from secret storage across commits... This could take some time."
  [[ -e "$DOTFILES_PATH/$stored_file" ]] && secrets::remove_file "$stored_file"

  output::answer "Removing from json file"
  secrets::remove_secrets_json_link_by_symlink "$file_alias"

  cd "$start_dir"
}