#!/usr/bin/env bash
# .Sloth configuration
#export SLOTH_THEME=sloth
export SLOTH_THEME=codely
#export SLOTH_THEME=spaceship
export SLOTH_THEME_MULTILINE=false
export SLOTH_THEME_MINIMAL=false
export SLOTH_THEME_SHOW_UNTRACKED=true
export SLOTH_THEME_SHOW_BEHIND=true
export SLOTH_USE_RIGHT_PROMPT=false # Only when no minimal is set

export SLOTH_ENV="development" # Avoids updating if .Sloth path is dirty. Important
# to not loosing time developing stuff that will ends in /dev/null
export SLOTH_AUTO_UPDATE_PERIOD_IN_DAYS=7
export SLOTH_AUTO_UPDATE_MODE="auto" # silent, auto (default), info, prompt
export SLOTH_UPDATE_VERSION="latest" # latest, stable (default), minor
export SLOTH_INIT_SCRIPTS=true       # This makes slower the initialization
# (depending on how fast are init scripts...), but provides a lot of functionality

# Secrets config
export DOTLY_SECRETS_VAR_MACOS_STORE="keychain" # filepath or keychain (only macos)

# Git binary we want to use
export GIT_EXECUTABLE="/usr/local/bin/git"

# Avoid touching any of my dotfiles while installing something
export PROFILE="/dev/null"

# Debug for autocompletions
export BASH_COMP_DEBUG_FILE="${HOME}/bash-autocompletions.log"

# Do you want to make .Sloth loader 12ms faster?
export BREW_BIN="/Users/gtrabanco/.homebrew/bin/brew"
export HOMEBREW_PREFIX="/Users/gtrabanco/.homebrew"

# Homebrew
# https://docs.brew.sh/Manpage#environment
# export HOMEBREW_GITHUB_API_TOKEN # This variable is set with tokens
export HOMEBREW_AUTO_UPDATE_SECS=259300 # 3 days
export HOMEBREW_NO_ANALYTICS=true
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_NO_ENV_HINTS=true

# History
export HISTCONTROL="ignoredups"               # no duplicate entries, but keep space-prefixed commands
export HISTSIZE=100000                        # big big history (default is 500)
export HISTFILESIZE=${HISTSIZE}               # big big history
type shopt &>/dev/null && shopt -s histappend # append to history, don't overwrite it

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

export GEM_HOME="${HOME}/.gem"

export NVM_DIR="${HOME}/.nvm"
# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768'
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy'
# nvm
export NVM_DIR="${HOME}/.nvm"

# BUN and BUN_PATH
export BUN_PATH="${HOME}/.bun"

# PNPM Path
export PNPM_HOME="${HOME}/Library/pnpm"

# Java
JAVA_8_HOME="$(/usr/libexec/java_home -v1.8 /dev/null 2>&1)"
JAVA_11_HOME="$(/usr/libexec/java_home -v11 /dev/null 2>&1)"
JAVA_LATEST="$(/usr/libexec/java_home 2>&1 /dev/null)"
export JAVA_8_HOME JAVA_11_HOME JAVA_LATEST
export JAVA_HOME="$JAVA_LATEST"

export FZF_DEFAULT_OPTS='
  --color=pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934
  --reverse
'

#EDITOR="/usr/local/bin/code"
EDITOR="/usr/bin/vim"
export EDITOR

export LANG=en_GB.UTF-8

# HASSIO
#export HASS_SCHEME="https"
#export HASS_PORT="443"

export ZSA_KEYBOARD_ID="r5Pzw"
