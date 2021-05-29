#!/usr/bin/env bash

output::header "Executing custom install scripts"

# Avoid touching dotfiles while installing
export PREVIOUS_PROFILE="${PROFILE:-}"
export PROFILE="/dev/null"
