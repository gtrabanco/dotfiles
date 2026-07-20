#!/usr/bin/env bash

NTFY_PUSHOVER_TOKEN="${NTFY_PUSHOVER_TOKEN:-}"

if [[ -z "$NTFY_PUSHOVER_TOKEN" ]] && command -v infisical &>/dev/null; then
  NTFY_PUSHOVER_TOKEN="$(infisical secret get NTFY_PUSHOVER_TOKEN --plain 2>/dev/null || true)"
fi

if [[ -n "$NTFY_PUSHOVER_TOKEN" ]] && [[ ! -f "$HOME/.ntfy.yml" ]]; then
  echo "backends: [\"pushover\"]" >| "$HOME/.ntfy.yml"
  echo "pushover: {\"user_key\": \"${NTFY_PUSHOVER_TOKEN}\"}" >> "$HOME/.ntfy.yml"
fi
