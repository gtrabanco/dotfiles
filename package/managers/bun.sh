#!/usr/bin/env bash

bun_title='🧅 Bun'
NPM_API_ENDPOINT="${NPM_API_ENDPOINT:-https://registry.npmjs.org}"
BUN_DUMP_FILE_PATH="${BUN_DUMP_FILE_PATH:-${DOTFILES_PATH}/langs/js/bun/global_modules.txt}"

bun::title() {
  echo -n "🧅 Bun"
}

bun::is_available() {
  platform::command_exists bun
}

bun::install() {
  local force=false packages
  ! bun::is_available && return 1

  if [[ $* == *--force* ]]; then
    force=true
  fi

  readarray -t packages < <(array::substract "--force" "$@")

  if $force; then
    bun install --global --force "${packages[@]}"
  else
    bun install --global "${packages[@]}"
  fi
}

bun::force_install() {
  local _args
  readarray -t _args < <(array::substract "--force" "$@")
  bun install --global --force "${_args[@]}"
}

bun::uninstall() {
  [[ $# -gt 0 ]] && bun::is_available && bun uninstall --global "$@"
}

bun::package_exists() {
  [[ -z "${1:-}" ]] && return 1

  local -r package_endpoing="${NPM_API_ENDPOINT}/${1}"
  local -r package_response=$(curl -s -o /dev/null -w "%{http_code}" "$package_endpoing")

  [[ "$package_response" == "200" ]] && return 0
}

bun::is_installed() {
  ! bun::is_available && return 1

  # if args is greater than 1, recursive call
  if [[ $# -gt 1 ]]; then
    bun::is_installed "$1" && bun::is_installed "${@:2}"
    return $?
  fi

  bun pm --global ls --all | tail -n +2 | awk '{print $2}' | grep "^${1}@" >/dev/null 2>&1 && return 0
  return 1
}

bun::update_all() {
  bun::self_update
  bun::update_apps
}

bun::self_update() {
  # Not necesary with bun
  return 0
}

bun::npm_package_latest_version() {
  local package_name="$1"
  local package_version
  package_version=$(curl -s "${NPM_API_ENDPOINT}/${package_name}/latest" | jq -r '.version')

  printf "%s" "$package_version"
}

bun::is_package_outdated() {
  local -r package_name="$1"
  local -r package_version="$2"
  local -r package_latest_version=$(bun::npm_package_latest_version "$package_name")

  [[ "$package_version" != "$package_latest_version" ]] && return 0

  return 1
}

bun::update_apps() {
  ! bun::is_available && return 1
  local any_update=false outdated_apps outdated_app app_name app_version app_cache_json app_latest_version app_info
  # Is all installed packages, need to check each one... Calling NPM api for each not sure if can overpass any limit
  readarray -t outdated_apps < <(bun pm --global ls --all | tail -n +2 | awk '{print $2}')

  for outdated_app in "${outdated_apps[@]}"; do
    app_name=$(echo "$outdated_app" | cut -d@ -f1)
    app_version=$(echo "$outdated_app" | cut -d@ -f2)

    if [[ -z "$app_version" || -z "$app_name" ]]; then
      continue
    fi

    app_cache_json="$(curl -fsL "${NPM_API_ENDPOINT}/${app_name}/latest")"

    if [[ -z "${app_cache_json:-}" ]]; then
      echo "Error: ${bun_title} app: $app_name not found"
      continue
    fi

    app_latest_version=$(printf "%s" "$app_cache_json" | jq -r '.version')
    if [[ $app_version == "$app_latest_version" ]]; then
      continue # Skip if already latest version
    fi

    app_info=$(printf "%s" "$app_cache_json" | jq -r '.description')

    output::write "🧅 $app_name"
    output::write "├ ${app_version} -> ${app_latest_version}"
    output::write "└ $app_info"
    output::empty_line
    any_update=true

    bun install --global "$outdated_app@latest" 2>&1 | log::file "Updating ${bun_title} app: $app_name" || true
  done

  if ! $any_update; then
    output::answer "${bun_title}: Already up-to-date"
  fi

  return 0
}

bun::cleanup() {
  ! bun::is_available && return 1
  bun pm --global cache rm
  output::answer "${bun_title} cleanup complete"
}

bun::dump() {
  ! bun::is_available && return 1
  BUN_DUMP_FILE_PATH="${1:-$BUN_DUMP_FILE_PATH}"
  local -r apps
  readarray -t apps < <(bun pm --global ls --all | tail -n +2 | awk '{print $2}' | cut -d@ -f1)

  log::append "Exporting ${bun_title} packages"
  if package::common_dump_check bun "$BUN_DUMP_FILE_PATH"; then
    printf "%s\n" "${apps[@]}" | tee "$BUN_DUMP_FILE_PATH"

    return 0
  fi

  return 1
}

bun::import() {
  ! bun::is_available && return 1
  BUN_DUMP_FILE_PATH="${1:-$BUN_DUMP_FILE_PATH}"

  if package::common_import_check bun "$BUN_DUMP_FILE_PATH"; then
    xargs -I_ bun install --global _ <"$BUN_DUMP_FILE_PATH" | log::file "Importing ${bun_title} packages"
    return 0
  fi

  return 1
}
