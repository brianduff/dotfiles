# Commands common to all systems.

# Terminal-based emacs only.
alias emacs='emacs -nw'
alias e='emacs -nw'

# Use color for ls when possible.
if bduff::is_mac; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi

# Common typos
alias dc='cd'

alias e='emacs'

loadmodule shared commands

describe title "Changes the terminal title"
title() {
  printf "\033]0;%s\007" "$1"
}

# Set up the default title
title "$USER@$(hostname)"

loadmodule shared go

loadmodule shared config
loadmodule shared adb
loadmodule shared gcloud
loadmodule shared android
