#!/usr/bin/env bash
#shellcheck disable=SC1090

execute_from_url() {
  [[ -n "${1:-}" ]] && bash <(curl -fskL "${1}")
}

load_from_url() {
  [[ -n "${1:-}" ]] && . <(curl -fskL "${1}")
}

codes() {
  local just_created=false
  PROJECTS_SRC_PATH="${PROJECTS_SRC_PATH:-${HOME}/MyProjects}"
  local -r dir="${1:-}"
  local -r project_dir="${PROJECTS_SRC_PATH}/${dir}"

  mkdir -p "$PROJECTS_SRC_PATH"

  #shellcheck disable=SC1091
  . "${SLOTH_PATH:-${DOTLY_PATH:-}}/scripts/core/src/_main.sh" || return 1

  if [[ ! -d "$project_dir" ]]; then
    output::answer "The project called \`$dir\` does not exists."
    output::yesno "Do you want to create it" && just_created=true || return 0
  fi

  mkdir -p "$project_dir"
  cd "$project_dir" || return 1

  if $just_created; then
    ! git::is_in_repo -C "$project_dir" &&
      output::yesno "Do you want to init \`$dir\` as new git repository" &&
      git::git -C "$project_dir" init
  fi
}
