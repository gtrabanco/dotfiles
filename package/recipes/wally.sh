#!/usr/bin/env bash
#? Author:
#?   Gabriel Trabanco Llano <gtrabanco@users.noreply.github.com>
#? This file contains instrucctions to install the package wally-cli
#? v1.0.0

# TODO
# - For Linux the installation is incompleted, see: https://github.com/zsa/wally/wiki/Linux-install
# - Symlink libusb library for macOS ln -s $(brew --prefix libusb)/lib/libusb-1.0.0.dylib /usr/local/opt/libusb/lib/libusb-1.0.0.dylib

WALLY_GITHUB_REPOSITORY="${WALLY_GITHUB_REPOSITORY:-zsa/wally-cli}"
WALLY_INSTALL_DIR="${WALLY_INSTALL_DIR:-${BIN_DIR:-$HOME/bin}}"
WALLY_BIN_NAME="${WALLY_BIN_NAME:-wally-cli}"
WALLY_INSTALL_PATH="${WALLY_INSTALL_PATH:-${WALLY_INSTALL_DIR}/${WALLY_BIN_NAME}}"

wally::_get_os() {
  case "$(platform::get_os)" in
  linux | wsl)
    printf "linux"
    ;;
  darwin | macos)
    printf "osx"
    ;;
  *)
    if platform::is_windows; then
      printf "windows"
    else
      return 1
    fi
    ;;
  esac
}

wally::_get_bin_latest_url_os() {
  local os="${1:-$(wally::_get_os)}"
  if [[ -z "$os" ]]; then
    return
  fi
  script::depends_on curl jq

  local -r gh_releases_url="$(github::get_api_url "$WALLY_GITHUB_REPOSITORY" "releases")"

  #shellcheck disable=SC2016
  _jq_args=(--arg OS "$os" -r '.[].assets[0].browser_download_url | values | select(contains($OS))')
  github::curl --no-cache "$gh_releases_url" | jq "${_jq_args[@]}" | head -n 1 | xargs
}

wally::_get_latest_version_os() {
  script::depends_on curl jq
  local -r os="${1:-$(wally::_get_os)}"
  local -r download_url="$(wally::_get_bin_latest_url_os "$os")"
  if [[ -z "$download_url" ]]; then
    output::error "Could not get latest version"
    return 1
  fi

  printf "%s" "$(echo "$download_url" | awk -F '/' "{sub(\"$os\",\"\", \$8);print \$8}")"
}

wally::_install() {
  if platform::is_macos; then
    script::depends_on libusb
  fi

  local -r download_url="$(wally::_get_bin_latest_url_os)"

  echo "$download_url"

  curl -fL "$download_url" --output "$WALLY_INSTALL_PATH" &&
    chmod u+x "$WALLY_INSTALL_PATH"
}

wally::_uninstall() {
  rm -f "$WALLY_INSTALL_PATH"
}

# REQUIRED FUNCTION
wally::is_installed() {
  [[ -x "$WALLY_INSTALL_PATH" ]] || platform::command_exists "$WALLY_BIN_NAME"
}

# REQUIRED FUNCTION
wally::install() {
  if [[ " $* " == *" --force "* ]]; then
    # output::answer "\`--force\` option is ignored with this recipe"
    wally::force_install "$@" &&
      return
  elif ! wally::is_installed; then
    wally::_install "$@"

    wally::is_installed &&
      output::solution "wally-cli installed" &&
      return 0
  else
    output::answer "wally-cli already installed"
    return 0
  fi

  output::error "wally-cli could not be installed"
  return 1
}

# OPTIONAL
wally::uninstall() {
  wally::_uninstall

  ! wally::is_installed &&
    output::solution "wally-cli uninstalled" &&
    return 0

  ourput::error "wally-cli could not be uninstalled"
  return 1
}

# OPTIONAL
wally::force_install() {
  local _args
  mapfile -t _args < <(array::substract "--force" "$@")

  wally::uninstall "${_args[@]}" &&
    wally::install "${_args[@]}"

  wally::is_installed "${_args[@]}"
}

# ONLY REQUIRED IF YOU WANT TO IMPLEMENT AUTO UPDATE WHEN USING `up` or `up registry`
# Description, url and versions only be showed if defined
wally::is_outdated() {
  # Check if current installed version is outdated, 0 means needs to be updated
  return 1
}

wally::upgrade() {
  # Steps to upgrade
  sleep 1s
  # Do stuff to upgrade the package
}

wally::description() {
  echo "Flash your ZSA Keyboard the EZ way."
}

wally::url() {
  # Please modify
  printf "%s\n" "https://ergodox-ez.com/pages/wally"
}

wally::version() {
  # Get the current installed version
  wally-cli --version
}

wally::latest() {
  if wally::is_outdated; then
    # If it is outdated do whatever to get the current version
    echo " > $(wally::version)"
  else
    wally::version
  fi
}

wally::title() {
  echo -n "🐐 wally-cli"
}
