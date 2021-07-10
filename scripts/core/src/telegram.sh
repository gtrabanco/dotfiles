#!/usr/bin/env bash

# Variables
[[ -z "$TELEGRAM_API_KEY" ]] && TELEGRAM_API_KEY="$(dot secrets var TELEGRAM_API_KEY)"
[[ -z "$TELEGRAM_GROUP_ID" ]] && TELEGRAM_GROUP_ID="$(dot secrets var TELEGRAM_GROUP_ID)"
[[ -z "$TELEGRAM_VIM_NAME" ]] && TELEGRAM_VIM_NAME="$(dot secrets var TELEGRAM_VIM_NAME)"

telegram::send_message() {
  script::depends_on curl jq
  if [[ -n "$*" ]]; then
    data=$(curl --silent "https://api.telegram.org/bot${BOT_API_KEY}/sendMessage" --data-urlencode "chat_id=${BOT_CHAT_ID}" --data-urlencode "text=$*")
    [[ $(echo "$data" | jq -r '.ok') != "true" ]]
  else
    return 1
  fi
}
