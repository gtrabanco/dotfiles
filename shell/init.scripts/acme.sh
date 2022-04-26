#!/usr/bin/env bash

acme.sh() {
  unset -f acme.sh
  #shellcheck disable=SC1091
  . "${HOME}/.acme.sh/acme.sh.env"
  acme.sh "$@"
}
