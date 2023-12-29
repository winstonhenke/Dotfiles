# For MacOS I execute this from .bash_profile. For Linux this will be executed directly.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Might have weird encoding issues if this isn't set so just verify it
if [[ $LANG != "en_US.UTF-8" ]]; then echo "Warning Lang not set to en_US.UTF-8"; fi

# Java 17 needed for Salesforce VS Code extension
export JAVA_17_HOME="/opt/homebrew/opt/openjdk@17"
export JAVA_HOME="$JAVA_17_HOME"

# PATH: Keep JAVA_HOME at the front so the HomeBrew package takes precedent
export PATH="$JAVA_HOME/bin:${PATH}:$HOME/.bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$HOME/Workspace/Docs/Memes/scripts"
eval "$(/opt/homebrew/bin/brew shellenv)" # Run this after the line above to keep other HomeBrew packages at the top

export CLICOLOR=1 # Ansi colors in iTerm2
export TERM=xterm-256color
export VISUAL=vim
export EDITOR="$VISUAL"

# Bash history
HISTCONTROL=ignoreboth # Don't put duplicate lines or lines starting with space in the history
HISTSIZE=1000 
HISTFILESIZE=2000
shopt -s histappend # Append to the history file, don't overwrite it
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS

# All PROMPT_COMMAND and PS1 configuration
source "${HOME}/.bash_ps1.sh"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#Aliases
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'
alias ls='ls -alh'
alias lsalh='ls'

# Display a list of the matching files
bind 'set show-all-if-ambiguous off' # on - words which have more than one possible completion cause the matches to be listed immediately instead of ringing the bell
bind 'set completion-ignore-case on'
# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB:menu-complete'
# And Shift-Tab should cycle backwards
bind '"\e[Z": menu-complete-backward'

############################# Helper function for stuff below #############################
load_script () {
  script_path=$1
  script_real_path=$(realpath $script_path)

  if [[ -r $script_path && -r $(realpath $script_real_path) ]]; then
    # Some installs symlink their bash completion sripts. So validate the symlink and actual path
    # Could just source script_real_path here too I guess but most docs just use the symlink ¯\_(ツ)_/¯
    source $script_path
  else
    printf "[~/.bashrc] Issue loading script into .bashrc\n\tscript_path: $script_path\n\tscript_real_path: $script_real_path\n\tVerify the paths are valid and that the current user had read permission on the file"
  fi
}
###########################################################################################

# Default Python venv
load_script "$HOME"'/.venv/default/bin/activate'

# Git Prompt
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
load_script `brew --prefix`"/etc/bash_completion.d/git-prompt.sh"
GIT_PS1_SHOWDIRTYSTATE='y'              # Unstaged (*) and staged (+) changes will be shown next to the branch name
GIT_PS1_SHOWSTASHSTATE='y'              # If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWUNTRACKEDFILES='y'          # If there're untracked files, then a '%' will be shown next to the branch name.
# GIT_PS1_SHOWUPSTREAM='auto verbose'   # See the difference between HEAD and its upstream and show number of commits ahead/behind (+/-) upstream.
# GIT_PS1_STATESEPARATOR=':'            # The separator between the branch name and the above state symbols
GIT_PS1_SHOWCOLORHINTS='y'              # Colored hint about the current dirty state.The colors are based on the·colored·output·of·"git·status·-sb"

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

# Bash Completion
load_script `brew --prefix`"/etc/profile.d/bash_completion.sh" # MacOS - HomeBrew:bash-completion@2

# Git Completion
load_script `brew --prefix`"/etc/bash_completion.d/git-completion.bash"

# Brew Completion
load_script `brew --prefix`"/etc/bash_completion.d/brew"

# Dotnet Completion
load_script "$HOME"'/.bash_completion.d/dotnet-completion.bash'

# NPM (Node)
load_script `brew --prefix`"/etc/bash_completion.d/npm"

# YT-DLP
load_script `brew --prefix`"/etc/bash_completion.d/yt-dlp"

# SF CLI Completion
# See output from: 'sf autocomplete' for details here
load_script "$HOME"'/Library/Caches/sf/autocomplete/bash_setup'

# Azure (az) Completion
# load_script `brew --prefix`"/etc/bash_completion.d/az"

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
