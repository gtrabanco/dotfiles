#!/usr/bin/env bash

# gh_latest=""
# gh::_latest_version() {
#   local -r repository="cli/cli"
#   local -r url_relase="https://api.github.com/repos/${repository}/releases/latest"
  
#   [[ -n "$gh_latest" ]] && echo -n "$gh_latest" && return

#   script::depends_on curl jq
#   gh_latest="$(curl --silent "$url_relase" | jq -r '.tag_name')"

#   echo -n "$gh_latest"
# }

gh::install() {
  package::install gh && gh::is_installed
}

gh::is_installed() {
  platform::command_exists gh
}

# gh::is_outdated() {
#   ! gh::is_installed && return 1

#   if platform::command_exists brew; then
#     [[ -n "$(brew outdated gh)" ]]
#   else
#     local -r installed_release="$(gh --version | head -n 1 | awk '{print $3}')"
#     local -r is_outdated=$(platform::semver_compare "$(gh::_latest_version)" "$installed_release")

#     [[ $is_outdated -eq 1 ]]
#   fi
# }
