#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# MacOS specific bits
if [ "$(uname)" == "Darwin" ]; then
  if ! [ -x "$(command -v brew)" ]; then
    echo "Installing brew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  if ! [ -x "$(command -v stow)" ]; then
    echo "Installing stow..."
    brew install stow
  fi

  if ! [ -x "$(command -v code)" ]; then
    echo "Installing VSCode..."
    brew install visual-studio-code
  fi

  if ! [ -x "$(brew list font-fira-code 2>&1 > /dev/null)" ]; then
    echo "Installing fira code font..."
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
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

  # Get FiraCode fonts.
  if ! [ -f "$HOME/Library/Fonts/FiraCode-Regular.ttf" ]; then
    echo "Installing FiraCode font..."
    pushd $(mktemp -d)
    echo "   Downloading..."
    wget -q https://github.com/tonsky/FiraCode/releases/download/5.2/Fira_Code_v5.2.zip
    unzip -q Fira_Code_v5.2.zip
    mkdir -p $HOME/Library/Fonts/
    cp ttf/* $HOME/Library/Fonts
    popd
    echo "   Updating font cache..."
    fc-cache -f -v
  fi

fi

if [ -f "$HOME/.bash_profile" -a ! -f "$HOME/.bash_profile_local" ]; then
  mv $HOME/.bash_profile $HOME/.bash_profile_local
fi

echo "Installing vscode extensions"
cat vscode/extensions.txt | xargs -L 1 code --install-extension

if ! [ -x "$(command -v cargo)" ]; then
  echo "Installing Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

echo "Linking home dir config files"
pushd $DIR > /dev/null
stow --target=$HOME zsh
popd > /dev/null

echo "Setup is done!"
