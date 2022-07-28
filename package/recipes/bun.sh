#!/usr/bin/env bash
#? Author:
#?   Gabriel Trabanco Llano <gtrabanco@users.noreply.github.com>
#? This file contains instrucctions to install the package bun
#? v1.0.0

BUN_GITHUB_REPOSITORY="${BUN_GITHUB_REPOSITORY:-oven-sh/bun}"
BUN_INSTALL="${BUN_INSTALL:-${HOME}/.bun}"
BUN_BIN_DIR="${BUN_BIN_DIR:-${BUN_INSTALL}/bin}"
BUN_BIN_FILE="${BUN_BIN_FILE:-${BUN_BIN_DIR}/bun}"
BUN_COMPLETIONS_INIT_SCRIPT="${BUN_COMPLETIONS_INIT_SCRIPT:-bun-completions}"

bun::target() {
  case $(uname -sm) in
  "Darwin x86_64")
    if sysctl sysctl.proc_translated >/dev/null 2>&1; then
      target="darwin-aarch64"
    else
      target="darwin-x64"
    fi
    ;;
  "Darwin arm64") target="darwin-aarch64" ;;
  "Linux aarch64") target="linux-aarch64" ;;
  "Linux arm64") target="linux-aarch64" ;;
  "Linux x86_64") target="linux-x64" ;;
  *) target="linux-x64" ;;
  esac

  printf "%s" "$target"
}

bun::install_script() {
  local target download_url tmp_path release_filename
  script::depends_on unzip
  dot::load_library github

  target="$(bun::target)"
  release_filename="bun-${target}.zip"
  download_url="$(github::get_latest_package_release_download_url "$BUN_GITHUB_REPOSITORY" | grep "${release_filename}$")"
  if [[ -z "$download_url" ]]; then
    return 1
  fi

  tmp_path="$(mktemp -d)"
  curl --fail --location --silent --output "${tmp_path}/${release_filename}" "$download_url"
  unzip -o "${tmp_path}/${release_filename}"
  mv "${tmp_path}/bun-${target}/bun" "$BUN_BIN_FILE"
  chmod u+x "$BUN_BIN_FILE"
}

bun::init_script() {
  cat <<EOF
#!/usr/bin/env bash

if [ -s "${HOME}/.bun/_bun" ]; then
  #shellcheck disable=SC1091
  . "${HOME}/.bun/_bun"
fi

EOF
}

bun::create_enable_init_script() {
  dot::load_library init init

  if ! init::exists_script "${BUN_COMPLETIONS_INIT_SCRIPT}"; then
    bun::init_script | tee "${DOTFILES_INIT_SCRIPTS_PATH}/${BUN_COMPLETIONS_INIT_SCRIPT}" >/dev/null 2>&1
  fi

  init::enable "${BUN_COMPLETIONS_INIT_SCRIPT}"
}

bun::disable_init_script() {
  dot::load_library init init

  if init::exists_script "${BUN_COMPLETIONS_INIT_SCRIPT}"; then
    init::disable "${BUN_COMPLETIONS_INIT_SCRIPT}"
  fi
}

# REQUIRED FUNCTION
bun::is_installed() {
  platform::command_exists bun || [[ -x "$BUN_BIN_FILE" ]]
}

# REQUIRED FUNCTION
bun::install() {
  if [[ " $* " == *" --force "* ]]; then
    # output::answer "\`--force\` option is ignored with this recipe"
    bun::force_install "$@" &&
      return
  else
    # Install using a package manager, in this case auto but you can choose brew, pip...
    bun::install_script

    if bun::is_installed; then
      bun::create_enable_init_script
    fi

    bun::is_installed &&
      output::solution "bun installed" &&
      return 0
  fi

  output::error "bun could not be installed"
  return 1
}

# OPTIONAL
bun::uninstall() {
  local bun_path="${BUN_INSTALL}"

  if [[ -d "${bun_path}" ]]; then
    rm -rf "${bun_path}"
  fi

  if command -v bun &>/dev/null; then
    dirname "$(dirname "$(command -v bun)")" | xargs rm -rf
  fi

  # Disable init script if it exists and is enable
  bun::disable_init_script

  ! bun::is_installed &&
    output::solution "bun uninstalled" &&
    return 0

  ourput::error "bun could not be uninstalled"
  return 1
}

# OPTIONAL
bun::force_install() {
  local _args
  mapfile -t _args < <(array::substract "--force" "$@")

  bun::uninstall "${_args[@]}"
  bun::install "${_args[@]}"

  bun::is_installed "${_args[@]}"
}

# ONLY REQUIRED IF YOU WANT TO IMPLEMENT AUTO UPDATE WHEN USING `up` or `up registry`
# Description, url and versions only be showed if defined

bun::upgrade() {
  ! bun::is_installed && return 1
  bun upgrade >/dev/null 2>&1
  return $?
}

bun::description() {
  echo "Bundle, transpile, install and run JavaScript & TypeScript projects — all in Bun. Bun is a new JavaScript runtime with a native bundler, transpiler, task runner and npm client built-in.."
}

bun::url() {
  # Please modify
  echo "https://bun.sh"
}

bun::version() {
  # Get the current installed version
  bun --version
}

bun::latest() {
  dot::load_library github

  bun_remote_version=$(curl --silent "$(github::get_api_url oven-sh/bun "releases/latest")" | jq -r '.tag_name')
  printf "%s\n" "${bun_remote_version##*v}"
}

bun::is_outdated() {
  local -r latest="$(bun::latest)"
  local -r installed="$(bun::version)"
  [[ -z "$installed" || -z "$latest" ]] && return 1
  [[ $(platform::semver_compare "$installed" "$latest") -eq -1 ]]
}

bun::title() {
  echo -n "🧅 bun"
}
