# Blaze completions.

if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

complete -F _blaze::complete_build_target_wrapper -o nospace b
complete -F _blaze::complete_build_target_wrapper -o nospace build
complete -F _blaze::complete_test_target_wrapper -o nospace btest
complete -F _blaze::complete_target_wrapper -o nospace gb

alias gb="blaze --config gmscore_arm7"
