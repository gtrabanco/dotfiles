#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update All System Packages
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ♻️
# @raycast.argument1 { "type": "text", "placeholder": "Package Manager", "optional": true }
# @raycast.packageName System
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Update all applications of all package managers that are supported by .Sloth
# @raycast.author Gabriel Trabanco
# @raycast.authorURL https://github.com/gtrabanco

if command -v dot &> /dev/null; then
  if [[ -n "${1:-}" && $1 != "all" ]]; then
    dot package update_all "${1:-}" | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'
  else
    dot package update_all | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'
  fi
elif [[ -f "${HOME}/.bashrc" ]]; then
  #shellcheck disable=SC1091
  . "${HOME}/.bashrc"

  if [[ ! -x "${SLOTH_PATH}/bin/dot" ]]; then
    echo "Error: dot is not installed"
    exit 1
  fi

  if [[ -n "${1:-}" && $1 != "all" ]]; then
    "${SLOTH_PATH}/bin/dot" package update_all "${1:-}" | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'
  else
    "${SLOTH_PATH}/bin/dot" package update_all | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'
  fi
fi
