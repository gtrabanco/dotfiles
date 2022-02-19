#!/usr/bin/env bash
#? Author:
#?   Gabriel Trabanco Llano <gtrabanco@users.noreply.github.com>
#? This file contains instrucctions to install the package ffmpeg
#? v1.0.0

# Stable:
# FFMPEG_URL_ZIP="${FFMPEG_URL_ZIP:-https://evermeet.cx/ffmpeg/ffmpeg-5.0.zip}"
# Latest
# FFMPEG_URL_ZIP="${FFMPEG_URL_ZIP:-https://evermeet.cx/ffmpeg/get/zip}"
FFMPEG_URL_INFO="${FFMPEG_URL_INFO:-https://evermeet.cx/ffmpeg/info}"
FFMPEG_INSTALL_PATH="${FFMPEG_INSTALL_PATH:-${HOME}/bin}"

ffmpeg::get_latest_zip_url() {
  script::depends_on curl jq
  curl -fsL "$FFMPEG_URL_INFO" | jq -r '.[] | select(.name == "ffmpeg") | select(.type == "release") | .download.zip.url'
}

# REQUIRED FUNCTION
ffmpeg::is_installed() {
  [ -x "${FFMPEG_INSTALL_PATH}/ffmpeg" ]
}

# REQUIRED FUNCTION
ffmpeg::install() {
  if [[ " $* " == *" --force "* ]]; then
    # output::answer "\`--force\` option is ignored with this recipe"
    ffmpeg::force_install "$@" &&
      return
  else
    local -r zip_url="$(ffmpeg::get_latest_zip_url)"
    if [ -z "$zip_url" ]; then
      output::error "ffmpeg download url could not be determined with the url: \`FFMPEG_URL_INFO=\"$FFMPEG_URL_INFO\"\`"
      return 1
    fi
    local -r tmp="$(mktemp)"

    curl -sfL "$zip_url" -o "$tmp"
    unzip -od "$FFMPEG_INSTALL_PATH" "$tmp"

    ffmpeg::is_installed &&
      output::solution "ffmpeg installed" &&
      return 0
  fi

  output::error "ffmpeg could not be installed"
  return 1
}

# OPTIONAL
ffmpeg::uninstall() {
  rm -rf "${FFMPEG_INSTALL_PATH}/ffmpeg"

  ! ffmpeg::is_installed &&
    output::solution "ffmpeg uninstalled" &&
    return 0
  
  ourput::error "ffmpeg could not be uninstalled"
  return 1
}

# OPTIONAL
ffmpeg::force_install() {
  local _args
  mapfile -t _args < <(array::substract "--force" "$@")
  
  ffmpeg::uninstall "${_args[@]}"
  ffmpeg::install "${_args[@]}"

  ffmpeg::is_installed "${_args[@]}" &&
    output::solution "ffmpeg installed" &&
    return
  
  output::error "ffmpeg could not be installed" &&
    return 1
}

ffmpeg::latest() {
  script::depends_on curl jq
  curl -fsL "$FFMPEG_URL_INFO" | jq -r '.[] | select(.name == "ffmpeg") | select(.type == "release") | .version'
}

# ONLY REQUIRED IF YOU WANT TO IMPLEMENT AUTO UPDATE WHEN USING `up` or `up registry`
# Description, url and versions only be showed if defined
ffmpeg::is_outdated() {
  #shellcheck disable=SC2207
  local -r current=($(ffmpeg --help 2>&1 | awk '/ffmpeg version ([01-9]+\.[01-9]+){1}/ {gsub(/[^\.0-9]*$/, "", $3); gsub(/\./, "\n", $3); print $3}'))
  #shellcheck disable=SC2207
  local -r latest=($(ffmpeg::latest | awk '{gsub(/[.-]/, "\n", $0); print}'))

  if [ "${current[0]}" -lt "${latest[0]}" ]; then
    return 0
  fi

  if [ "${current[1]:-0}" -lt "${latest[1]:-0}" ]; then
    return 0
  fi

  return 1
}

ffmpeg::upgrade() {
  ffmpeg::uninstall
  ffmpeg::install
}

ffmpeg::description() {
  echo "FFmpeg is the leading multimedia framework, able to decode, encode, transcode, mux, demux, stream, filter and play pretty much anything that humans and machines have created."
}

ffmpeg::url() {
  # Please modify
  echo "https://ffmpeg.org"
}

ffmpeg::version() {
  {
    ffmpeg::is_installed && ffmpeg --help 2>&1 | awk '/ffmpeg version ([01-9]+\.[01-9]+){1}/ {gsub(/[^\.0-9]*$/, "", $3); print $3}'
  } || true
}

ffmpeg::title() {
  echo -n "FFMPEG"
}