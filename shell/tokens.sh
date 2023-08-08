#!/usr/bin/env bash
# TOKENS are loaded in init-scripts because we need dot
if command -v dot > /dev/null 2>&1; then
  [[ -z "$HASS_FQDN" ]] && HASS_FQDN="$(dot secrets var HASS_FQDN)"
  [[ -z "$HASS_TOKEN" ]] && HASS_TOKEN="$(dot secrets var HASS_TOKEN)"
  [[ -z "$GITHUB_TOKEN" ]] && GITHUB_TOKEN="$(dot secrets var GITHUB_TOKEN)" && HOMEBREW_GITHUB_API_TOKEN="$(dot secrets var GITHUB_TOKEN || echo "${GITHUB_TOKEN}")"
  [[ -z "$NTFY_PUSHOVER_TOKEN" ]] && NTFY_PUSHOVER_TOKEN="$(dot secrets var NTFY_PUSHOVER_TOKEN)"
  [[ -z "$TELEGRAM_API_KEY" ]] && TELEGRAM_API_KEY="$(dot secrets var TELEGRAM_API_KEY)"
  [[ -z "$TELEGRAM_GROUP_ID" ]] && TELEGRAM_GROUP_ID="$(dot secrets var TELEGRAM_GROUP_ID)"
  [[ -z "$TELEGRAM_VIM_NAME" ]] && TELEGRAM_VIM_NAME="$(dot secrets var TELEGRAM_VIM_NAME)"
  export HASS_FQDN HASS_TOKEN HOMEBREW_GITHUB_API_TOKEN GITHUB_TOKEN NTFY_PUSHOVER_TOKEN TELEGRAM_API_KEY TELEGRAM_GROUP_ID TELEGRAM_VIM_NAME
fi
