# Dotfiles

What it does

- Stores dotfiles in a Git bare repository
- Uses an alias so that Git commands run against the repo but files are tracked from \$HOME
- Eliminates the need for symbolic links like I was using before

Referenced these two guides

- [What do you use to manage dotfiles?](https://news.ycombinator.com/item?id=11071754)
- [The best way to store your dotfiles: A bare Git repository](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)

---

## Usage

Once setup use the `dot` alias from your home directory

- `dot status`
- `dot add -u` (you do not want to run add all)
- `dot ls-files` - List all files being tracked
- See `alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'` in `.bashrc`

---

## HomeBrew

- [Online package browser for Homebrew](https://formulae.brew.sh/)
- Formulae: Typically command line tools
- Casks: Extension of Homebrew that allows installing MacOS native applications (example Firefox)
- Tap: By default it will only find packages in the standard Homebrew repository. To add packages from additional sources you first need to `brew tap` that repo.
- Installs to: `/usr/local/Cellar/` (`/opt/homebrew/Cellar` on Apple Silicon)
  - With symbolic links added to `/usr/local/bin/`

Commands: <https://docs.brew.sh/>

- `brew help`
- `brew deps --tree --installed`
- `brew update` - Update all package definitions (formulae) and Homebrew itself
- `brew outdated`- List which of your installed packages (kegs) are outdated
- `brew upgrade` - Upgrade everything
  - `brew upgrade <formula>` - Upgrade a specific formula
- `brew list` - List all installed formulae or casks
  - `brew list --full-name --verbose`
  - `brew list --versions --verbose`
- `brew doctor` - Check your system for potential problems
- `brew cleanup`
- `brew info python`
- `brew search java`
- `brew bundle dump --force --file ~/.brew/Brewfile` - Write all installed casks/formulae/images/taps into a Brewfile

---

## Git

- `git config --list --show-origin`

---

## NPM Notes

- `npm ls` - List installed packages
- `npm outdated` - Check for outdated packages
- `npm update` - Update a package
- `npm install -g @angular/cli`

Globally installed NPM packages: `npm list -g --depth 0`

```bash
/usr/local/lib
├── @angular/cli@15.1.4
└── npm@9.4.2
```

---

## Setup

### Original Creation

Created a `dot` alias in `$HOME/.bashrc`

```bash
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'
```

Created and configured a bare repository in `$HOME/.dotgit`

```bash
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

### Usage on New System

Create a dot alias in `$HOME/.bashrc`

```bash
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'

# Not sure why this isn't working
alias dotdiff="GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.dotgit/ && code Dotfiles.code-workspace"
# Or
alias dottest="GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.dotgit/"
code Dotfiles.code-workspace

```

Clone the repo, putting the working directory into a temp folder. The temp folder is needed to prevent some conflicts with existing/default dot files

```bash
git clone --separate-git-dir=$HOME/.dotgit https://github.com/winstonhenke/Dotfiles.git $HOME/dotgit-tmp
```

Hide un-tracked files

```bash
dot config --local status.showUntrackedFiles no
```

Copy all dotfiles from `$HOME/dotgit-tmp` into `$HOME`

```bash
cp $HOME/dotgit-tmp/.bash_profile $HOME
cp $HOME/dotgit-tmp/.bashrc $HOME
cp $HOME/dotgit-tmp/.vimrc $HOME
etc..
```

Remove the temp folder

```bash
rm -r $HOME/dotgit-tmp
```

Remove .git **file**. Not actually sure how or why this file is created but I'm assuming it has to do with being a bare repo. If you don't remove this file Git thinks you have a million un-tracked files no matter where you are under `$HOME/`. Also why the alias above is needed.

```bash
rm $HOME/.git
```

That's it. Use the alias for entering git commands. All files tracked this way are versioned right from `$HOME`, no messing around creating symlinks.

### Notes

After installing Bash with Brew make sure to update `/etc/shells` and set your default shell.

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

---

## Restore Python Virtual Environments

Current Python3 version: `3.9.2`

- `python3 -m venv ~/.venv/default`
- `source ~/.venv/default/bin/activate`
- `pip install -r ~/.venv/default.requirements.txt`

`~/.bashrc` is also configured to activate the `default` venv

---
