riker::declare_command g "Jumps to a directory"

riker::subcommand home "There's no place like it"
g::home() {
  cd $HOME
}

riker::subcommand fig "Go to the fig directory"
g::fig() {
  g4d dev_fig
}

riker::subcommand dotfiles "Go to the dotfiles dir"
g::dotfiles() {
  cd $HOME/dotfiles
}
