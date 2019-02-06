# Functions for bduff's shell environment.

# Checks the current environment, sets environment variables.
bduff::check_environment_() {
  if [[ -z "$BDUFF_OS" ]]; then
    export BDUFF_OS=$(uname -s)
  fi
  if [[ -z "$BDUFF_IN_CORP" ]]; then
    if [[ $HOSTNAME == *corp.google.com ]]; then
      export BDUFF_IN_CORP="true"
    elif [[ $HOSTNAME == brian.c.googlers.com ]]; then
      export BDUFF_IN_CORP="true"
    else
      export BDUFF_IN_CORP="false"
    fi
  fi
  if [[ -z "$BDUFF_ROAMING" ]]; then
    if [[ $HOSTNAME == *roam* ]]; then
      export BDUFF_ROAMING="true"
    else
      export BDUFF_ROAMING="false"
    fi
  fi
}

bduff::is_mac() {
  bduff::check_environment_
  test $BDUFF_OS = "Darwin"
}

bduff::is_corp() {
  bduff::check_environment_
  test $BDUFF_IN_CORP = "true"
}

bduff::is_roaming() {
  bduff::check_environment_
  test $BDUFF_ROAMING = "true"
}

bduff::is_corp_laptop() {
  bduff::check_environment_
  test $BDUFF_ROAMING = "true" -a $BDUFF_OS = "Darwin"
}

bduff::is_corp_linux() {
  bduff::check_environment_
  test $BDUFF_ROAMING = "false" -a $BDUFF_OS = "Linux" -a $BDUFF_IN_CORP = "true"
}

bduff::has_display() {
  bduff::check_environment_
  # TODO(bduff): is broken when ssh-ed into darwin.
  # ick
  if [ $BDUFF_OS = "Darwin" ]; then
    return  0
  fi
  test $DISPLAY
}

loadmodule() {
  load $1/mod_$2.sh
}

git_branch_name() {
  local RESULT=$(git symbolic-ref -q HEAD 2>/dev/null)
  echo ${RESULT##refs/heads/}
}

git_branch_name_for_prompt() {
  local BRANCH=$(git_branch_name)
  if [ x"$BRANCH" != x ]; then
    echo "[$(git_branch_name)]"
  fi
}

restart_shell() {
  cd $HOME
  exec bash --login
}
