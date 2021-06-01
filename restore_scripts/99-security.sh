#!/usr/bin/env bash

. "$DOTLY_PATH/bin/scripts/core/_main.sh"

security::duti() {
  if declare -F platform::is_macos && platform::is_macos && platform::command_exists duti; then
    duti -s com.apple.Safari afp
    duti -s com.apple.Safari ftp
    duti -s com.apple.Safari nfs
    duti -s com.apple.Safari smb
    duti -s com.apple.TextEdit public.unix-executable
  fi
}

if declare -F platform::is_macos; then
  security::duti

  # Disable NETBIOS
  sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.netbiosd.plist

  # No Crash Reports
  defaults write com.apple.CrashReporter DialogType none
fi

# TODO WIP
