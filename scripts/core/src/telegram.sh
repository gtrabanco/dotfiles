#!/usr/bin/env bash

# Variables (loaded from Infisical via 00-infisical-dotfiles)

telegram::send_message() {
  script::depends_on curl jq
  if [[ -n "$*" ]]; then
    data=$(curl --silent "https://api.telegram.org/bot${TELEGRAM_API_KEY}/sendMessage" --data-urlencode "chat_id=${TELEGRAM_GROUP_ID}" --data-urlencode "text=$*")
    [[ $(echo "$data" | jq -r '.ok') != "true" ]]
  else
    return 1
  fi
}
