# bduff's bash_profile.

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

if bduff::is_corp_laptop; then
  load corplaptop/env.sh
  load corplaptop/commands.sh
fi

if bduff::is_corp_linux; then
  load corplinux/env.sh
  load corplinux/commands.sh
fi

# Path to Mobile Harness platform tool.
export PATH=$path_platform_tools:$PATH
# Path to Mobile Harness ADB.
export PATH=$path_adb:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.bash.inc' ]; then . '$HOME/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.bash.inc' ]; then . '$HOME/google-cloud-sdk/completion.bash.inc'; fi
