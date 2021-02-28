# Hello! Now we're using zsh, here are some definitions :)

# Set up vscode as the EDITOR
# TODO(bduff): Fix this for environments with no display.
if hash code 2>/dev/null; then
  export EDITOR="code -w"
fi

# Load os-specific things.
UNAME=$(uname)
OS_RC="$HOME/.zshrc-$UNAME:l"
if [ -f $OS_RC ]; then
  source $OS_RC
fi

export PATH=$HOME/bin:$PATH
