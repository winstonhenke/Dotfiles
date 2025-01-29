# for macos i execute this from .bash_profile. for linux this will be executed directly.

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# might have weird encoding issues if this isn't set so just verify it
if [[ $LANG != "en_US.UTF-8" ]]; then echo "WARNING: Lang not set to en_US.UTF-8"; fi

# java 17 needed for salesforce vscode extension
export JAVA_17_HOME="/opt/homebrew/opt/openjdk@17"
export JAVA_HOME="$JAVA_17_HOME"

# keep JAVA_HOME at the front of PATH so the homebrew package takes precedent
export PATH="$JAVA_HOME/bin:${PATH}:$HOME/.bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$HOME/Developer/docs/memes/scripts"

# configure shell environment for homebrew
# do this after 'export PATH' to keep other homebrew packages at the top
# this will set $HOMEBREW_PREFIX
eval "$(/opt/homebrew/bin/brew shellenv)"

# force_color_prompt=yes
export CLICOLOR=1 # Ansi colors in iTerm2
export TERM=xterm-256color
export VISUAL=vim
export EDITOR="$VISUAL"

# salesforce cli environment vars
export SF_HIDE_RELEASE_NOTES=true
export SF_HIDE_RELEASE_NOTES_FOOTER=true

# hide the following terminal warning
#   The default interactive shell is now zsh.
#   To update your account to use zsh, please run chsh -s /bin/zsh
#   For more details, please visit https://support.apple.com/kb/HT208050
export BASH_SILENCE_DEPRECATION_WARNING=1

# bash history
HISTCONTROL=ignoreboth # don't put duplicate lines or lines starting with space in the history
HISTSIZE=1000 
HISTFILESIZE=2000
shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS

# make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# aliases
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'
# [a]ll, use a [l]ong listing format, [h]uman-readable (with -l and -s, print sizes like 1K 234M 2G etc.)
alias ls='ls -alh'
alias lsalh='ls'
# sf cli
alias sfget='sf project retrieve preview --concise'
alias sfpush='sf project deploy preview --concise'

# display a list of the matching files
bind 'set show-all-if-ambiguous off' # on - words which have more than one possible completion cause the matches to be listed immediately instead of ringing the bell
bind 'set completion-ignore-case on'
# if there are multiple matches for completion, Tab should cycle through them
bind 'TAB:menu-complete'
# and shift-tab should cycle backwards
bind '"\e[Z": menu-complete-backward'

# ========================= source additional scripts =========================

# Default Python venv
# load_script "$HOME"'/.venv/Default/bin/activate'

# $(brew --prefix) == $HOMEBREW_PREFIX == /opt/homebrew
if [ -n "$HOMEBREW_PREFIX" ]; then
  source $HOMEBREW_PREFIX'/etc/profile.d/bash_completion.sh' # homebrew = bash-completion@2
  source $HOMEBREW_PREFIX'/etc/bash_completion.d/git-completion.bash'
  source $HOMEBREW_PREFIX'/etc/bash_completion.d/git-prompt.sh'
  source $HOMEBREW_PREFIX'/etc/bash_completion.d/gh'
  source $HOMEBREW_PREFIX'/etc/bash_completion.d/brew'
  source $HOMEBREW_PREFIX'/etc/bash_completion.d/npm'
  source $HOMEBREW_PREFIX'/etc/bash_completion.d/yt-dlp'
  # source $HOMEBREW_PREFIX'/etc/bash_completion.d/dotnet-completion.sh'
  # source $HOMEBREW_PREFIX'/etc/bash_completion.d/az.sh' # azure (az) cli

  # PROMPT_COMMAND and PS1 configuration
  # has a dependency on git-prompt.sh
  source "${HOME}/.bash_ps1.sh"
else
  echo "to to self from .bashrc, HOMEBREW_PREFIX is not set"
fi

# SF CLI Completion
# See output from: 'sf autocomplete' for details here
source $HOME'/Library/Caches/sf/autocomplete/bash_setup'

# AWS CLI Completion
# aws_completer is installed by default with the CLI tooling.
# complete -C '/usr/local/bin/aws_completer' aws

# Angular CLI Completion.
# This was added by Angular CLI after installing it
# source <(ng completion script)

# Docker Completion
# MacOS - Installed using .dmg from docker.com
# load_script "/Applications/Docker.app/Contents/Resources/etc/docker.bash-completion"
# Docker Desktop now ships with built in k8s support for a single-node cluster. If I ever want to do local development on a multi-node cluster I'd likely need to install docker-machine
# #load_script "/Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion"
# load_script "/Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion"

# echo $BASH_VERSION