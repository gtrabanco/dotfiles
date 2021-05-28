alias d='dot'
alias lazy='dot'
alias l='dot'
alias sloth='dot'
# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ll="ls -l"
alias la="ls -la"
alias ~="cd ~"
alias dc="cd"
alias dotfiles='cd $DOTFILES_PATH'
#alias fixly='"$DOTLY_PATH/bin/dot" shell zsh clean_cache && "$DOTLY_PATH/bin/dot" shell zsh reload_completions'
alias fixly='"$DOTLY_PATH/bin/dot" shell zsh reload_completions'
alias fixcompinit='sudo chmod -R 755 /usr/local/share/zsh && sudo chown -R root:staff /usr/local/share/zsh' # https://stackoverflow.com/a/13785716
alias cly='cd $DOTLY_PATH'
alias cdot='cd $DOTFILES_PATH && code $DOTFILES_PATH'
alias webstorm='open -na "Webstorm.app"'
alias intellij='open -na "IntelliJ IDEA"'
alias chrome-cli='brave-cli'
alias github='source $DOTLY_PATH/scripts/dotly/tools/github.sh'
alias codes="cd ${HOME}/MyCodes"
alias cdc="codes"
alias projects="cd ${HOME}/MyCodes"

# Git
alias g="git"
alias gaa="git add -A"
alias gc="$DOTLY_PATH/bin/dot git commit"
alias gca="git add --all && git commit --amend --no-edit"
alias gco="git checkout"
alias gd="$DOTLY_PATH/bin/dot git pretty-diff"
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gb="git branch"
alias gl="$DOTLY_PATH/bin/dot git pretty-log"
alias gti="git"

# Utils
alias k='kill -9'
alias i.='(idea $PWD &>/dev/null &)'
alias c.='(code $PWD &>/dev/null &)'
alias o.='open .'
alias up='dot package update_all'
alias diff="colordiff"

# Java
alias java8='export JAVA_HOME="$JAVA_8_HOME"'
alias java11='export JAVA_HOME="$JAVA_11_HOME"'
alias java_latest='export JAVA_HOME="$JAVA_LATEST"'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
	export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
	colorflag="-G"
	export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, excluding . and ..
alias la="ls -lAF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Show hidden files
alias lh='ls -l .??*'

# Show hidden dirs
alias lhd='ls -ld .??*'

# sudo
alias please='sudo $(fc -ln -n -1)'

# SSH Stuff
alias newssh="rm -rf ${HOME}/.ssh/known_hosts && ssh ${@}" # Delete known_hosts and ssh
alias pkeycopy="cat ${HOME}/.ssh/id_rsa.pub | pbcopy"
alias dskClipboard="ssh desktop pbcopy"
alias dskclipboard="dskClipboard"
alias getpbkey="ssh-keygen -y -f" # ${HOME}/.ssh/id_rsa


# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

