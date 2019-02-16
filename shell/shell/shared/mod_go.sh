riker::declare_command g "Jumps to a directory"

riker::subcommand home "There's no place like it"
g::home() {
  cd $HOME
}

riker::subcommand google3 "Go to the nearest google3 dir"
g::google3() {
  if [ -d "google3" ]; then
    cd google3
  else
    g3
  fi
}

riker::subcommand fig "Go to the fig directory"
g::fig() {
  g4d dev_fig
}

riker::subcommand pointy "Go to the pointy source"
g::pointy() {
  go google3
  cd experimental/users/bduff/java/com/google/pointy
}

riker::subcommand pointy "Go to the dotfiles dir"
g::dotfiles() {
  cd $HOME/dotfiles
}

#
# With no argument: go to the nearest ancestor google3 directory.
# With one argument: go to the google3 directory under the specified
#   perforce client directory (assuming clients are in $HOME/src/clientname)
#
g3() {
  oldpwd=$PWD

  if [ "" != "$1" ]; then
    if [ -d $HOME/src/$1/google3 ]; then
      cd $HOME/src/$1/google3
    else
      if [ -d /usr/local/google/$USER/src/$1/google3 ]; then
         cd /usr/local/google/$USER/src/$1/google3
      else
         echo "No google3 in $HOME/src/$1 or /usr/local/google/$USER/src/$1"
      fi
    fi
  else
    while [ "`basename $PWD`" != "google3" -a "`basename $PWD`" != "/" ]; do
      cd ..
    done
    if [ "`basename $PWD`" = "/" ]; then
      # if all else fails, go to the dev_fig directory.
      g fig
    fi
  fi
}