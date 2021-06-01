#!/usr/bin/env bash

output::solution "End of custom install scripts"

# Restore PROFILE value
export PROFILE="$PREVIOUS_PROFILE"
unset PREVIOUS_PROFILE

# Restore dotfiles because while installing some packages maybe they modified any of my dotfiles
git checkout --force master
