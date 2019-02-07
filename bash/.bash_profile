# Multi machine bash_profile for bduff.

load() {
  if [ -f $HOME/shell/$1 ]; then
    source $HOME/shell/$1
  fi
}

#source /google/src/cloud/bduff/gms_command/google3/experimental/users/bduff/shell/init.sh
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

#export GMS_DIR=/todo/set/me
#source /usr/local/google/home/bduff/.farpoint/init.sh

#source /usr/local/google/home/bduff/.devices.config


alias buildNearby='/google/src/files/head/depot/google3/experimental/users/xlythe/scripts/Nearby.sh'
alias install='/google/src/files/head/depot/google3/experimental/users/xlythe/scripts/NearbyApp.sh'
# Path to Mobile Harness platform tool.
export PATH=$path_platform_tools:$PATH
# Path to Mobile Harness ADB.
export PATH=$path_adb:$PATH
