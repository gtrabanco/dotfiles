#!/usr/bin/env bash

HASS_SCHEME=${HASS_SCHEME:-http}
HASS_PORT=${HASS_PORT:-8123}
HASS_FQDN=${HASS_FQDN:-casa.local}
[[ -z "${HASS_TOKEN:-}" ]] && output::error "No token provided" && exit 1

case "$HASS_PORT" in
  80)
    HASS_SCHEME="http"
    HASS_URL="$HASS_SCHEME://$HASS_FQDN"
    ;;
  443)
    HASS_SCHEME="http"
    HASS_URL="$HASS_SCHEME://$HASS_FQDN"
    ;;
  *)
    HASS_URL="$HASS_SCHEME://$HASS_FQDN:$HASS_PORT"
    ;;
esac

if ! nc -z "$HASS_FQDN" "$HASS_PORT" 2>&1 | grep -q "succeeded"; then
  output::error "Connection to $HASS_URL"
  exit 1
fi

HASS_API_URL="$HASS_URL/api"

ha::service() {
  local service json url
  [[ -z "${1:-}" ]] && return 1
  service="$(echo "${1:-}" | tr "." "/")"
  shift
  json="${*:-}"
  url="$HASS_API_URL/services/$service"

  curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $HASS_TOKEN" "$url" || return 1
}

ha::entity() {
  local entity url
  [[ -z "${1:-}" ]] && return 1
  entity="$(echo "${1:-}" | tr "." "/")"
  shift
  url="$HASS_API_URL/states/$entity"

  echo curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $HASS_TOKEN" -d "$json" "$url" || return 1
  #curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $HASS_TOKEN" -d "$json" "$url" || return 1
}