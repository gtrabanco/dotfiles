#!/usr/bin/env bash

# User plist files
readonly USER_PLIST_PATH="$HOME/Library/Preferences"

domain::exists() {
  ! defaults read "${1:-}" 2>&1 | grep -q 'does not exist'
}

# Needs a receipe for https://github.com/andreyvit/plist-to-json
# npm i -g plist-to-json
domain::xq() {
  local domain
  domain="${1:-}"
  shift

  if which plist-to-json &> /dev/null &&
    [[ -n "$domain" ]] &&
    domain::exists "$domain"; then
    defaults export "$domain" - | xq "${@:-.}"
  fi
}

domain::get_domain_keys() {
  local domain
  domain="${1:-}"
  domain::xq "$domain" -r ".plist.dict.key[]"
}

domain::get_key() {
  local domain key
  domain="${1:-}"
  key="${2:-}"
  [[ -z "$domain" || -z "$key" ]] && return 1

  defaults read "$domain" "$key" 2> /dev/null
}

domain::get_key_type() {
  local domain key
  domain="${1:-}"
  key="${2:-}"
  [[ -z "$domain" || -z "$key" ]] && return 1

  domain::get_type "$(defaults read-type "$domain" "$key" 2> /dev/null)"
}

domain::get_type() {
  local type
  case "${*:-null}" in
    *boolean*) type="boolean" ;;
    *integer*) type="integer" ;;
    *string*) type="string" ;;
    *array*) type="array" ;;
    *float*) type="float" ;;
    *data*) type="data" ;;
    *date*) type="date" ;;
    *dict*) type="dict" ;;
    null) type="null" ;;
    *) type="unknown" ;;
  esac

  echo "$type"
}

domain::get_domain_keys_types() {
  local domain key
  domain="${1:-}"
  [[ -z "$domain" ]] || ! domain::exists "$domain" && return 1

  domain::get_domain_keys "$domain" | while read -r key; do
    echo -n "$key: "
    domain::get_key_type "$domain" "$key"
  done
}
