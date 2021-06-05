#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${DOTLY_PATH:-}" ]] || ! output::empty_line >/dev/null 2>&1; then
  red='\033[0;31m'
  green='\033[0;32m'
  bold_blue='\033[1m\033[34m'
  normal='\033[0m'
  output::error() { output::answer "${red}$1${normal}"; }
  output::write() {
    local -r text="${1:-}"
    echo -e "$text"
  }
  output::answer() { output::write " > $1"; }
  output::clarification() {
    with_code_parsed=$(echo "$1" | awk "{ORS=(NR+1)%2==0?\"${green}\":RS}1" RS="\`" | awk "{ORS=NR%1==0?\"${normal}\":RS}1" RS="\`"| tr -d '\n')
    output::write "$with_code_parsed";
  }
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
    question="${1:-}"
    default="${2:-Y}"

    [[ -z "${question}" ]] && return 1

    if [[ "$default" =~ ^[Yy] ]]; then
      values="Y/n"
    else
      values="y/N"
    fi

    output::question "${question:-}❓ [${values:-Y/n}]" "PROMPT_REPLY"
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

output::list() {
  local item i
  i=1
  for item in "$@"; do
    output::clarification "    $i) $item"
    i=$(( i + 1 ))
  done
}

sec::fzf() {
  printf "%s\n" "${@}" | fzf --header "Select a private key"\
    --preview 'echo "Key information\n--\n"; gpg --list-secret-keys --keyid-format LONG {}'
}

output::empty_line
output::empty_line
output::header " 🔒 Keybase GPG Key Setup 🔑"
output::empty_line

# Previous step: Check if we have needed tools
if platform::command_exists keybase >/dev/null 2>&1 &&\
    platform::command_exists gpg >/dev/null 2>&1 &&\
    platform::command_exists git >/dev/null 2>&1
