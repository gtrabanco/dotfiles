export DOTLY_AUTO_UPDATE_PERIOD_IN_DAYS=7
export DOTLY_AUTO_UPDATE_MODE="auto" # silent, auto, info, prompt
export DOTLY_UPDATE_VERSION="latest" # latest, stable, minor
#export DOTLY_NO_INIT_SCRIPTS=True

# Homebrew
export HOMEBREW_AUTO_UPDATE_SECS=259300 # 3 days
export HOMEBREW_NO_ANALYTICS=true

export HISTCONTROL=ignoredups
export GEM_HOME="$HOME/.gem"
export GOPATH="$HOME/.go"

export NVM_DIR="$HOME/.nvm"
# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';
# nvm
export NVM_DIR="$HOME/.nvm"

# Java
JAVA_8_HOME=$(/usr/libexec/java_home -v1.8 2>&1 /dev/null)
JAVA_11_HOME=$(/usr/libexec/java_home -v11 2>&1 /dev/null)
JAVA_LATEST=$(/usr/libexec/java_home 2>&1 /dev/null)
export JAVA_8_HOME JAVA_11_HOME JAVA_LATEST
export JAVA_HOME="$JAVA_LATEST"

export FZF_DEFAULT_OPTS='
  --color=pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934
  --reverse
'

GPG_TTY=$(tty)
export GPG_TTY

EDITOR="$(which vim)"
export EDITOR

export LANG=en_GB.UTF-8

# HASSIO
#export HASS_SCHEME="https"
#export HASS_PORT="443"

# TOKENS
[[ -z "$HASS_FQDN" ]] && HASS_FQDN="$(dot secrets var HASS_FQDN)"
[[ -z "$HASS_TOKEN" ]] && HASS_TOKEN="$(dot secrets var HASS_TOKEN)"
[[ -z "$GITHUB_TOKEN" ]] && GITHUB_TOKEN="$(dot secrets var GITHUB_TOKEN)"
[[ -z "$NTFY_PUSHOVER_TOKEN" ]] && NTFY_PUSHOVER_TOKEN="$(dot secrets var NTFY_PUSHOVER_TOKEN)"
export HASS_FQDN HASS_TOKEN GITHUB_TOKEN NTFY_PUSHOVER_TOKEN