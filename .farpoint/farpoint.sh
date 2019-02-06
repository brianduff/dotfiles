# Small riker module for farpoint functions.

farpoint::require riker.sh

riker::declare_command farpoint "Administration commands for farpoint"

FARPOINT_SRC=/google/src/head/depot/google3/experimental/users/bduff/farpoint

riker::subcommand update "Updates farpoint from piper"
farpoint::update() {
  srcdir=$FARPOINT_SRC
  if [ -n "$1" ]; then
    srcdir=$1
  fi
  if [ -d "$srcdir" ]; then
    rm -f $HOME/.farpoint/*.sh
    cp $srcdir/*.sh $HOME/.farpoint/
    echo "Successfully updated farpoint from $srcdir"
    farpointimpl::restart_shell
  else
    echo "Unable to find farpoint at $srcdir. Not updating."
  fi
}

farpointimpl::restart_shell() {
  cd $HOME
  exec bash --login
}
