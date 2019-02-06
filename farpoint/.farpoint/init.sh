#!/bin/bash

farpoint_dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

farpoint::require() {
  if [ -f $farpoint_dir/$1 ]; then
    source $farpoint_dir/$1
  fi
}

farpoint::require gms.sh
farpoint::require farpoint.sh

# Configuration defaults:
export GMS_BUILD_FLAGS="--daemon --parallel"

# Configuration overrides:
if [ -e $HOME/.config/farpoint.conf ]; then
  . $HOME/.config/farpoint.conf
fi

