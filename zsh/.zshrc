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

# Load machine specific things.
HOSTNAME=$(hostname)
HOSTNAME_RC="$HOME/.zshrc-$HOSTNAME:l"
if [ -f $HOSTNAME_RC ]; then
  source $HOSTNAME_RC
fi

export PATH=$HOME/bin:$PATH

# A prompt!
#export PROMPT="%* %{$fg[cyan]%}%c%{$fg_bold[green]%}$(__git_ps1 ' (%s)')%{$reset_color%}> "
