# Dotfiles

What it does

- Stores dotfiles in a Git bare repository
- Uses an alias so that Git commands run against the repo but files are tracked from `$HOME`
- Eliminates the need for symbolic links like I was using before

Referenced these guides

- [What do you use to manage dotfiles?](https://news.ycombinator.com/item?id=11071754)
- [The best way to store your dotfiles: A bare Git repository](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)
- [This guy's got some cool stuff: mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

## Usage

once setup use the `dot` alias from your home directory

- See `alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'` in `.bashrc`

```bash
dot status
# add all tracked files (you do NOT want to run add all)
dot add -u
# list all files being tracked
dot ls-files
```

## Setup

### Original Creation

created a `dot` alias in `$HOME/.bashrc`

- `alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'`

init bare repository in `$HOME/.dotgit`

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

### Setup New Rig

Pull Dotfiles

- When this is done you should NOT have a `.git` **file** in your home directory
  - Had an issue with this when I was using `git clone` to pull this stuff down (instead of initalizing a new bare repo and linking the origin as outlined above)
  - Only had one line: `gitdir: /Users/whenke/.dotgit`
  - This was why iTerm was showing the `(master)` git repo as part of PS1 when in folders that were not repos

```bash
# create the dot alias for the current terminal session (since we don't have the .bashrc being used yet)
alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'

# init, config, & fetch
git init --bare $HOME/.dotgit
dot config --local status.showUntrackedFiles no
dot remote add origin https://github.com/winstonhenke/Dotfiles.git
dot fetch origin

# sanity checks
dot remote -v
dot status
dot diff origin/master
dot config --list --show-origin
# confirm: status.showuntrackedfiles=no
dot branch -v -a

# checkout
dot checkout master
# this will give an error about files that are about to be overridden
# verify things look correct (should only be a couple)
# but if you forgot to run: dot config --local status.showUntrackedFiles no, it could be bad

# force the checkout if the above looks ok
dot checkout -f master
```

Install Brew

- install Brew: <https://brew.sh/>
- install Brewfile

```bash
brew bundle --file $HOME/.brew/Brewfile
```

Update Default Shell

- After installing `bash` with `brew` make sure to update `/etc/shells` with the path to the HomeBrew version of `bash`
- `/etc/shells` has only one true purpose: It lists programs that `chsh` will let you change your shell to
- Note: Verify the path `/opt/homebrew/bin/bash` is still correct. This changed when moving from my Intel -> M2 MacBook

```bash
# Update /etc/shells
sudo vim /etc/shells
# Append this to the end: /opt/homebrew/bin/bash
# This ^ just makes it available to chsh

# Change default shell for current user
chsh -s /opt/homebrew/bin/bash $USER

# Change default shell for root user
sudo chsh -s /opt/homebrew/bin/bash root

# Sanity check - quit iTerm, re-open it to verify your version
# Bash version of the currently running shell
echo $BASH_VERSION

# Should output the same as above but could be different if something is messed up
# This will output the bash version of the first instance found in your $PATH (not what you are actually running)
bash --version

# Print the path to bash
which bash
```

Restore Python Virtual Environments

- `~/.bashrc` is also configured to activate the `default` venv

```bash
python3 -m venv ~/.venv/default
source ~/.venv/default/bin/activate
pip install -r ~/.venv/default.requirements.txt
```
