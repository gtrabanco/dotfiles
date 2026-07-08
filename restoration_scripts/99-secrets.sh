{
  # File to store infisical custom domain configuration and avoid to show
  # the domain in public dotfiles
  readonly infisical_domain_file="${HOME}/.infisical/INFISICAL_DOMAIN.var"
  if output::yesno "Do you want to setup infisical?"; then
    brew install infisical

    readonly INFISICAL_DOMAIN_REPLY="${INFISICAL_DOMAIN:-$(output::question "Custom domain for infiscal?")}"
    __inf_args=()

    if -n "${INFISICAL_DOMAIN_REPLY:-}"; then
      # Create custom file to store user
      mkdir -p "${HOME}/.infisical"
      rm "${infisical_domain_file}"
      echo "${INFISICAL_DOMAIN_REPLY}" > "${infisical_domain_file}"
      chmod 700 "$(dirname "${infisical_domain_file}")"
      chmod 600 "${infisical_domain_file}"
      export INFISICAL_DOMAIN="${INFISICAL_DOMAIN_REPLY}"
      __inf_args=(--domain "${INFISICAL_DOMAIN_REPLY}" __inf_args[@])
    fi
    cd "${HOME}"

    readonly INFISICAL_IDENTITY_ID="$(output::question "Machine identity id [default: empty]?")"
    readonly INFISICAL_ORGANIZATION_SLUG="$(output::question "Organization slug [default: empty]?")"

    if -n "${INFISICAL_IDENTITY_ID:-}"; then
      __inf_args=(--machine-identity-id "${INFISICAL_IDENTITY_ID}" __inf_args[@])
    fi

    if -n "${INFISICAL_ORGANIZATION_SLUG:-}"; then
      __inf_args=(--organization-slug "${INFISICAL_ORGANIZATION_SLUG}" __inf_args[@])
    fi
    

    infisical login __inf_args[@]
    if $? == 0; then
      infisical init --domain "${INFISICAL_DOMAIN}"
    else
      echo "Error while login"
    fi
  fi
}