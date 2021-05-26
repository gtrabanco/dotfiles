# TOKENS are loaded in init-scripts because we need dot
[[ -z "$HASS_FQDN" ]] && HASS_FQDN="$(dot secrets var HASS_FQDN)"
[[ -z "$HASS_TOKEN" ]] && HASS_TOKEN="$(dot secrets var HASS_TOKEN)"
[[ -z "$GITHUB_TOKEN" ]] && GITHUB_TOKEN="$(dot secrets var GITHUB_TOKEN)"
[[ -z "$NTFY_PUSHOVER_TOKEN" ]] && NTFY_PUSHOVER_TOKEN="$(dot secrets var NTFY_PUSHOVER_TOKEN)"
export HASS_FQDN HASS_TOKEN GITHUB_TOKEN NTFY_PUSHOVER_TOKEN