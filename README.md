<h1 align="center">
  .dotfiles created using <a href="https://github.com/gtrabanco/dotly/tree/beta">🌚 dotly (gtrabanco fork, beta version)</a>
</h1>

## About this dotfiles

This requieres a newer version than official DOTLY version which is in [my fork](https://github.com/gtrabanco/dotly).

## Restore your Dotfiles

1. Generate ssh key or import the old one (not recommended) and add it to your GitHub or elsewhere you stored your dotfiles.
2. Do the same with the repository you have your secrets.
3. Clone your dotfiles repository `git clone [your repository of dotfiles] $HOME/.dotfiles`
4. Go to your dotfiles folder `cd $HOME/.dotfiles`
5. Install git submodules `git submodule update --init --recursive`
6. Install your dotfiles `DOTFILES_PATH="$HOME/.dotfiles" DOTLY_PATH="$DOTFILES_PATH/modules/dotly" "$DOTLY_PATH/bin/dot" self install`
7. Apply your secrets: `dot secrets apply` 
8. Restart your terminal
9. Import your packages `dot package import`
10. Import your settings `dot mac defaults import`

### Install Paragon NTFS

After `dot package import`:

```bash
/usr/local/Caskroom/paragon-ntfs/15/FSInstaller.app
```
