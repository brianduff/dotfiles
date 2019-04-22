# Riker is a shell module that makes it easy to implement commands
# that have subcommands.
script_dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

riker_command_descriptions=$script_dir/.riker_commands
riker_command_init=$script_dir/.riker_init
riker_current_command=

# Defines a command that's managed by riker.
# Args:
#   1: the name of the command
#   2: description of the command for humans
riker::declare_command() {
  riker_current_command=$1
  rm -f ${riker_command_descriptions}_$1
  rm -f ${riker_command_init}_$1

  # Self generating code for the win!
  cat > ${riker_command_init}_$1 <<EOF
complete -F riker::complete $1

$1() {
  riker::invoke_subcommand $1 \$@
}
EOF
  source ${riker_command_init}_$1
}

# Finds all subcommands of a given command by looking for functions
# that are namespaced by that command.
# Args:
#   1: the name of the command, e.g. "gms"
# Returns:
#   a list of all commands
riker::get_subcommands() {
  # TODO(bduff): add synthetic "help" subcommand in the right order
  local declares=$(declare -F | grep "$1::")
  declares=${declares//declare/}
  declares=${declares//-f/}
  for line in $declares; do
    echo ${line#$1::}
  done
}

# Describes a subcommand for help.
# Args:
#   1: the subcommand
#   2: a short description of the command
#   3: optionally, the command name not the last declared command
riker::subcommand() {
  local command=${riker_current_command}
  if [ -n "$3" ]; then
    command=$3
  fi
  echo $1:$2 >> ${riker_command_descriptions}_${command}
}

# Describes a command
# Args:
#   1: the command
#   2: the subcommand
riker::describe_subcommand() {
  local line=$(grep $2: ${riker_command_descriptions}_$1)
  echo ${line##*:}
}

# Prints the usage help.
# Args:
#   1: the command
riker::print_usage() {
  local usage="Usage: ${1} <command> <options> ...\n\nAvailable commands:"
  for subcommand in $(riker::get_subcommands $1); do
    local tabs="\t"
    if [ ${#subcommand} -lt 6 ]; then
      tabs="\t\t"
    fi
    usage="${usage}\n  ${subcommand}${tabs}$(riker::describe_subcommand $1 $subcommand)"
  done
  riker::print_error "${usage}"
}

# Prints to stderr
# Args:
#   1: message to print
riker::print_error() {
  >&2 printf "$1\n"
}

# Invokes a subcommand.
# Args:
#   1: the command
#   2: the subcommand
#   3...: any other args
riker::invoke_subcommand() {
  if [ -z "$2" -o "$2" == "help" ]; then
    riker::print_usage $1
    return 1
  fi
  # TODO(bduff): check for subcommand, print error
  local command=$1::$2
  shift 2
  $command $@
}

# Returns success if the given args includes the specified flag.
riker::has_flag() {
  local e
  for e in "${@:2}"; do [[ "$e" == "--$1" ]] && return 0; done
  return 1
}

# A completion function
# Args:
#   1: the command
riker::complete() {
  COMPREPLY=()

  local command subcommand

  if [ $COMP_CWORD -gt -1 ]; then
    command=${COMP_WORDS[0]}
  fi

  if [ $COMP_CWORD -gt 0 ]; then
    subcommand=${COMP_WORDS[1]}
  fi

  if [ -z "$command" ]; then
    return 1
  fi

  cur="${COMP_WORDS[COMP_CWORD]}"

  subcommands="$(riker::get_subcommands $command)"

  # See if the command wants to do completion for its own options.
  local matched_subcommand
  for known_subcommand in ${subcommands}; do
    if [ "$known_subcommand" == "$subcommand" ]; then
      matched_subcommand=$known_subcommand
    fi
  done

  if [ -n "${matched_subcommand}" ]; then
    if hash "${command}impl::${subcommand}_complete_options" 2> /dev/null; then
      if ${command}impl::${subcommand}_complete_options $cur; then
        return 0
      fi
    fi
  fi

  COMPREPLY=($(compgen -W "${subcommands}" -- ${subcommand}))
  return 0
}
