# Dotnet CLI Bash completion

# Not sure why the dotnet installer doesn't include this.
# Their docs instruct you to just put this in your .bash_profile
# So just tracking it in here instead.

_dotnet_bash_complete()
{
  local word=${COMP_WORDS[COMP_CWORD]}

  local completions
  completions="$(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}")"

  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}

complete -F _dotnet_bash_complete dotnet
