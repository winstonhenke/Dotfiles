#!/bin/bash

# Not sure the shebang is necessary since I'm just sourcing it into my .bashrc but I get weird vim highlighting
# issues around $'' without it. Probably because the $'' is only in the new version of bash? idk

# see: docs/devops/bash/PS1.md

__prompt_command ()
{
  if [[ $? -eq 0 ]]; then # Set an error string for the prompt
    ERRPROMPT=""
  else
    ERRPROMPT='Exit Status->($?)'
  fi

  if type -t __git_ps1 > /dev/null 2>&1; then
    # Determine Python Venv
    python_venv_color=$DEFAULT
    python_venv="[issues setting venv in .bash_ps1]"
    if test -z "$VIRTUAL_ENV" ; then
        python_venv_color=$PS1_MAGENTA
        python_venv="[no venv]"
    else
        python_venv_color=$PS1_BRIGHT_GREEN
        python_venv="[`basename \"$VIRTUAL_ENV\"`]"
    fi

    # __git_ps1 ()
    # (alias) /opt/homebrew/etc/bash_completion.d/git-prompt.sh
    # see script docs for differences between 0-3 arguments
    gitPS1=$(__git_ps1)
    PS1="${PS1_MAGENTA}\@ ${PS1_GREEN}\u${DEFAULT}@${PS1_CYAN}\h${DEFAULT}:${PS1_YELLOW}\w${DEFAULT}"$gitPS1"\n${python_venv_color}${python_venv}${DEFAULT}\$ "
  else
    echo "Warning from .bashrc - Bash function __git_ps1 not found. This is usually installed with Git along side the bash-git-completion script"
  fi
}

# git-prompt.sh: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE='y'              # Unstaged (*) and staged (+) changes will be shown next to the branch name
GIT_PS1_SHOWSTASHSTATE='y'              # If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWUNTRACKEDFILES='y'          # If there're untracked files, then a '%' will be shown next to the branch name.
GIT_PS1_SHOWUPSTREAM='auto verbose'     # See the difference between HEAD and its upstream and show number of commits ahead/behind (+/-) upstream.
GIT_PS1_STATESEPARATOR=':'              # The separator between the branch name and the above state symbols
GIT_PS1_SHOWCOLORHINTS='y'              # Colored hint about the current dirty state.The colors are based on the·colored·output·of·"git·status·-sb"

# foreground colors·used·in·ps1
# note: the $'...' is for ansi-c quoting. see: https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html
# u001B - means unicode
# [0;39m   |   [1;36m   |   [1;37m   |   etc
# these ^ are the unicode escape sequences
# the first numbers are the SGR (Select Graphic Rendition) parameters (bold, dim, italic, underline, etc)
# they range from 0-107. see wikipedia for all descriptions
# SGR: 0 = reset or normal   |   SGR: 1 = bold
# the second number is the the color(always followed by an 'm')
# foreground ranges from: 30-37 and 90-97. background ranges from: 40-47 and 100-107
DEFAULT="\[\e[0;39m\]"
PS1_MAGENTA="\[\e[0;35m\]"
PS1_GREEN="\[\e[0;32m\]"
PS1_CYAN="\[\e[0;36m\]"
PS1_YELLOW="\[\e[0;33m\]"
PS1_RED="\[\e[0;31m\]"
PS1_BLUE="\[\e[0;34m\]"
PS1_WHITE="\[\e[0;37m\]"
PS1_BRIGHT_GREEN="\[\e[0;92m\]"
PS1_BRIGHT_YELLOW="\[\e[0;93m\]"
PS1_BRIGHT_MAGENTA="\[\e[0;95m\]"
PS1_BRIGHT_CYAN="\[\e[0;96m\]"

# unicode symbols used in PS1
PS1_HOME_ICON=$'\u2302' #·Don't name this HOME, that's a global variable

# bash provides an environment variable called PROMPT_COMMAND
# the contents of this variable are executed as a regular bash command just before bash displays a prompt
# basically every time it renders the bash prompt it will first call __prompt_command()
PROMPT_COMMAND=__prompt_command
