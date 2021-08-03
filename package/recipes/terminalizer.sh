#!/usr/bin/env bash

terminalizer::install() {
  if [[ -r "${SLOTH_PATH:-${DOTLY_PATH:-}}/shell/init.scripts/nvm" ]]; then
    #shellcheck disable=SC1091
    . "${SLOTH_PATH:-${DOTLY_PATH:-}}/shell/init.scripts/nvm"
  fi
  script::depends_on nvm

  if platform::command_exists yum && sudo -v -B; then
    sudo yum install -y libXScrnSaver
  fi

  if platform::command_exists apt-get && sudo -v -B; then
    sudo apt-get install -y libgconf-2-4
  fi

  npm install -g terminalizer

  terminalizer::is_installed && output::answer "\`terminalizer\` installed"
}

terminalizer::is_installed() {
  platform::command_exists terminalizer
}
