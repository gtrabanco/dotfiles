#!/usr/bin/env bash

if ! command -v "output::list" &> /dev/null; then
  output::list() {
    local item i
    i=1
    for item in "$@"; do
      output::write "    $i) $item"
      i=$((i + 1))
    done
  }
fi

sec::gpg() {
  if [[ -n "${GPG_BIN:-}" && -x "$GPG_BIN" ]]; then
    "$GPG_BIN" "$@"
  elif platform::command_exists gpg2; then
    GPG_BIN="$(which gpg2)"
    "$GPG_BIN" "$@"
  elif platform::command_exists gpg; then
    GPG_BIN="$(which gpg)"
    "$GPG_BIN" "$@"
  else
    output::error "GPG was not found"
    exit 4
  fi
}

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
  GPG_VERSION="$(sec::gpg --version | head -n1 | awk '{print $3}')"

  case "$(platform::semver_compare "$GPG_VERSION" 2.1.17)" in
    -1)
      # Lower than 2.1.17
      sec::gpg --default-new-key-algo rsa4096 --gen-key
      ;;
    *)
      sec::gpg --full-generate-key
      ;;
  esac
}

sec::has_keybase_pkeys() {
  platform::command_exists keybase && [[ -n "$(keybase pgp list)" ]]
}

sec::has_pkeys() {
  [[ -n "$(sec::gpg --list-secret-keys --keyid-format LONG)" ]]
}

sec::get_pkeys() {
  sec::gpg --list-secret-keys --keyid-format LONG | grep "sec" | tr '/' ' ' | sort --reverse | awk '{print $3}'
}

sec::parse_emails() {
  if [ -t 0 ]; then
    printf "%s\n" "${@:-}" | grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}'
  else
    grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' < /dev/stdin
  fi
}

sec::sed() {
  if command -v gsed &> /dev/null; then
    "$(which gsed)" "$@"
  elif [[ -f "/usr/local/opt/gnu-sed/libexec/gnubin/sed" ]]; then
    /usr/local/opt/gnu-sed/libexec/gnubin/sed "$@"
  elif platform::is_macos; then
    # Any other BSD should be added to this check
    "$(which sed)" '' "$@"
  elif command -v sed &> /dev/null; then
    "$(which sed)" "$@"
  else
    return 1
  fi
}

sec::list_private_keys() {
  sec::gpg --list-secret-keys --keyid-format LONG | grep "^pub" | tr "/" " " | awk '{print $3}'
}

sec::list_public_keys() {
  sec::gpg --list-keys --keyid-format LONG | grep "^pub" | tr "/" " " | awk '{print $3}'
}

sec::check_private_key_exists() {
  [[ -n "${1:-}" ]] && sec::gpg --list-secret-keys --keyid-format LONG "$1" &> /dev/null
}

sec::check_public_key_exists() {
  [[ -n "${1:-}" ]] && sec::gpg --list-keys --keyid-format LONG "$1" &> /dev/null
}

sec::trust_key() {
  [[ -n "${1:-}" ]] && sec::check_private_key_exists "$1" && expect -c "spawn gpg --edit-key ${1} trust quit; send \"5\ry\r\"; expect eof"
}

sec::trust_key_wizard() {
  output::write "䷐ You must type:"
  output::list '`trust`' '`5`' '`y`' '`quit`'
  output::empty_line
  [[ -n "${1:-}" ]] && gpg --edit-key "$1"
}

sec::verify_trust_ultimate() {
  [[ -n "${1:-}" ]] && gpg --list-keys --list-options show-uid-validity "$1" | grep '^uid' | awk '{print $2}' | head -n1 | grep -q '^\[ultimate\]$'
}

sec::fzf_keys() {
  local keys
  if [[ -t 0 ]]; then
    keys=("$@")
  else
    mapfile -t keys < <(echo "$(< /dev/stdin)")
  fi

  #shellcheck disable=SC2016
  printf "%s\n" "${keys[@]}" | fzf --header "Choose a key" --preview '. "${SLOTH_PATH:-$DOTLY_PATH}/scripts/core/src/_main.sh"; dot::load_library "sec.sh" "gpg"; sec::gpg  --list-secret-keys --keyid-format LONG {} | sec::parse_emails'
}
