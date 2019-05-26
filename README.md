# Dotfiles

## Overview

What it does

* Stores dotfiles in a Git bare repository
* Uses an alias so that Git commands run against the repo but files are tracked from $HOME
* Eliminates the need for symbolic links like I was using before

Referenced these two guides

* [What do you use to manage dotfiles?](https://news.ycombinator.com/item?id=11071754)
* [The best way to store your dotfiles: A bare Git repository](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)


## Setup

### Original creation

Created a dot alias in $HOME/.bashrc

```plain text
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'
```

Created and configured a bare repository in $HOME/.dotgit

```plain text
git init --bare $HOME/.dotgit
dot config --local status.showUntrackedFiles no
dot status
dot add .vimrc
dot commit -m "Add vimrc"
dot add .bashrc
dot commit -m "Add bashrc"
dot remote add origin https://github.com/winstonhenke/Dotfiles.git
dot push origin master
```

### How to use on a new system

Create a dot alias in $HOME/.bashrc

```plain text
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'
```

Clone the repo, putting the working directory into a temp folder. The temp folder is needed to prevent some conflicts with existing/default dot files

```plain text
git clone --separate-git-dir=$HOME/.dotgit https://github.com/winstonhenke/Dotfiles.git $HOME/dotgit-tmp
```

Hide untracked files

```plain text
dot config --local status.showUntrackedFiles no
```

Copy all dotfiles from $HOME/dotgit-tmp into $HOME

```plain text
cp $HOME/dotgit-tmp/.bash_profile $HOME
cp $HOME/dotgit-tmp/.bashrc $HOME
cp $HOME/dotgit-tmp/.vimrc $HOME
etc..
```

Remove the temp folder

```plain text
rm -r $HOME/dotgit-tmp
```

That's it. Use the alias for entering git commands. All files tracked this way are versioned right from $HOME, no messing around creating symlinks.

### Notes

After installing Bash with Brew make sure to update /etc/shells and set your default shell.

```bash
brew install bash
sudo vim /etc/shells

# add to last line
/usr/local/bin/bash

#Set the shell for the current user
chsh -s /usr/local/bin/bash $USER

#Might as well do it for root too
sudo chsh -s /usr/local/bin/bash root # this will set for the current user.

#Quit iTerm and reopen it
#Verify your version
echo $BASH_VERSION #bash --version will just tell you what your PATH has set, not what you are actually running
```