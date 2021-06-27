# Uncomment for debuf with `zprof`
# zmodload zsh/zprof

if [[ -f "$SLOTH_PATH/shell/zsh/init-sloth.sh" ]]
then
  . "$SLOTH_PATH/shell/zsh/init-sloth.sh"
elif [[ -f "$SLOTH_PATH/shell/init-sloth.sh" ]]
then
  . "$SLOTH_PATH/shell/init-sloth.sh"
else
  echo "\033[0;31m\033[1mSLOTH Loader could not be found, check \$DOTFILES_PATH variable\033[0m"
fi
