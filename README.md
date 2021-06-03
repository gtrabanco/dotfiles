<div align="center">
  <h1>.dotfiles created using <a href="https://github.com/gtrabanco/dotly/tree/beta">🌚 dotly</a></h1>
  <h4>(gtrabanco fork, beta version)</h4>
</div>

## About this and any other dotfiles

Dotfiles are not meant to be cloned and used as template repository. Dotfiles content are personal configuration that probably does not fit to you. This is just and advert, see, click a start, learn and copy.

Feel free to use (issues)[issues] to ask something, report a bug, make a correction in any code or whatever you want to say, ask or teach. I will reply, be sure about it.

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

## Secrets Scripts

Those scripts are not ready for production and could end in a lost of private data that can not be recovered or easy recovered. I do not recommend at all the use of those scripts yet for files.

I recommend and are running very well for TOKEN variables without exposing the token values in your repository.

Go [Secrets scripts folder](https://github.com/gtrabanco/dotfiles/tree/master/scripts/secrets) to view more information.