then
  # Ask user if want to execute the script
  if output::yesno "Do you want to configure a Keybase GPG key with GIT"; then
    # Step 1: Check if there are any gpg key
    pgp_list="$(keybase pgp list)"
    if [[ -z "$pgp_list" ]]; then
      output::error "🔐 No private keys found."
      output::empty_line
      {
        output::yesno "Do you want to generate a new key 🔑 " &&\
          keybase gpg gen &&\
          output::solution "🔑 New key generated" &&\
          pgp_list="$(keybase pgp list)" ||\
          output::error "🚨 Key could not be generated"
      } || true
    fi

    # If we have keys we can continue
    if [[ -n "$pgp_list" ]]; then
      # Step 2: Exporting the key
      keybase pgp export | gpg --import >/dev/null 2>&1

      output::empty_line
      output::write "Now Keybase will show you a window asking for Keybase Password"
      output::empty_line
      output::write "After you correctly put your Keybase Password, you must set a"
      output::write "password for sign with your imported private key."
      output::empty_line

      keybase pgp export --secret | gpg --allow-secret-key --import > /dev/null 2>&1

      # Check how many private keys and if we have some, we will ask the user which want to select
      all_secs=($(gpg --list-secret-keys --keyid-format LONG | grep "sec" | tr '/' ' ' | sort --reverse | awk '{print $3}'))
      sec=""

      if [[ ${#all_secs[@]} -gt 1 ]]; then
        sec="$(sec::fzf "${all_secs[@]}" || echo "")"
      elif [[ ${#all_secs[@]} -eq 1 ]]; then
        sec="${all_secs[1]}"
      fi

      {
        [[ -z "$sec" ]] &&\
        output::error "No key selected or found" &&\
        output::yesno "Do you want to write it manually" &&\
        output::question "Write your key rsa" "sec"
      } || true

      # If selected or provided sec exists continue
      if gpg --list-secret-keys --keyid-format LONG "$sec" >/dev/null 2>&1 &&\
        [[ -n "${sec:-}" ]]
      then
        # 1. Ask current Keybase Password
        # 2. Ask a new password for pgp key. This will be the password
        #    that you should use to de/encrypt using the imported pgp
        #    key.

        # Step 3: Set our private key as trusted
        output::empty_line
        output::write "ℹ︎ Now we will get the SEC rsa and set our private gpg key as trusted"
        output::write "䷐ You must type:"
        output::list '`trust`' '`5`' '`y`' '`quit`'
        output::empty_line
        gpg --edit-key "$sec"

        # Step 3: Check if git email address is configured
        output::empty_line
        author_email="$(git config --global --get user.email || echo "")"
        if [[ -z "$author_email" ]]; then
          output::error "👎 No email address configured in your git configuration"
          output::empty_line

          # Setup a mail address
          {
            # Mail address from the private key
            output::yesno "Do you want to setup one of the emails of your Private Key"
            author_email="$(gpg --list-secret-keys --keyid-format LONG | parse_emails | fzf --header "Press Ctrl+C to setup a custom email")"
            output::empty_line
            [[ -n "$author_email" ]]
          } || {
            # Custom mail address (not used with private key)
            output::write "🧠 REMEMBER 🧙‍♂️"
            output::write "If you have configured the privacy of your email address"
            output::write "in GitHub. Maybe, you want to add yours @users.noreply.github.com"
            output::write "You can view your GitHub private no reply mail address here:"
            output::answer "https://github.com/settings/emails"
            output::empty_line
            output::question "Write your desired email address" "author_email"
            output::empty_line
            [[ -z "$author_email" ]] && output::error "⛔️ Email is necessary to use private keys" && exit 1
          }
        fi

        # If the mail address is not in the private key list for use to sign and encrypt
        # give the user instructions to add it. Only if the user want to add it.
        # Not added could result in a sign error in github commits.
        if ! gpg --list-secret-keys --keyid-format LONG | parse_emails | grep -q "$author_email"; then
          output::error "⚠️ Your git config email address is not in your private key"
          output::empty_line
          {
            output::yesno "💡 Do you want to receive instructions and add it 💡"
            output::empty_line
            output::write "䷐ You should follow the steps and write:"
            output::list '`adduid`' 'write your full name' "write the email address: \`$author_email\`"\
                        "comment is optional, not relevant, its just for you" '`O` (letter)' '`quit`' '`y`'
            output::empty_line
            
            returned_code_gpg=0
            gpg --edit-key "$sec" || returned_code_gpg=1
            
            # After edited the key, update in the keybase to include the new mail address to
            # avoid this configuration process in the future
            if [[ $returned_code_gpg -eq 0 ]]; then
              output::solution "✅ Key edited and saved"
              {
                output::yesno "Do you want to update your keybase key with the new address" &&\
                {
                  keybase pgp update &&\
                  output::solution "👍 Keybase key updated"
                } || output::error "👎 Keybase key could not be updated"
              } || true
            else
              output::error "👎 Not saved"
            fi
          } || {
            output::error "🕵️‍♂️ You will see a fail in commits if you do not add it."
          }
        fi

        # Step 4 Git config
        output::answer "⚙️ Configuring git"
        git config --global user.signingkey "$sec"
        git config --global commit.gpgsign true
        git config --global gpg.program "$(which gpg)"
        output::solution "Git configured"
        output::empty_line

        # Step 5 (Conditional step) Configure GPNUPG
        if [[ -d "$HOME/.gnupg" ]] &&\
           [[ -f "$HOME/.gnupg/gpg.conf" ]] &&\
           ! grep -q "no-tty" "$HOME/.gnupg/gpg.conf"
        then
          output::solution "⚙️ Configured GNUPG"
          echo "no-tty" >> "$HOME/.gnupg/gpg.conf"
        fi

        # Step 6 add it in your github setting
        output::answer "⚙️ Now add your public key in you github settings"
        {
          gpg --armor --export "$sec" | "$DOTLY_PATH/bin/pbcopy" && output::solution "Public key is in your clipboard"
        } || {
          gpg --armor --export "$sec"
          output::empty_line
        }

        { 
          platform::command_exists open &&\
          open "https://github.com/settings/gpg/new"
        } || {
          output::write "🌍 Open in browser and paste your key:"
          output::answer "https://github.com/settings/gpg/new"
          output::empty_line
          output::write "🔎 In case of errors signing commits:"
          output::answer "https://github.com/gtrabanco/keybase-gpg-github#troubleshooting-gpg-failed-to-sign-the-data"
          output::empty_line
        }
      else
        output::error "🚨 No key was selected or provided rsa for the key is wrong"
      fi
    else
      output::error "🚨 No private keys to setup"
    fi
  else
    output::empty_line
    output::error "⚠️ Script execution aborted by the user"
    output::empty_line
  fi
else
  output::empty_line
  output::error "⛔️ You need 'keybase, gnupg and git' to use this script."
  output::empty_line
fi
