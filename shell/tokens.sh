#!/usr/bin/env bash
# TOKENS are loaded via Infisical (00-infisical-dotfiles init script).
# This file only handles tokens that come from external providers (gh CLI).

if command -v gh &>/dev/null; then
  [[ -z "$GITHUB_TOKEN" ]] && GITHUB_TOKEN="$(gh auth token)"
  [[ -z "$HOMEBREW_GITHUB_API_TOKEN" ]] && HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
  export GITHUB_TOKEN HOMEBREW_GITHUB_API_TOKEN
fi
