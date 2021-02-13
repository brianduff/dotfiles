# bduff's bash_profile.

#CHEF.NO.SOURCE

load() {
  if [ -f $HOME/shell/$1 ]; then
    source $HOME/shell/$1
  fi
}

source $HOME/.farpoint/init.sh

load functions.sh
load finder.sh

load shared/env.sh
load shared/commands.sh

# Machine specific stuff keyed off hostname.
load $HOSTNAME/env.sh
load $HOSTNAME/commands.sh

# These are designed not to care about the hostname, so they still work
# after machine upgrades etc.

# TODO(bduff): Remove / replace these in the new world... <cough>
if bduff::is_corp_laptop; then
  load corplaptop/env.sh
  load corplaptop/commands.sh
fi

if bduff::is_corp_linux; then
  load corplinux/env.sh
  load corplinux/commands.sh
fi

# I want a unified bash history, dang it.
shopt -s histappend

export GPG_TTY=$(tty)

if [ -f $HOME/.bash_profile_local ]; then
  source $HOME/.bash_profile_local
fi

source "$HOME/.cargo/env"
