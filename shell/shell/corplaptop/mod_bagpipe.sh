# Bagpipe setup

. $HOME/.bagpipe/setup.sh $HOME/.bagpipe brian.c.googlers.com "corp-ssh-helper -relay=sup-ssh-relay.corp.google.com --stderrthreshold=INFO %h %p"
export PATH=$HOME/bin:$PATH
source /Library/GoogleCorpSupport/srcfs/shell_completion/enable_completion.sh
