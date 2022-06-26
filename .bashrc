# For MacOS I execute this from .bash_profile. For Linux this will be executed directly.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Might have weird encoding issues if this isn't set so just verify it
if [[ $LANG != "en_US.UTF-8" ]]; then echo "Warning Lang not set to en_US.UTF-8"; fi

# All PROMPT_COMMAND and PS1 configuration
source "${HOME}/.bash_ps1.sh"

# Installed Java11 from HomeBrew on MacOS
export JAVA_11_HOME="/usr/local/opt/openjdk@11"
export JAVA_HOME="$JAVA_11_HOME"

#Set PATH var. Keep /usr/local/bin at the front so Brew packages take precedent
export PATH="/usr/local/bin:${PATH}:$HOME/bin:$JAVA_HOME/bin:/usr/local/bin/aws_completer:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

#Ansi colors in iTerm2
export CLICOLOR=1

export TERM=xterm-256color

export VISUAL=vim
export EDITOR="$VISUAL"

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
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'
alias ls='ls -alh'
alias lsalh='ls'

##########################################################################################
###
### Bash Completion
###
### For MacOS this assumes you have installed everything in your Brewfile already.
### Having issues? Make sure iTerm is running the correct version of Bash (echo $BASH_VERSION)
### There is a dependency between bash_completion.sh and the version of Bash running and 
### HomeBrew does not automatically set the users default shell after installation.
###
### Some Bash completion files are symlinked from here when installed via HomeBrew
### /usr/local/etc/bash_completion.d
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
		printf "[~/.bashrc] Issue loading script into .bashrc\n\tscript_path: $script_path\n\tscript_real_path: $script_real_path\n\tVerify the paths are valid and that the current user had read permission on the file"
	fi
}


# Better tab completion experience. show-all-if-ambiguous: This alters the default behavior of the completion functions. If set to ‘on’, words which have more than one possible completion cause the matches to be listed immediately instead of ringing the bell
bind 'set show-all-if-ambiguous off'
bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'

# Bash tab completion
# shopt == SHell OPTions - builtin command to enable/disable/view options for the current bash shell
# I'm not really sure why I'm checking if Bash is in posix mode...It's something I copy and pasted a long time ago
if ! shopt -oq posix; then
	load_script `brew --prefix`"/etc/profile.d/bash_completion.sh" # MacOS - Bash & Bash-Completion installed with HomeBrew
	#load_script "/usr/share/bash-completion/bash_completion" # Arch
	#load_script "/etc/bash_completion" # Ubuntu
fi

# Default Python venv
load_script "$HOME"'/.venv/default/bin/activate'
# Docker Bash Completion - MacOS - Installed using .dmg from docker.com
load_script "/Applications/Docker.app/Contents/Resources/etc/docker.bash-completion"
# Docker Desktop now ships with built in k8s support for a single-node cluster. If I ever want to do local development on a multi-node cluster I'd likely need to install docker-machine
#load_script "/Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion"
load_script "/Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion"
# Dotnet Bash Completion
load_script "$HOME"'/.bash_completion.d/dotnet-completion.bash'
# Git Bash Completion
load_script `brew --prefix`"/etc/bash_completion.d/git-completion.bash"
# Git Prompt
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
load_script `brew --prefix`"/etc/bash_completion.d/git-prompt.sh"
GIT_PS1_SHOWDIRTYSTATE='y'				# Unstaged (*) and staged (+) changes will be shown next to the branch name
GIT_PS1_SHOWSTASHSTATE='y'				# If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWUNTRACKEDFILES='y'			# If there're untracked files, then a '%' will be shown next to the branch name.
# GIT_PS1_SHOWUPSTREAM='auto verbose'		# See the difference between HEAD and its upstream and show number of commits ahead/behind (+/-) upstream.
# GIT_PS1_STATESEPARATOR=':'				# The separator between the branch name and the above state symbols
GIT_PS1_SHOWCOLORHINTS='y'				# Colored hint about the current dirty state.The colors are based on the·colored·output·of·"git·status·-sb"

# Brew Bash Completion
load_script `brew --prefix`"/etc/bash_completion.d/brew"
# Azure CLI Bash Completion - Installev via Homebrew by default with az
load_script `brew --prefix`"/etc/bash_completion.d/az"
# Amazon AWS CLI Completion. aws_completer is installed by default with the CLI tooling.
complete -C '/usr/local/bin/aws_completer' aws


# Load Angular CLI autocompletion.
# This was added by Angular CLI after installing it
source <(ng completion script)
