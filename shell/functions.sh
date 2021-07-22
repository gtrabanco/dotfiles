#!/usr/bin/env bash
#shellcheck disable=SC1090

execute_from_url() {
  [[ -n "${1:-}" ]] && bash <(curl -fskL "${1}")
}

load_from_url() {
  [[ -n "${1:-}" ]] && . <(curl -fskL "${1}")
}
