#!/bin/bash

# Before installing, need to first install brew, then brew install stow, if linux.
# TODO(bduff): do this here if stow not available?

stow bash blaze farpoint git hg javabin shell
echo "Installed homedir bits"

if [ -d "$HOME/Library/Application Support/Code/User" ]; then
  mv -f $HOME/Library/Application\ Support/Code/User/settings.json $HOME/Library/Application\ Support/Code/User/settings.json.bak
  ln -s $HOME/dotfiles/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
  echo "Installed vscode settings"
fi
