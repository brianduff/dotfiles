# A riker module for gms.
#
# Author: bduff@google.com

farpoint::require riker.sh

export GMS_JOBS=50
export GMS_ONEUP=vendor/unbundled_google/packages/OneUp
export GMS_DEFAULT_TAPAS="GmsCore GmsCoreTests"

export POTENTIAL_TAPAS_COMPLETIONS="GmsCore GmsCore-internal GmsCoreTests CopresenceDemo"

riker::declare_command gms "Helps with coding for gmscore"

riker::subcommand go "Goes to a branch directory"
gms::go() {
  local branch=$1
  if [ -z "$branch" ]; then
    branch=$(readlink $(gmsimpl::gms_dir)/main)
  fi
  if [ -z "$branch" ]; then
    >&2 echo "No branch specified"
    return 1
  fi
  cd $(gmsimpl::gms_dir)/$branch
}

# Command line completion for the go subcommand.
gmsimpl::go_complete_options() {
  gmsimpl::branch_completions
}

gmsimpl::branch_completions() {
  local branch_dirs=$(gmsimpl::gms_dir)/*
  local branches=""
  for branch_dir in $branch_dirs; do
    local name=$(basename $branch_dir)
    branches="$branches $name"
  done
  COMPREPLY=($(compgen -W "${branches}" -- ${1}))
  return 0
}

riker::subcommand gosetmain "Sets the main branch to use for go"
gms::gosetmain() {
  local branch=$1
  if [ -z "$branch" ]; then
    echo "Must specify a branch"
    return 1
  fi
  pushd $(gmsimpl::gms_dir) > /dev/null
  ln -s $1 main
  popd > /dev/null
  echo "Now, gms go with no further arguments will take you to $(gmsimpl::gms_dir)/$1"
}

gmsimpl::gosetmain_complete_options() {
  gmsimpl::branch_completions
}

riker::subcommand git "Runs a git command in the OneUp directory"
gms::git() {
  gmsimpl::push $GMS_ONEUP || return 1
  git $@
  gmsimpl::pop
}

riker::subcommand repo "Runs a repo command in the OneUp directory"
gms::repo() {
  gmsimpl::push $GMS_ONEUP || return 1
  repo $@
  gmsimpl::pop
}

riker::subcommand clean "Delete the out directory in the background (quickly)"
gms::clean() {
  local branch_dir=$(gmsimpl::find_branch_dir)
  if [ -z "$branch_dir" ]; then
    return 1
  fi
  if [ -d "$branch_dir/out" ]; then
    local delete_dir=$branch_dir/deleting-$(date +"%s")
    mv $branch_dir/out $delete_dir
    (rm -rf $delete_dir &)
  fi
}

riker::subcommand tapas "Run tapas in the branch dir"
gms::tapas() {
  declare -a args
  args=$@
  if [ -z "$args" ]; then
    args=$GMS_DEFAULT_TAPAS
  fi
  gmsimpl::push || return 1
  . build/envsetup.sh
  tapas $@
  gmsimpl::pop
}

gmsimpl::tapas_complete_options() {
  COMPREPLY=($(compgen -W "${POTENTIAL_TAPAS_COMPLETIONS}" -- ${1}))
  return 0
}

riker::subcommand sync "Sync & rebase $GMS_ONEUP"
gms::sync() {
  gmsimpl::push || return 1
  if [ "$1" = "--head" ]; then
    echo "Syncing to head"
    repo sync -j$GMS_JOBS
  else
    echo "Syncing to latest green build"
    repo smartsync -j$GMS_JOBS
  fi
  repo rebase $GMS_ONEUP
  gmsimpl::pop
}

riker::subcommand build "Build specified tapas or gradle targets"
gms::build() {
  gmsimpl::push || return 1
  . build/envsetup.sh
  # Did we forget to run tapas? If so, run it with some default arguments.
  if [ -z "$TARGET_BUILD_APPS" ]; then
    gms::tapas $GMS_DEFAULT_TAPAS
  fi
  if [ -z "$@" ]; then
    echo "Building $TARGET_BUILD_APPS"
  else
    echo "Building $@"
  fi
  (./gradlew $GMS_BUILD_FLAGS $@)
  gmsimpl::pop
}

riker::subcommand start "Starts a named branch"
gms::start() {
  gmsimpl::push $GMS_ONEUP || return 1
  gms::repo start $1 .
  gmsimpl::pop
}

riker::subcommand edit "Opens a file located using find in the EDITOR"
gms::edit() {
  if file=$(gms::find $1); then
    ${EDITOR/-w/} $file
  fi
}

riker::subcommand log "Display the log of a file"
gms::log() {
  if [ -f $1 ]; then
    git log $1
  else
    if file=$(gms::find $1); then
      gms::git log $file
    fi
  fi
}

riker::subcommand install "adb install the apk. If --remote, then use the adb tunnel"
gms::install() {
  local branch_dir=$(gmsimpl::find_branch_dir)
  if [ -z "$branch_dir" ]; then
    return 1
  fi
  local adb_command=adb
  if riker::has_flag "remote" $@ ; then
    adb_command=adbh
  fi
  # TODO(bduff) internal vs. normal.
  $adb_command install -r -d out/dist/GmsCore-internal.apk
}

riker::subcommand project "cd to $GMS_ONEUP"
gms::project() {
  # If a "main" branch is set, then go to it first.
  if [ -e "$(gmsimpl::gms_dir)/main" ]; then
    gms::go
  fi
  local branch_dir=$(gmsimpl::find_branch_dir)
  if [ -z "$branch_dir" ]; then
    echo "Not in a branch dir, and no main branch set"
    return 1
  fi
  cd $branch_dir/$GMS_ONEUP
}

riker::subcommand find "Finds a file"
gms::find() {
  local branch_dir=$(gmsimpl::find_branch_dir)
  if [ -z "$branch_dir" ]; then
    return 1
  fi
  echo $(finder::find_file $1 $branch_dir/$GMS_ONEUP)
}

riker::subcommand "upload" "Uploads the current branch"
gms::upload() {
  gms::repo upload -t --verify --cbr $@ .
}

riker::subcommand "change" "Creates a commit"
gms::change() {
  gms::git add .
  gms::git commit
}

riker::subcommand "mail" "Uploads a change from the current branch and mails it"
gms::mail() {
  reviewers="${1//,/@google.com,}@google.com"
  gms::upload "--re=$reviewers"
}

riker::subcommand "snapshot" "Commits working changes as an amend, uploads a new patch set"
gms::snapshot() {
  gms::git add .
  gms::git commit --amend
  gms::upload
}

riker::subcommand init "Initializes a gmscore client for the given cheese"
gms::init() {
  local cheese_dir="$(gmsimpl::gms_dir)/${1}"
  if [ -d "$cheese_dir" ]; then
    >&2 echo "Gms Cheese dir $cheese_dir already exists. Go there with gms go $1"
    return 1
  fi
  mkdir -p "${cheese_dir}"
  cd "${cheese_dir}"
  repo init -u persistent-https://googleplex-android.git.corp.google.com/a/platform/manifest -b ub-gcore-$1
}

riker::subcommand subl "Opens SublimeText"
gms::subl() {
  local branch_dir=$(gmsimpl::find_branch_dir)
  if [ -z $branch_dir ]; then
    return 1
  fi
  local cheese=$(basename $branch_dir)
  local template=$(gmsimpl::code_dir)/sublime/${1}-TEMPLATE.sublime-project
  local project=$(gmsimpl::code_dir)/sublime/${1}-${cheese}.sublime-project
  if [ ! -f $project -o $template -nt $project ]; then
    rm -f $project
    sed s/CHEESE/${cheese}/g <$template > $project
  fi
  subl $project
}

riker::subcommand presubmit "Runs tools/common/presubmit.sh from the OneUp directory"
gms::presubmit() {
  gmsimpl::push $GMS_ONEUP || return 1
  ./tools/common/presubmit.sh
  gmsimpl::pop
}

# Command line completion for the subl subcommand.
gmsimpl::subl_complete_options() {
  local projects=$(gmsimpl::code_dir)/sublime/*-TEMPLATE.sublime-project
  local projectnames=""
  for project in $projects; do
    local name=$(basename $project)
    name=${name%-TEMPLATE.sublime-project}
    projectnames="$projectnames $name"
  done
  COMPREPLY=($(compgen -W "${projectnames}" -- ${1}))
  return 0
}

# Whichever directory I'm currently in, return the branch directory.
gmsimpl::find_branch_dir() {
  local current_dir=${PWD}
  local parent_dir=${PWD%/*}

  while [ x$parent_dir != x$(gmsimpl::gms_dir) -a x$current_dir != "x" ]; do
    current_dir=$parent_dir
    parent_dir=${current_dir%/*}
  done

  if [ x$parent_dir == "x" ]; then
    return 1
  fi

  echo $current_dir
}

gmsimpl::push() {
  local branch_dir=$(gmsimpl::find_branch_dir)
  if [ -n "$branch_dir" ]; then
    pushd $branch_dir/$1 > /dev/null
    return 0
  fi
  return 1
}

gmsimpl::pop() {
  popd > /dev/null
}

# Returns the code dir. If the current directory is under /Volumes/code, returns
# that instead (bduff specific hack)
gmsimpl::code_dir() {
  if [[ $PWD == /Volumes/code* ]]; then
    echo "/Volumes/code"
  else
    echo "$CODE_DIR"
  fi
}

gmsimpl::gms_dir() {
  if [ -d "$GMS_DIR" ]; then
    echo "${GMS_DIR%/}"  # remove trailing slash
  else
    echo "$(gmsimpl::code_dir)/gms"
  fi
}
