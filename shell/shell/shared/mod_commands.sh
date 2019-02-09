# Support for help descriptions and categories for commands.

export COMMAND_DESCRIPTIONS_FILE=~/.command_descriptions

# On startup of the shell, clear all commands.
rm -f $COMMAND_DESCRIPTIONS_FILE

# Describes a command so that commands can list it.
describe() {
  echo $1:$2 >> $COMMAND_DESCRIPTIONS_FILE
}

describe commands "Lists all installed custom commands"
commands() {
  local tmpfile=$(mktemp)
  sort $COMMAND_DESCRIPTIONS_FILE > $tmpfile
  mv -f $tmpfile $COMMAND_DESCRIPTIONS_FILE
  printf "Hello Brian! Here are useful commands:\n\n"
  IFS=$'\n'
  for line in $(cat $COMMAND_DESCRIPTIONS_FILE); do
    local subcommand=${line%%:*}
    local description=${line##*:}
    local tabs="\t"
    if [ ${#subcommand} -lt 6 ]; then
      tabs="\t\t"
    fi
    printf "  ${subcommand}${tabs}${description}\n"
  done
}

describe fone "Finds one file"
fone() {
  finder::find_file $@
}

describe c "Open vscode in this directory"
c() {
  code .
}