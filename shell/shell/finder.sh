# Utilities for finding things
# Author: bduff@google.com

# Tries to find a single file given wooly specifications.
# Args:
#   1: the search term. Might be a single filename or a wildcard thang.
#   2: the directory in which to look. Defaults to pwd if not given.
finder::find_file() {
  local directory=$2
  if [ -z "$directory" ]; then
    directory=$PWD
  fi
  # First try with a name.
  local files=$(find $directory -name "$1")
  if [ -z "$files" ]; then
    # then try harder with a path.
    files=$(find $directory -path "$1")
  fi
  if [ -z "$files" ]; then
    # now try even harder by sticking some wildcards on the path
    files=$(find $directory -path "*$1")
  fi
  if [ -z "$files" ]; then
    >&2 echo "Not found."
    return 1
  fi
  # hackery, must be a better way.
  local count=0
  for match in $files; do
    (( count++ ))
  done
  if [ $count -eq 1 ]; then
    echo $files
    return 0
  else
    >&2 echo "Multiple matches:"
    for file in $files; do
      >&2 echo " $file"
    done
    return 1
  fi
}
