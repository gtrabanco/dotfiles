#!/usr/bin/env bash

GIT_SECRETS_REPOSITORY_URL="https://github.com/sobolevn/git-secret.git"

git-secret::install() {
  local force=false TMP_PATH TMP_FILE
  [[ "${1:-}" == "--force" || "${1:-}" == "-f" ]] && force=true
  script::depends_on gnupg

  if platform::command_exists brew; then
    if
      $force &&
        platform::command_exists brew && brew list --formula "git-secrets" &> /dev/null
    then
      brew reinstall git-secret 2>&1
    else
      brew install git-secret 2>&1
    fi

  elif platform::command_exists apt-get && command -p sudo -v -B; then
    script::depends_on curl

    command -p sudo command -p bash -c "echo 'deb https://gitsecret.jfrog.io/artifactory/git-secret-deb git-secret main' >> /etc/apt/sources.list"
    curl --silent --fail --location 'https://gitsecret.jfrog.io/artifactory/api/gpg/key/public' | command -p sudo apt-key add -
    command -p sudo apt-get update 2>&1 || return 1

    if
      $force
    then
      command -p sudo apt-get install -f -y git-secret 2>&1
    else
      command -p sudo apt-get install -y git-secret 2>&1
    fi

  elif platform::command_exists yum && sudo -v -B; then
    script::depends_on curl
    TMP_PATH="$(mktemp -d)"
    TMP_FILE="${TMP_PATH}/git-secret-rpm.repo"
    curl --silent --fail --location --connect-timeout 15 --output "$TMP_FILE" "https://raw.githubusercontent.com/sobolevn/git-secret/master/utils/rpm/git-secret.repo"

    command -p sudo mv "$TMP_FILE" "/etc/yum.repos.d/"
    if $force; then
      command -p sudo yum install -f -y git-secret 2>&1
    else
      command -p sudo yum install -y git-secret 2>&1
    fi

  elif platform::command_exists apk; then # Alpine Linux
    script::depends_on wget sh
    sh -c "echo 'https://gitsecret.jfrog.io/artifactory/git-secret-apk/all/main'" >> /etc/apk/repositories
    wget -O /etc/apk/keys/git-secret-apk.rsa.pub 'https://gitsecret.jfrog.io/artifactory/api/security/keypair/public/repositories/git-secret-apk'
    apk add --update --no-cache --quiet git-secret 2>&1

  elif platform::command_exists yay; then # Arch Linux
    yay -S git-secret 2>&1

  else
    script::depends_on git

    TMP_PATH="$(mktemp -d)"
    git clone "$GIT_SECRETS_REPOSITORY_URL" "$TMP_PATH"

    if $force; then
      git-secret::uninstall
    fi

    cd "$TMP_PATH" || return 1
    make clean 2>&1 || true
    make build 2>&1 || return 1
    PREFIX="/usr/local" make install 2>&1
  fi

  git-secret::is_installed
}

#shellcheck disable=SC2120
git-secret::uninstall() {
  local force=false TMP_PATH TMP_FILE
  [[ "${1:-}" == "--force" || "${1:-}" == "-f" ]] && force=true
  if platform::command_exists brew; then
    if
      $force
    then
      brew uninstall --force --ignore-dependencies git-secret 2>&1
    else
      brew uninstall --ignore-dependencies git-secret 2>&1
    fi

  elif platform::command_exists apt-get && command -p sudo -v -B; then
    if
      $force
    then
      command -p sudo apt-get purge -y -f git-secret 2>&1
    else
      command -p sudo apt-get purge -y git-secret 2>&1
    fi

  elif platform::command_exists yum && sudo -v -B; then
    command -p sudo yum remove -y git-secret 2>&1

  elif platform::command_exists apk; then
    apk del --quiet git-secret

  elif platform::command_exists yay; then
    yay -Rns git-secret 2>&1

  else
    script::depends_on git

    TMP_PATH="$(mktemp -d)"
    git clone "$GIT_SECRETS_REPOSITORY_URL" "$TMP_PATH"

    cd "$TMP_PATH" || return 1
    PREFIX="/usr/local" make uninstall 2>&1
  fi
}

git-secret::is_installed() {
  platform::command_exists git-secret || [[ -x "/usr/local/bin/git-secret" ]]
}
