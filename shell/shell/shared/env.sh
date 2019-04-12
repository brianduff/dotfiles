# Shared environment variables common to all systems.

export CODE_DIR=/usr/local/google/home/bduff/code
export PATH=$HOME/bin:$PATH

# Simple common prompt.
PS1="\[\033[1;34m\]\h \[\e[33;1m\]\W\[\e[0m\] \[\e[44m\]"'$(git_branch_name_for_prompt)'"\[\e[0m\]\$ "

# Use sublime text as the EDITOR if possible.
export EDITOR=e
if bduff::has_display; then
  if hash subl 2>/dev/null; then
    export EDITOR="subl -n -w"
  fi
fi

# Where tools are installed on all systems. Can be overridden per-machine.
export TOOLS_DIR=$HOME/tools

