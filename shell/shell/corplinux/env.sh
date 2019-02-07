# Corp linux environment variables.

# Prompt that includes prodcertstatus.
PS1="\[\033[1;34m\]\h \[\$(prodcertstatus --check_remaining_hours=1 > /dev/null 2>&1; result=\$?; if [ \$result -eq 0 ]; then tput setaf 2; elif [ \$result -eq 16 ]; then tput setaf 3; else tput setaf 1; fi)\]$(echo -n 'L ')\[\$(tput sgr0)\]\[\e[30;1m\]${debian_chroot:+($debian_chroot)}\[\e[33;1m\]\W\[\e[0m\] \[\e[44m\]"'$(git_branch_name_for_prompt)'"\[\e[0m\]\$ "

# Add NX to the path
export PATH=/usr/NX/bin:$PATH

loadmodule corplinux android_sdk
loadmodule corplinux blaze_completion
loadmodule corplinux p4diff
loadmodule corplinux oacurl
loadmodule corplinux adb
