# A module for generic git stuff.

describe push_all "Pushes the master branch to all remotes"
push_all() {
  for remote in $(git remote); do
    echo "Pushing to $remote"
    git push $remote master
  done
}

describe pull_all "Fetches from all remotes, and merges the master branch"
pull_all() {
  for remote in $(git remote); do
    echo "Pulling from $remote"
    git fetch $remote
    echo "Merging from $remote"
    git merge $remote/master
  done
}

describe merge_to_master "Merge the current branch into master"
merge_to_master() {
  local current_branch=$(git_branch_name)
  if [ -n "$current_branch" ]; then
    git checkout master
    git merge $current_branch
    git checkout $current_branch
  fi
}
