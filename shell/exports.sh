export DOTLY_AUTO_UPDATE_DAYS=7
export DOTLY_AUTO_UPDATE_MODE="silent"

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
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8 2>&1 /dev/null)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11 2>&1 /dev/null)
export JAVA_LATEST=$(/usr/libexec/java_home 2>&1 /dev/null)
export JAVA_HOME="$JAVA_LATEST"

export FZF_DEFAULT_OPTS='
  --color=pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934
  --reverse
'

export GPG_TTY=$(tty)

export EDITOR="$(which vim)"

export LANG=en_GB.UTF-8

[[ -z "$GITHUB_TOKEN" ]] && export GITHUB_TOKEN="$(dot secrets var GITHUB_TOKEN)"
[[ -z "$NTFY_PUSHOVER_TOKEN" ]] && export NTFY_PUSHOVER_TOKEN="$(dot secrets var NTFY_PUSHOVER_TOKEN)"