#!/usr/bin/env bash

if [[ -n "$("$DOTLY_PATH/bin/dot" secrets var NTFY_PUSHOVER_TOKEN)" ]] && [[ ! -f "$HOME/.ntfy.yml" ]]; then

  echo "backends: [\"pushover\"]" >| "$HOME/.ntfy.yml"
  echo "pushover: {\"user_key\": \"$("$DOTLY_PATH/bin/dot" secrets var NTFY_PUSHOVER_TOKEN)\"}\"" >> "$HOME/.ntfy.yml"
fi
