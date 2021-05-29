export DOTFILES_PATH="$HOME/.dotfiles"
export DOTLY_PATH="$DOTFILES_PATH/modules/dotly"

if [[ -f "$DOTLY_PATH/shell/bash/init-dotly.sh" ]]
then
  . "$DOTLY_PATH/shell/bash/init-dotly.sh"
elif [[ -f "$DOTLY_PATH/shell/init-dotly.sh" ]]
then
  . "$DOTLY_PATH/shell/init-dotly.sh"
else
  echo "\033[0;31m\033[1mDOTLY Loader could not be found, check \$DOTFILES_PATH variable\033[0m"
fi
