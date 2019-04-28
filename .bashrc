# For MacOS I execute this from .bash_profile. For Linux this will be executed directly.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]HBC\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

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
# Brew Bash Completion
load_script `brew --prefix`"/etc/bash_completion.d/brew"
