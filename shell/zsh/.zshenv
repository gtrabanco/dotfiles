export DOTFILES_PATH="$HOME/.dotfiles"
if [[ -d "$DOTFILES_PATH/modules/sloth" ]]; then
  export DOTLY_PATH="$DOTFILES_PATH/modules/sloth"
elif [[ -d "$DOTFILES_PATH/modules/dotly" ]]; then
  export DOTLY_PATH="$DOTFILES_PATH/modules/dotly"
fi
export SLOTH_PATH="$DOTLY_PATH"
export ZIM_HOME="$SLOTH_PATH/modules/zimfw"
