#!/usr/bin/env bash

. "$DOTLY_PATH/bin/scripts/core/_main.sh"

is_macos() {
  command -v platform::is_macos &> /dev/null && platform::is_macos
}

security::duti() {
  if is_macos && command -v platform::command_exists &> /dev/null && platform::command_exists duti; then
    duti -s com.apple.Safari afp
    duti -s com.apple.Safari ftp
    duti -s com.apple.Safari nfs
    duti -s com.apple.Safari smb
    duti -s com.apple.TextEdit public.unix-executable
  fi
}

if is_macos; then
  security::duti

  # Disable NETBIOS
  sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.netbiosd.plist

  # No Crash Reports
  defaults write com.apple.CrashReporter DialogType none

  # Security mode
  "$DOTLY_PATH/bin/dot" mac security_mode travel
  "$DOTLY_PATH/bin/dot" mac security_mode captive_off
  
  # Disable ocsp checking in macos
  ! grep -q 'ocsp.apple.com' /etc/hosts && echo "0.0.0.0\tocsp.apple.com" | sudo tee -a /etc/hosts && sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
fi