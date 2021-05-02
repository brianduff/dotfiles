#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# MacOS specific bits
if [ "$(uname)" == "Darwin" ]; then
  if ! [ -x "$(command -v brew)" ]; then
    echo "Installing brew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  if ! [ -x "$(command -v stow)" ]; then
    echo "Installing stow"
    brew install stow
  fi

  if [ -d "$HOME/Library/Application Support/Code/User" ]; then
    echo "Installing VSCode Settings"
    mv -f $HOME/Library/Application\ Support/Code/User/settings.json $HOME/Library/Application\ Support/Code/User/settings.json.bak
    ln -s $DIR/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
  else
    echo "Skipped installing VSCode Settings. Install VS Code and run setup.sh again"
  fi

  if [ ! -f "$HOME/Library/Application Support/iTerm2/DynamicProfiles/iterm-profiles.json" ]; then
    echo "Installing iTerm 2 Dynamic Profiles"
    mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    ln -s $DIR/config/iterm-profiles.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/iterm-profiles.json"
  fi

else
  # Assuming linux :{}
  if ! [ -x "$(command -v stow)" ]; then
    echo "Installing stow"
    sudo apt-get install stow
  fi

  # Link vscode settings to the right place.
  mkdir -p $HOME/.config/Code/User
  ln -s $DIR/vscode/settings.json $HOME/.config/Code/User/settings.json

fi

if [ -f "$HOME/.bash_profile" -a ! -f "$HOME/.bash_profile_local" ]; then
  mv $HOME/.bash_profile $HOME/.bash_profile_local
fi

echo "Linking home dir config files"
pushd $DIR > /dev/null
stow --target=$HOME bash farpoint git hg shell zsh
popd > /dev/null


echo "Setup is done!"