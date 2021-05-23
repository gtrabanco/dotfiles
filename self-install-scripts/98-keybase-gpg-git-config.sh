#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${DOTLY_PATH:-}" ]] || ! output::empty_line >/dev/null 2>&1; then
  red='\033[0;31m'
  green='\033[0;32m'
  bold_blue='\033[1m\033[34m'
  normal='\033[0m'
  output::write() {
    local -r text="${1:-}"
    echo -e "$text"
  }
  output::answer() { output::write " > $1"; }
  output::error() { output::answer "${red}$1${normal}"; }
  output::solution() { output::answer "${green}$1${normal}"; }
  output::question() {
    stty sane >/dev/null 2>&1
    if [ platform::is_macos ]; then
      echo -n " > 🤔 $1: ";
      read -r "$2";
    else
      read -rp "🤔 $1: " "$2"
    fi
  }
  output::question_default() {
    local question default_value var_name
    question="$1"
    default_value="$2"
    var_name="$3"

    output::question "$question? [$default_value]" "$var_name"
    eval "$var_name=\"\${$var_name:-$default_value}\""
  }
  output::yesno() {
    local question default PROMPT_REPLY values
    question="$1"
    default="${2:-Y}"

    if [[ "$default" =~ ^[Yy] ]]; then
      values="Y/n"
    else
      values="y/N"
    fi

    output::question "$question? [$values]" "PROMPT_REPLY"
    [[ "${PROMPT_REPLY:-$default}" =~ ^[Yy] ]]
  }
  output::empty_line() { echo ''; }
  output::header() { output::empty_line; output::write "${bold_blue}---- $1 ----${normal}"; }
  platform::command_exists() {
    type "$1" >/dev/null 2>&1
  }
  open() {
    os=$(uname)
    if [[ "$os" == "Linux" ]]; then
      if [[ -n "$(which xdg-open)" ]]; then
        xdg-open "$@"
      elif [[ -n "$(gnome-open)" ]]; then
        gnome-open "$@"
      fi
    elif [[ "$os" == "Darwin" ]]; then
      /usr/bin/open "$@" 
    fi
  }
  pbcopy() {
    os=$(uname)
    if [[ "$os" == "Linux" ]]; then
      xclip -selection clipboard
    elif [[ "$os" == "Darwin" ]]; then
      /usr/bin/pbcopy
    fi
  }
fi

parse_emails() {
  if [ -t 0 ]; then
    printf "%s\n" "${@:-}" | grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}'
  else
    grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' < /dev/stdin
  fi
}

# Check if we have needed tools
if platform::command_exists keybase >/dev/null 2>&1 &&\
    platform::command_exists gpg >/dev/null 2>&1 &&\
    platform::command_exists git >/dev/null 2>&1
then
  # Ask user if want to execute the script
  if output::yesno "Do you want to configure a Keybase GPG key with GIT"; then

    output::empty_line
    output::empty_line
    output::header " Keybase GPG Key Setup"
    output::empty_line

    # Step 1
    keybase pgp export | gpg --import

    output::write "Now Keybase will show you a window asking for Keybase Password"
    output::empty_line
    output::write "After you correctly put your Keybase Password, you must set a"
    output::write "password for sign with your imported private key."
    output::empty_line

    keybase pgp export --secret | gpg --allow-secret-key --import
    # 1. Ask current Keybase Password
    # 2. Ask a new password for pgp key. This will be the password
    #    that you should use to de/encrypt using the imported pgp
    #    key.

    # Step 2
    output::empty_line
    output::write "Now we will get the SEC rsa and set the gpg key to be trusted"
    output::write "You must type:"
    output::answer "trust"
    output::answer "5"
    output::answer "y"
    output::answer "quit"
    output::empty_line
    sec="$(gpg --list-secret-keys --keyid-format LONG | grep "sec" | tr '/' ' ' | awk '{print $3}')"
    gpg --edit-key "$sec"

    # Step 3
    output::empty_line
    author_email="$(git config --global --get user.email || echo "")"
    if [[ -z "$author_email" ]]; then
      output::error "No email address configured for your GitHub"
      output::empty_line

      {
        output::yesno "Do you want to setup one of the emails of your Private Key"
        author_email="$(gpg --list-secret-keys --keyid-format LONG | parse_emails | fzf --header "Press Ctrl+C to setup a custom email")"
        output::empty_line
        [[ -n "$author_email" ]]
      } || {
        output::write "REMEMBER:"
        output::write "If you have configured the privacy of your email address"
        output::write "in GitHub. Maybe, you want to add yours @users.noreply.github.com"
        output::empty_line
        output::question "Write your desired email address" "author_email"
        output::empty_line
        [[ -z "$author_email" ]] && output::error "Email is necessary to use private keys" && exit 1
      }
    fi

    if ! gpg --list-secret-keys --keyid-format LONG | parse_emails | grep -q "$author_email"; then
      output::error "Your git config email address is not in your private key"
      output::empty_line
      {
        output::yesno "Do you want to receive instructions and add it"
        output::empty_line
        output::write "You should write and follow the steps to add ($author_email):"
        output::answer "adduid"
        output::answer "(write your full name)"
        output::answer "(write the email address: $author_email)"
        output::answer "(comment is optional, not relevant, its just for you)"
        output::answer "O (letter)"
        output::answer "quit"
        output::answer "y"
        output::empty_line
        gpg --edit-key "$sec" || output::error "Not saved"
      } || {
        output::error "You will see a fail in commits if you do not add it."
      }
    fi

    # Step 4 Git config
    output::answer "Configuring git"
    git config --global user.signingkey "$sec"
    git config --global commit.gpgsign true
    output::solution "Git configured"
    output::empty_line

    # Step 5 add it in your github setting
    output::answer "Now add your public key in you github settings"
    {
      gpg --armor --export "$sec" | "$DOTLY_PATH/bin/pbcopy" && output::solution "Public key is in your clipboard"
    } || {
      gpg --armor --export "$sec"
      output::empty_line
    }

    { 
      platform::command_exists open
      open "https://github.com/settings/gpg/new"
    } || {
      output::write "Open in browser ans paste your key:"
      output::answer "https://github.com/settings/gpg/new"
      output::empty_line
    }
  else
    output::empty_line
    output::error "Script execution aborted by the user"
    output::empty_line
  fi
else
  output::empty_line
  output::error "You need 'keybase, gnupg and git' to use this script."
  output::empty_line
fi
