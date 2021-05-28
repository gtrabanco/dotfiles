#!/usr/bin/env bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash || {
    output::empty_line
    output::error "Error installing nvm"
    output::empty_line
}
