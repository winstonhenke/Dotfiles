#
#       ~/.bash_profile
#       Normally on most Linux machines .bash_profile is executed for login
#       shells while .bashrc is executed for interactive non-login shells
#       But on OS X, Terminal by default runs a login shell every time. So if
#       I want to use this config on a noraml Linux distribution again I'll probably
#       want to sym link this file to a ~/.bashrc
#

# If not running interactively, don't do anything
# I don't remember what I was using this for...
#[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '

#Set PATH var
#/opt/local/* is for MacPorts, I want these before the original PATH so they take precedence
export PATH="/opt/local/bin:/opt/local/sbin:${PATH}:$HOME/Bin"

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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
