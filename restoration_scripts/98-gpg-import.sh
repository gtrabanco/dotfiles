#!/usr/bin/env bash

#shellcheck disable=SC1091
. "${SLOTH_PATH:-${DOTLY_PATH:-}}/scripts/core/src/_main.sh"

script::depends_on gnupg keybase git

if
  [[ -f "${DOTFILES_PATH:-}/scripts/gpg/import" ]] ||
  [[ -f "${SLOTH_PATH:-${DOTLY_PATH:-}}/scripts/gpg/import" ]]
then
  output::h2 "🔑 Importing gpg key from keybase"
  "${SLOTH_PATH:-${DOTLY_PATH:-}}/bin/dot" gpg import

  output::answer "🔐 End of gpg key importing"
fi
