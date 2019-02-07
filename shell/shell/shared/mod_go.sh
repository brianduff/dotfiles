riker::declare_command go "Jumps to a directory"

riker::subcommand home "There's no place like it"
go::home() {
  cd $HOME
}

riker::subcommand google3 "Go to the nearest google3 dir"
go::google3() {
  if [ -d "google3" ]; then
    cd google3
  else
    g3
  fi
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
      echo "Don't know which google3 dir to go to."
    fi
  fi
}