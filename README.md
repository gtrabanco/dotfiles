<h1 align="center">
  .dotfiles created using <a href="https://github.com/gtrabanco/dotly/tree/beta">🌚 dotly (gtrabanco fork, beta version)</a>
</h1>

## Restore your Dotfiles

* Install git
* Clone your dotfiles repository `git clone [your repository of dotfiles] $HOME/.dotfiles`
* Go to your dotfiles folder `cd $HOME/.dotfiles`
* Install git submodules `git submodule update --init --recursive`
* Install your dotfiles `DOTFILES_PATH="$HOME/.dotfiles" DOTLY_PATH="$DOTFILES_PATH/modules/dotly" "$DOTLY_PATH/bin/dot" self install`
* Restart your terminal
* Import your packages `dot package import`


# To run java you need to execute manually

```bash
dot self afterinstall install_java
```

This will do all the magic

# Install Paragon NTFS

```bash
/usr/local/Caskroom/paragon-ntfs/15/FSInstaller.app
```
