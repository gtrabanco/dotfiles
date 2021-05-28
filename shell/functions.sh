bash_from_url() {
  [[ -n "${1:-}" ]] && bash <(curl -fskL "${1}")
}
