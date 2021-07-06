#!/usr/bin/env bash

set -euo pipefail

if platform::is_macos && ! "${SLOTH_PATH:-$DOTLY_PATH}/bin/dot" package check gpg-suite &> /dev/null; then
  script::depends_on gpg-suite-no-mail
else
  script::depends_on gpg
fi

if platform::command_exists gpg2; then
  GPG_BIN="$(which gpg2)"
elif platform::command_exists gpg; then
  GPG_BIN="$(which gpg)"
else
  output::error "GPG was not found"
  exit 4
fi

sec::menu() {
  local PS3
  [[ $# -lt 1 ]] && return

  PS3="Choose an option: "
  select opt in "$@"; do
    echo "$opt"
    return
  done
}

sec::generate_key() {
  local GPG_VERSION
  GPG_VERSION="$("$GPG_BIN" --version | head -n1 | awk '{print $3}')"

  case "$(platform::semver_compare "$GPG_VERSION" 2.1.17)" in
    -1)
      # Lower than 2.1.17
      "$GPG_BIN" --default-new-key-algo rsa4096 --gen-key
      ;;
    *)
      "$GPG_BIN" --full-generate-key
      ;;
  esac
}

sec::has_keys() {
  [[ -n "$("$GPG_BIN" --list-secret-keys --keyid-format LONG)" ]]
}

sec::get_keys() {
  "$GPG_BIN" --list-secret-keys --keyid-format LONG | grep "sec" | tr '/' ' ' | sort --reverse | awk '{print $3}'
}