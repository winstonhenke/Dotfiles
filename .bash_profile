# =============================================================== #
# ~/.bash_profile
# Normally on most Linux machines .bash_profile is executed for login
# shells while .bashrc is executed for interactive non-login shells
# But on OS X by default it runs a login shell every time. So to keep my
# .bash configs straight accross Mac/Linux I keep it all in .bashrc and
# just reference it from here.
# 
# https://scriptingosx.com/2017/04/about-bash_profile-and-bashrc-on-macos
# The usual convention is that .bash_profile will be executed at login shells, i.e. interactive shells where you login with your user name and password at the beginning.
# When you ssh into a remote host, it will ask you for user name and password (or some other authentication) to log in, so it is a login shell.
# When you open a terminal application, it does not ask for login. You will just get a command prompt. In other versions of Unix or Linux, this will not run the .bash_profile but a different file .bashrc
# The underlying idea is that the .bash_profile should be run only once when you login, and the .bashrc for every new interactive shell.
# However, Terminal.app on macOS, does not follow this convention. When Terminal.app opens a new window, it will run .bash_profile. Not, as users familiar with other Unix systems would expect, .bashrc
# Other third-party terminal applications on macOS may follow the precedent set by Terminal.app or not.
#   i.e. iTerm2
# =============================================================== #

# Check that we are running interactively and .bashrc exists
if [[ $- == *i* && -r "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
else
  echo "note to self: either the shell is not running interactively, .bashrc doesn't exist, or the current user does not have read permissions on the file. attempted to execute from ~/.bash_profile."
fi
