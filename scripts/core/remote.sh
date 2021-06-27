remote::require_script() {
  local url http_code CURL_BIN
  [[ $# -lt 1 ]] && return 1
  url="${1:-}"
  CURL_BIN="${2:-$(which curl)}"
  http_code="$(curl -o /dev/null -Isw '%{http_code}' "$url")"
  
  [[ "$http_code" != "200" ]] && return 1
  #shellcheck disable=SC1090
  . <( curl --silent "$url" ) || return 1
}