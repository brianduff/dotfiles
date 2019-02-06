riker::declare_command go "Jumps to a directory"

riker::subcommand home "There's no place like it"
go::home() {
  cd $HOME
}

