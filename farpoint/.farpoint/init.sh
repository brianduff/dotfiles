#!/bin/bash

farpoint_dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

farpoint::require() {
  if [ -f $farpoint_dir/$1 ]; then
    source $farpoint_dir/$1
  fi
}

farpoint::require farpoint.sh

# Configuration overrides:
if [ -e $HOME/.config/farpoint.conf ]; then
  . $HOME/.config/farpoint.conf
fi

