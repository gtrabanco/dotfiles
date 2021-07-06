#!/usr/bin/env bash

if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash; then
  export NVM_DIR="$HOME/.nvm"
  #shellcheck source=/dev/null
  {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install stable
    nvm install node
    nvm alias default node
  } || {
    output::empty_line
    output::error "NVM se instaló pero no pudo descargarse la última versión de Node"
    output::empty_line
  }
else
  output::empty_line
  output::error "Error installing nvm"
  output::empty_line
fi
