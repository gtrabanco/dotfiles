<div align="center">
  <h1>.dotfiles</h1>
  <a href="https://github.com/gtrabanco/sloth" alt="Sloth Github"><img src="https://raw.githubusercontent.com/gtrabanco/sloth/master/sloth.svg" alt="Sloth Logo" width="100px" height="100px"></a>
  <p>Powered by <a href="https://github.com/gtrabanco/sloth" alt="Sloth Github">.Sloth</a></p>
</div>

This dotfiles were originally created using <a href="https://github.com/codelytv/dotly" alt="Dotly repository">🌚 dotly</a>. But after some time I migrate to use <a href="https://github.com/gtrabanco/sloth" alt="Sloth Github"><img src="https://raw.githubusercontent.com/gtrabanco/sloth/master/sloth.svg" alt="Sloth Logo" width="20px" height="20px" style="fill: green"> Sloth</a> because I develop many features to dotly that were not approved after a while and, because, I could not advance more in the development when I wanted, I made my own fork that I have called it Sloth.

This dotfiles are quite close to complete example of the features that Sloth has.

## Migration from DOTLY to .SLOTH

See the information in [.Sloth project](https://github.com/gtrabanco/sloth)

## About this and any other dotfiles

Dotfiles are not meant to be cloned and used as template repository. Dotfiles content are personal configuration that probably does not fit to you. This is just and advert, see, click a start, learn and copy.

Feel free to use (issues)[issues] to ask something, report a bug, make a correction in any code or whatever you want to say, ask or teach. I will reply, be sure about it.

## About this dotfiles

This requieres a newer version than official DOTLY version which is in [my fork](https://github.com/gtrabanco/dotly).

## Restore your Dotfiles

### Short Version

1. Generate ssh key or import the old one (not recommended) and add it to your GitHub or elsewhere you stored your dotfiles (the public key) to import your dotfiles if the repository is private and to be able to modify your dotfiles.
2. Do the same with the repository you have your secrets (if you have your secrets in a repository :).
3. Use script to restore `bash <(curl -s https://raw.githubusercontent.com/gtrabanco/sloth/HEAD/restorer)`
4. Apply your secrets: `dot secrets apply` 
5. Restart your terminal
6. Import your packages `dot package import`

### Long version

1. Generate ssh key or import the old one (not recommended) and add it to your GitHub or elsewhere you stored your dotfiles (the public key) to import your dotfiles if the repository is private and to be able to modify your dotfiles.
2. Do the same with the repository you have your secrets (if you have your secrets in a repository :).
3. Clone your dotfiles repository `git clone [your repository of dotfiles] $HOME/.dotfiles`
4. Go to your dotfiles folder `cd $HOME/.dotfiles`
5. Install git submodules `git submodule update --init --recursive`
6. Install your dotfiles `DOTFILES_PATH="$HOME/.dotfiles" DOTLY_PATH="$DOTFILES_PATH/modules/sloth" SLOTH_PATH="$DOTLY_PATH" "$DOTLY_PATH/bin/dot" self install`
7. Apply your secrets: `dot secrets apply` 
8. Restart your terminal
9. Import your packages `dot package import`

### Install Paragon NTFS

After `dot package import`:

```bash
/usr/local/Caskroom/paragon-ntfs/15/FSInstaller.app
```

## Secrets Scripts

Those scripts are not ready for production and could end in a lost of private data that can not be recovered or easy recovered. I do not recommend at all the use of those scripts yet for files.

I recommend and are running very well for TOKEN variables without exposing the token values in your repository.

Go [Secrets scripts folder](https://github.com/gtrabanco/dotfiles/tree/master/scripts/secrets) to view more information.


## Other cool dotfiles
* https://github.com/holman/dotfiles
* https://github.com/webpro/awesome-dotfiles
* https://dotfiles.github.io/
* https://github.com/thedaviddias/Mac-OS-Setup-Applications
* https://github.com/kcrawford/dockutil
