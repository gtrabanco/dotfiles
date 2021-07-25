#!/usr/bin/env bash

# Applying https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/mac_build_instructions.md#improving-performance-of
#

# To allow execute this script alone without .Sloth/Dotly
if ! command -v platform::is_macos; then
  platform::is_macos() {
    [[ "$(uname -s)" == "Darwin" ]]
  }
fi

if platform::is_macos && sudo -v -B; then
  # 512*1024 = 524288
  sudo sysctl kern.maxvnodes=$((512*1024))
  # Make it permanent
  sudo bash -c "echo kern.maxvnodes=$((512*1024)) | tee -a /etc/sysctl.conf"

  # If you have updated CLT the minimum git version should be 2.30
  git config --global core.untrackedCache true
  git update-index --test-untracked-cache --refresh
fi