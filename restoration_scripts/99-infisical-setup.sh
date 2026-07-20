#!/usr/bin/env bash

readonly infisical_domain_file="${HOME}/.infisical/INFISICAL_DOMAIN.var"

if ! command -v infisical &>/dev/null; then
  output::answer "Installing infisical"
  brew install infisical
fi

if infisical login status &>/dev/null; then
  output::answer "Already authenticated to Infisical"
  infisical login status
  return 0 2>/dev/null || exit 0
fi

if output::yesno "Do you want to setup Infisical?"; then
  readonly INFISICAL_DOMAIN_REPLY="${INFISICAL_DOMAIN:-$(output::question "Custom domain for Infisical?")}"
  __inf_args=()

  if [[ -n "${INFISICAL_DOMAIN_REPLY:-}" ]]; then
    mkdir -p "${HOME}/.infisical"
    rm -f "${infisical_domain_file}"
    echo "${INFISICAL_DOMAIN_REPLY}" > "${infisical_domain_file}"
    chmod 700 "$(dirname "${infisical_domain_file}")"
    chmod 600 "${infisical_domain_file}"
    export INFISICAL_DOMAIN="${INFISICAL_DOMAIN_REPLY}"
    __inf_args+=(--domain "${INFISICAL_DOMAIN_REPLY}")
  fi

  readonly INFISICAL_IDENTITY_ID="$(output::question "Machine identity id [default: empty]?")"
  readonly INFISICAL_ORGANIZATION_SLUG="$(output::question "Organization slug [default: empty]?")"

  if [[ -n "${INFISICAL_IDENTITY_ID:-}" ]]; then
    __inf_args+=(--machine-identity-id "${INFISICAL_IDENTITY_ID}")
  fi

  if [[ -n "${INFISICAL_ORGANIZATION_SLUG:-}" ]]; then
    __inf_args+=(--organization-slug "${INFISICAL_ORGANIZATION_SLUG}")
  fi

  cd "${HOME}"

  if infisical login "${__inf_args[@]}"; then
    if [[ -n "${INFISICAL_DOMAIN_REPLY:-}" ]]; then
      infisical init --domain "${INFISICAL_DOMAIN_REPLY}"
    else
      infisical init
    fi
    output::answer "Infisical setup complete"
    infisical login status
  else
    output::error "Infisical login failed"
  fi
fi
