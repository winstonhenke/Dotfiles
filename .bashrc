# For MacOS I execute this from .bash_profile. For Linux this will be executed directly.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Might have weird encoding issues if this isn't set so just verify it
if [[ $LANG != "en_US.UTF-8" ]]; then echo "Warning Lang not set to en_US.UTF-8"; fi

# The contents of the PROMPT_COMMAND variable are executed as a regular Bash command just before Bash displays a prompt
prompt_command () {
	if [[ $? -eq 0 ]]; then # set an error string for the prompt, if applicable
		ERRPROMPT=""
	else
		ERRPROMPT='Exit Status->($?)'
	fi
	if type -t __git_ps1 > /dev/null 2>&1; then # if we're in a Git repo, show current branch
		BRANCH="$(__git_ps1 '[ %s ]')"
	else
		echo "Warning from .bashrc - Bash function __git_ps1 not found. This is usually installed with Git along side the bash-git-completion script"
	fi

	#Colors used in PS1
	local DEFAULT=$'\[\u001B[0;39m\]'
	local GREEN=$'\[\u001B[0;32m\]'
	local CYAN=$'\[\u001B[0;36m\]'
	local BCYAN=$'\[\u001B[1;36m\]'
	local BLUE=$'\[\u001B[0;34m\]'
	local GRAY=$'\[\u001B[0;37m\]'
	local DKGRAY=$'\[\u001B[1;30m\]'
	local WHITE=$'\[\u001B[1;37m\]'
	local MAGENTA=$'\[\u001B[35m\]'
	local RED=$'\[\u001B[0;31m\]'
	local BYELLOW=$'\[\u001B[33;1m\]'

	#Unicode symbols used in PS1
	local HOME=$'\u2302'		# Home

	PS1="${MAGENTA}\n\@-"			# The current time in 12-hour am/pm format
	PS1+="${DEFAULT}${BRANCH}-"		# Show Git stuff. Not sure why I'm not getting the colors. See GIT_PS1_SHOWCOLORHINTS below.
	PS1+="${DEFAULT}-"
	PS1+="${CYAN}HBC"
	PS1+="${DEFAULT}@"
	PS1+="${GREEN}\h:"				# The hostname up to the first `.' followed by colon
	PS1+="${BYELLOW}\w"				# The current working directory, with $HOME abbreviated with a tilde
	PS1+="${DEFAULT}\n$"			# Newline

	export PS1
}

PROMPT_COMMAND=prompt_command


#Set PATH var
export PATH="/usr/local/bin:${PATH}:$HOME/Bin"

#Ansi colors in iTerm2
export CLICOLOR=1

export TERM=xterm-256color

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#Aliases
alias dot='/usr/bin/git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'

##########################################################################################
###
### Bash Completion
###
### For MacOS this assumes you have installed everything in your Brewfile already.
### Having issues? Make sure iTerm is running the correct version of Bash (echo $BASH_VERSION)
### There is a dependency between bash_completion.sh and the version of Bash running and 
### HomeBrew does not automatically set the users default shell after installation.
###
##########################################################################################

load_script () {
	# Just a helper function for loading some of these bash completion scripts
	# Some installs symlink their bash completion sripts. So validate the symlink and actual path

	script_path=$1
	script_real_path=$(realpath $script_path)

	if [[ -r $script_path && -r $(realpath $script_real_path) ]]; then
		# Could just use script_real_path here too I guess but most docs just use the symlink
		source $script_path
	else
		printf "Issue loading script into .bashrc\n\tscript_path: $script_path\n\tscript_real_path: $script_real_path\n\tVerify the paths are valid and that the current user had read permission on the file"
	fi
}

# Bash tab completion
# shopt == SHell OPTions - builtin command to enable/disable/view options for the current bash shell
# I'm not really sure why I'm checking if Bash is in posix mode...It's something I copy and pasted a long time ago
if ! shopt -oq posix; then
	load_script `brew --prefix`"/etc/profile.d/bash_completion.sh" # MacOS - Bash & Bash-Completion installed with HomeBrew
	#load_script "/usr/share/bash-completion/bash_completion" # Arch
	#load_script "/etc/bash_completion" # Ubuntu
fi

# Docker Bash Completion - MacOS - Installed using .dmg from docker.com
load_script "/Applications/Docker.app/Contents/Resources/etc/docker.bash-completion"
load_script "/Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion"
load_script "/Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion"
# Dotnet Bash Completion
load_script "$HOME"'/.bash_completion.d/dotnet-completion.bash'
# Git Bash Completion
load_script `brew --prefix`"/etc/bash_completion.d/git-completion.bash"
load_script `brew --prefix`"/etc/bash_completion.d/git-prompt.sh"
#Configuration for git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE='y'		# unstaged (*) and staged (+) changes will be shown next to the branch name
GIT_PS1_SHOWSTASHSTATE='y'		# If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWUNTRACKEDFILES='y'	# If there're untracked files, then a '%' will be shown next to the branch name.
GIT_PS1_SHOWUPSTREAM='auto'		# See the difference between HEAD and its upstream
GIT_PS1_STATESEPARATOR='~'		# The separator between the branch name and the above state symbols
GIT_PS1_SHOWCOLORHINTS='y'		# colored hint about the current dirty state.The colors are based on the·colored·output·of·"git·status·-sb"

# Brew Bash Completion
load_script `brew --prefix`"/etc/bash_completion.d/brew"