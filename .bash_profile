#
#       ~/.bash_profile
#       Normally on most Linux machines .bash_profile is executed for login
#       shells while .bashrc is executed for interactive non-login shells
#       But on OS X, Terminal by default runs a login shell every time. So if
#       I want to use this config on a noraml Linux distribution again I'll probably
#       want to sym link this file to a ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]HBC\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

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

# Bash tab completion
# shopt == SHell OPTions - builtin command to enable/disable/view options for the current bash shell
# I'm not really sure why I'm checking if Bash is in posix mode...It's something I copy and pasted a long time ago
if ! shopt -oq posix; then
  if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then   # MacOS - Bash & Bash-Completion installed with HomeBrew
    # Having issues? Make sure iTerm is running the correct version of Bash (echo $BASH_VERSION)
    #Installing bash with HomeBrew does not set this appropriately and the bash completion scripts have dependencies on the bash version using them
    . /usr/local/etc/profile.d/bash_completion.sh
  elif [ -f /usr/share/bash-completion/bash_completion ]; then  # Arch Linux
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then                        # Ubuntu Linux
    . /etc/bash_completion
  fi
fi

# Docker Bash completion
# MacOS - I installed Docker by just downloading the .dmg from docker.com
# Currently theses bash completion scripts get installed without the execution flag so double check they have that on
docker_bash_completion_path="/Applications/Docker.app/Contents/Resources/etc"
if [ -f ${docker_bash_completion_path}/docker.bash-completion ]; then
  . ${docker_bash_completion_path}/docker.bash-completion
fi
if [ -f ${docker_bash_completion_path}/docker-compose.bash-completion ]; then
  . ${docker_bash_completion_path}/docker-compose.bash-completion
fi
if [ -f ${docker_bash_completion_path}/docker-machine.bash-completion ]; then
  . ${docker_bash_completion_path}/docker-machine.bash-completion
fi

# bash parameter completion for the dotnet CLI
_dotnet_bash_complete()
{
  local word=${COMP_WORDS[COMP_CWORD]}

  local completions
  completions="$(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}")"

  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}

complete -F _dotnet_bash_complete dotnet

