#!/usr/local/bin/bash

# Not sure the shebang is necessary since I'm just sourcing it into my .bashrc but I get weird vim highlighting
# issues around $'' without it. Probably because the $'' is only in the new version of bash? idk

__prompt_command ()
{
	if [[ $? -eq 0 ]]; then # Set an error string for the prompt
		ERRPROMPT=""
	else
		ERRPROMPT='Exit Status->($?)'
	fi

	if type -t __git_ps1 > /dev/null 2>&1; then
		#Colors·used·in·PS1
		DEFAULT=$'\[\u001B[0;39m\]'
		GREEN=$'\[\u001B[0;32m\]'
		CYAN=$'\[\u001B[0;36m\]'
		BCYAN=$'\[\u001B[1;36m\]'
		BLUE=$'\[\u001B[0;34m\]'
		GRAY=$'\[\u001B[0;37m\]'
		DKGRAY=$'\[\u001B[1;30m\]'
		WHITE=$'\[\u001B[1;37m\]'
		MAGENTA=$'\[\u001B[35m\]'
		RED=$'\[\u001B[0;31m\]'
		BYELLOW=$'\[\u001B[33;1m\]'

		#Unicode·symbols·used·in·PS1
		HOME_ICON=$'\u2302'	#·Don't name this HOME, that's a global variable

		ps1_start="${MAGENTA}\@${DEFAULT}"		# The·current·time·in·12-hour·am/pm·format
		ps1_start+="${DEFAULT}-${DEFAULT}"
		ps1_start+="${GREEN}\h${DEFAULT}"		# The·hostname·up·to·the·first '.'
		ps1_start+="${DEFAULT}-${DEFAULT}"
		ps1_start+="${CYAN}\u${DEFAULT}"

		ps1_end="${BYELLOW}\w${DEFAULT}"		# The·current·working·directory,·with·$HOME·abbreviated·with·a·tilde
		ps1_end+="\n\$"							# If you are not root, inserts a "$"; if you are root, you get a "#"  (root uid = 0)

		# __git_ps1 will set PS1 appending and prepending it with the two parameters passed in
		__git_ps1 $ps1_start $ps1_end

		#·This·gets·set·in·__git_ps1 but it still needs to be exported
		export PS1
	else
		echo "Warning from .bashrc - Bash·function __git_ps1 not found. This is usually installed with Git along side the bash-git-completion script"
	fi
}

PROMPT_COMMAND=__prompt_command
