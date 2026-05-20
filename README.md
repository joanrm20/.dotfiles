# dotfiles

macOS setup for software engineering.

## Automated setup

```bash
git clone git@github.com:joanrm20/.dotfiles.git ~/Documents/github/.dotfiles
cd ~/Documents/github/.dotfiles
./install.sh
sudo ./.osx
```

`install.sh` handles: Homebrew, packages (Brewfile), symlinks, iTerm2 preferences folder.
`.osx` handles: macOS system defaults — run once after a fresh install.

## Machine-specific config

Create `~/.zshrc.local` for anything that shouldn't be committed — work API keys,
work-specific aliases, different paths per machine. It's sourced automatically and gitignored.

```bash
# ~/.zshrc.local example
export GITHUB_TOKEN="..."
export WORK_DB_URL="..."
alias work-vpn="sudo openconnect ..."
```

## Structure

```
.dotfiles/
├── .editorconfig       # consistent editor settings across tools
├── .gitignore
├── .osx                # macOS system defaults
├── .zshrc              # shell config
├── Brewfile            # all Homebrew dependencies
├── install.sh          # onboarding script
├── iterm2/             # iTerm2 profile (exported manually)
└── shell/
    └── functions.sh    # shell functions (wt, wt-rm, wt-ls)
```
