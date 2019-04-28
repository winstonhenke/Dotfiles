#
#       ~/.bash_profile
#       Normally on most Linux machines .bash_profile is executed for login
#       shells while .bashrc is executed for interactive non-login shells
#       But on OS X by default it runs a login shell every time. So to keep my
#       .bash configs straight accross Mac/Linux I keep it all in .bashrc and
#       just reference it from here.
#

# Check that we are running interactively and .bashrc exists
if [[ $- == *i* && -r "$HOME/.bashrc" ]]; then
   source "$HOME/.bashrc"
else
  echo "Either the shell is not running interactively, .bashrc doesn't exist, or the current user does not have read permissions on the file. Attempted to execute from ~/.bash_profile."
fi
