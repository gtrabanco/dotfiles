export DOTFILES_PATH="$HOME/.dotfiles"

if [[ -d "$DOTFILES_PATH/modules/sloth" ]]; then
  export DOTLY_PATH="$DOTFILES_PATH/modules/sloth"
elif [[ -d "$DOTFILES_PATH/modules/dotly" ]]; then
  export DOTLY_PATH="$DOTFILES_PATH/modules/dotly"
fi
export SLOTH_PATH="$DOTLY_PATH"

if [[ -f "$DOTLY_PATH/shell/bash/init-dotly.sh" ]]
then
  . "$DOTLY_PATH/shell/bash/init-dotly.sh"
elif [[ -f "$DOTLY_PATH/shell/init-dotly.sh" ]]
then
  . "$DOTLY_PATH/shell/init-dotly.sh"
else
  echo "\033[0;31m\033[1mDOTLY Loader could not be found, check \$DOTFILES_PATH variable\033[0m"
fi
