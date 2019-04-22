# Where the config git repository lives.
export CONFIG_GIT=$HOME/Documents/config

riker::declare_command config "Manipulates shell configuration"

riker::subcommand install "Installs config from the git repo, restart shell"
config::install() {
  pushd $CONFIG_GIT > /dev/null
  ./install --norestart
  popd > /dev/null
  # Now that we've restored state, restart the shell.
  restart_shell
}

riker::subcommand edit "Opens the config git repository in subl"
config::edit() {
  subl $CONFIG_GIT
}

riker::subcommand config "The config git directory" g
g::config() {
  cd $CONFIG_GIT
}
