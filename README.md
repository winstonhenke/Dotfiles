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

Once setup use the `dot` alias from your home directory

- `dot status`
- `dot add -u` (you do not want to run add all)
- `dot ls-files` - List all files being tracked
- See `alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'` in `.bashrc`

## Setup

### Original Creation

Created a `dot` alias in `$HOME/.bashrc`

- `alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'`
- Init a bare repository in `$HOME/.dotgit`

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

- `alias dot='git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'`
  - Create the `dot` alias for the current terminal session (since we don't have the `.bashrc` being used yet)
- `git init --bare $HOME/.dotgit`
- `dot config --local status.showUntrackedFiles no`
- `dot remote add origin https://github.com/winstonhenke/Dotfiles.git`
- `dot fetch origin`
- Sanity checks
  - `dot remote -v`
  - `dot status`
  - `dot diff origin/master`
  - `dot config --list --show-origin`
    - Confirm: `status.showuntrackedfiles=no`
  - `dot branch -v -a`
- `dot checkout master`
  - This will give an error about files that are about to be overridden
  - Verify things look correct (should only be a couple)
  - But if you forgot to run: `dot config --local status.showUntrackedFiles no`, it could be bad
- Force the checkout if the above looks ok
  - `dot checkout -f master`
- When this is done you should NOT have a `.git` **file** in your home directory
  - Had an issue with this when I was using `git clone` to pull this stuff down (instead of initalizing a new bare repo and linking the origin as outlined above)
  - Only had one line: `gitdir: /Users/whenke/.dotgit`
  - This was why iTerm was showing the `(master)` git repo as part of PS1 when in folders that were not repos

Install Brew

- Install Brew: <https://brew.sh/>
- Install Brewfile: `brew bundle --file $HOME/.brew/Brewfile`

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

## Package Managers

### HomeBrew

- [Online package browser for Homebrew](https://formulae.brew.sh/)
- Formulae: Typically command line tools
- Casks: Extension of Homebrew that allows installing MacOS native applications (example Firefox)
- Tap: By default it will only find packages in the standard Homebrew repository. To add packages from additional sources you first need to `brew tap` that repo.
- Installs to: `/usr/local/Cellar/` (`/opt/homebrew/Cellar` on Apple Silicon)
  - With symbolic links added to `/usr/local/bin/`

Commands: <https://docs.brew.sh/>

- `brew help`
- `brew --prefix` - Display Homebrew’s install path
- Brew deps
  - `brew deps --tree --include-requirements python > ./python.deps.txt` (specific formula)
  - `brew deps --tree --installed --include-requirements > ./brew.deps.tree.txt`
  - `brew deps --graph --dot --installed --include-requirements --include-build > ./brew.deps.graph.txt`
  - `brew deps --graph --installed --include-requirements` - Launches a browser tab
- `brew update` - Update all package definitions (formulae) and Homebrew itself
- `brew outdated`- List which of your installed packages (kegs) are outdated
- `brew upgrade` - Upgrade everything
  - `brew upgrade <formula>` - Upgrade a specific formula
- `brew list` - List all installed formulae or casks
  - `brew list --full-name --verbose` - Print formulae with fully-qualified names
  - `brew list --versions --verbose` - Show the version number for installed formulae
  - `brew list --versions --verbose --multiple` - Only show formulae with multiple versions installed
  - `brew list --pinned` - List only pinned formulae, or only the specified (pinned) formulae if formula are provided.
- `brew doctor` - Check your system for potential problems
- `brew cleanup`
- `brew info` - Display brief statistics for your Homebrew installation
  - `brew info python` - If a formula or cask is provided, show summary of information about it
  - `brew info --github python` - Open the GitHub source page for formula and cask in a browser
  - `brew info --json=v1 python | jq . > pyhon.info.json` - Pretty-print a single formula’s info
  - `brew info --json=v1 --installed > brew.info.json` - To show full JSON information about all installed formulae
- `brew search java` - Perform a substring search of cask tokens and formula names for text. If text is flanked by slashes, it is interpreted as a regular expression.
- `brew pin`
- `brew unpin`
- `brew reinstall example`
  - Useful when something was installed as a depency but when I want it added to the bundle dump
- `brew bundle dump --force --file ~/.brew/Brewfile` - Write all installed casks/formulae/images/taps into a Brewfile

---

### PiP

- `pip list`
  - `-o, --outdated`
  - `-u, --uptodate`

---

### NPM

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
