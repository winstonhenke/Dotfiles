#!/usr/local/bin/bash

# Not sure the shebang is necessary since I'm just sourcing it into my .bashrc but I get weird vim highlighting
# issues around $'' without it. Probably because the $'' is only in the new version of bash? idk

# See: https://github.com/winstonhenke/Docs/blob/master/Bash/Ansi_Colors.md

__prompt_command ()
{
  if [[ $? -eq 0 ]]; then # Set an error string for the prompt
    ERRPROMPT=""
  else
    ERRPROMPT='Exit Status->($?)'
  fi

  if type -t __git_ps1 > /dev/null 2>&1; then
    # Determine Python Venv
    pythonVenvColor=$'\[\u001B[0;39m\]'
    pythonVenv="[issues setting venv in .bash_ps1]"
    if test -z "$VIRTUAL_ENV" ; then
        pythonVenvColor=$'\[\u001B[0;35m\]'
        pythonVenv="[no venv]"
    else
        pythonVenvColor=$'\[\u001B[0;92m\]'
        pythonVenv="[`basename \"$VIRTUAL_ENV\"`]"
    fi

    __git_ps1 "${MAGENTA}\@ ${GREEN}\u${DEFAULT}@${CYAN}\h${DEFAULT}:${YELLOW}\w${DEFAULT}" "\n${pythonVenvColor}${pythonVenv}${DEFAULT} \$"
    export PS1
  else
    echo "Warning from .bashrc - Bash·function __git_ps1 not found. This is usually installed with Git along side the bash-git-completion script"
  fi
}

# Forground Colors·used·in·PS1
# Note: The $'...' is for ANSI-C Quoting. See: https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html
# u001B - Means Unicode
# [0;39m   |   [1;36m   |   [1;37m   |   etc
# These ^ are the unicode escape sequences
# The first numbers are the SGR (Select Graphic Rendition) parameters (bold, dim, italic, underline, etc)
# They range from 0-107. See Wikipedia for all descriptions.
# SGR: 0 = Reset or normal   |   SGR: 1 = Bold
# The second number is the the color(always followed by an 'm')
# Forground ranges from: 30-37 and 90-97. Background ranges from: 40-47 and 100-107
DEFAULT=$'\[\u001B[0;39m\]'
# Normal
RED=$'\[\u001B[0;31m\]'
GREEN=$'\[\u001B[0;32m\]'
YELLOW=$'\[\u001B[0;33m\]'
BLUE=$'\[\u001B[0;34m\]'
MAGENTA=$'\[\u001B[0;35m\]'
CYAN=$'\[\u001B[0;36m\]'
WHITE=$'\[\u001B[0;37m\]'
# Bright
BRIGHT_GREEN=$'\[\u001B[0;92m\]'
BRIGHT_YELLOW=$'\[\u001B[0;93m\]'
BRIGHT_MAGENTA=$'\[\u001B[0;95m\]'
BRIGHT_CYAN=$'\[\u001B[0;96m\]'
#Unicode·symbols·used·in·PS1
HOME_ICON=$'\u2302' #·Don't name this HOME, that's a global variable


# Bash provides an environment variable called PROMPT_COMMAND.
# The contents of this variable are executed as a regular Bash command just before Bash displays a prompt.
# Basically every time it renders the bash prompt it will first call __prompt_command()
PROMPT_COMMAND=__prompt_command
