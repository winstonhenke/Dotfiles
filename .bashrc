# For MacOS I execute this from .bash_profile. For Linux this will be executed directly.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Might have weird encoding issues if this isn't set so just verify it
if [[ $LANG != "en_US.UTF-8" ]]; then echo "Warning Lang not set to en_US.UTF-8"; fi

# The contents of the PROMPT_COMMAND variable are executed as a regular Bash command just before Bash displays a prompt
# So I set this to just call prompt_command () and then within here I assemble and export PS1.
prompt_command () {
    if [[ $? -eq 0 ]]; then # set an error string for the prompt, if applicable
        ERRPROMPT=""
    else
        ERRPROMPT='Exit Status->($?)'
    fi
    if [[ "$(type -t __git_ps1)" ]]; then # if we're in a Git repo, show current branch
        BRANCH="$(__git_ps1 '[ %s ] ')"
    else
        echo "Warning from .bashrc - Bash function __git_ps1 not found. This is usually installed with Git along side the bash-git-completion script"
    fi

if type __git_ps1 > /dev/null 2>&1 ; then PS1='\n\w $(__git_ps1)\n\!$ '; fi


    local TIME=`fmt_time` # format time for prompt string
    local LOAD=`uptime|awk '{min=NF-2;print $min}'`
    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local BCYAN="\[\033[1;36m\]"
    local BLUE="\[\033[0;34m\]"
    local GRAY="\[\033[0;37m\]"
    local DKGRAY="\[\033[1;30m\]"
    local WHITE="\[\033[1;37m\]"
    # return color to Terminal setting for text color
    local DEFAULT="\[\033[0;39m\]"
    # set the titlebar to the last 2 fields of pwd
    local TITLEBAR='\[\e]2;`pwdtail`\a'


local MAGENTA=$'\[\u001B[35m\]'
local RED=$'\[\u001B[0;31m\]'
local test=$'\u2713'            # Check Mark
local HOME=$'\u2302'            # Home
PS1="$MAGENTA\t-"               # Magenta - Time in 24-hour HH:MM:SS format
PS1+="$RED$BRANCH-"             # Show Git stuff
PS1+="$MAGENTA$HOME"             # Maybe show a home sybmol?
PS1+=$'\[\u001B[m\]-'           # Reset/normal formatting - dash
PS1+=$'\[\u001B[36m\]HBC'       # Cyan - HBC
PS1+=$'\[\u001B[m\]@'           # Reset/normal formatting - @
PS1+=$'\[\u001B[32m\]\\h:'      # Green - the hostname up to the first `.' followed by colon
PS1+=$'\[\u001B[33;1m\]\\w'     # Yellow - bold - the current working directory, with $HOME abbreviated with a tilde
PS1+=$'\[\u001B[m\]\\n$'          # Reset/normal formatting - if the effective UID is 0, a #, otherwise a $
export PS1

#export PS1="\[${TITLEBAR}\]${CYAN}[ ${BCYAN}\u${GREEN}@${BCYAN}\
#                \h${DKGRAY}(${LOAD}) ${WHITE}${TIME} ${CYAN}]${RED}$ERRPROMPT${GRAY}\
#                \w\n${GREEN}${BRANCH}${DEFAULT}$ "


}

PROMPT_COMMAND=prompt_command

fmt_time () { #format time just the way I likes it
    if [ `date +%p` = "PM" ]; then
        meridiem="pm"
    else
        meridiem="am"
    fi
    date +"%l:%M:%S$meridiem"|sed 's/ //g'
}
pwdtail () { #returns the last 2 fields of the working directory
    pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}
chkload () { #gets the current 1m avg CPU load
    local CURRLOAD=`uptime|awk '{print $8}'`
    if [ "$CURRLOAD" > "1" ]; then
        local OUTP="HIGH"
    elif [ "$CURRLOAD" < "1" ]; then
        local OUTP="NORMAL"
    else
        local OUTP="UNKNOWN"
    fi
    echo $CURRLOAD
}


# This shit confused the fuck out of me
# Unicode escape character U+001B   ==   \u001B
# ASCII escape character octal: \033 hexadecimal: \x1B
# \uHHHH is the Bash implementation for how you can backslash escape a Unicode character whose value is the hexadecimal value HHHH (one to four hex digits).
# These Unicode escape sequences only work in words of  the  form  $'string'. This is called ANSI-C Quoting - https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html
# While customizing prompt strings Bash uses \[ and \] to begin and end a sequence of non-printing characters
# See man bash for details
# So in bash to escape an ESC character you can use \033 or \u001B. Also prompt strings support using \e to represent an ASCII escape character (033)
# So...
#Unicode==character map
#ASCII==character map & encoding?
#UTF==encoding
#ANSI==This name gets misused a lot. It's not technically an actual encoding or character map.
        #ANSI encoding is a slightly generic term used to refer to the standard code page on a system, usually Windows.
        #It is more properly referred to as Windows-1252 on Western/U.S. systems.
        #This is essentially an extension of the ASCII character set in that it includes all the ASCII characters with an additional 128 character codes.
        #ANSI does define some standard escape codes https://en.wikipedia.org/wiki/ANSI_escape_code
        #Included in these escape codes are colors. These color codes are what we use to customize the PS1

#So the following are all equivalant '\[\033[32m\u\]'   '\[\e[32m\u\]'   $'\[\u001B[32m\u\]'
        #All wrapped in between \[  ...  \]
        #Inside this a ANSI color code followed by whatever text or bash escape sequence you want the color applied to. Example \u is current user
        #notice the need for the $'' when using Unicode sequences
#ANSI color example
        #ANSI escape sequences take the shape of ESC[XXXm
        #where XXX is a series of semicolon-separated parameters
        #So in the example below
                # The string being of the form $'' allows us to use Unicode escape characters
                # \[ starts the sequence of non-printing characters
                # \u001b is the Unicode ESC sequence
                # ESC[31;1;4m is a ANSI escape color code. 31 means foreground color red, 1 means bold, 4 means underline. m ends the squence
                # \] ends the sequence of non-printing characters. So now anything after it will have the formatting we just declared, which is Hello.
                # For the second squence 0 just means reset/normal so the formatting doesn't carry over into what we type in the prompt
                # The order of 31;1;4 doesn't seem to matter.
#PS1=$'\[\u001B[31;1;4m\]Hello \[\u001B[0m\]'


#Example that adds the current branch in parentheses
#PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
#PS1='TestingGit:   $(__git_ps1 " (%s)")'
GIT_PS1_SHOWDIRTYSTATE='y' # unstaged (*) and staged (+) changes will be shown next to the branch name
GIT_PS1_SHOWSTASHSTATE='y' # If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWUNTRACKEDFILES='y' # If there're untracked files, then a '%' will be shown next to the branch name.
GIT_PS1_SHOWUPSTREAM='auto' # See the difference between HEAD and its upstream
GIT_PS1_STATESEPARATOR='~' # The separator between the branch name and the above state symbols
GIT_PS1_SHOWCOLORHINTS='y' # colored hint about the current dirty state.The colors are based on

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
