# dotfiles

macOS setup for software engineering.

## Setup

```bash
git clone git@github.com:joanrm20/.dotfiles.git ~/Documents/github/.dotfiles
cd ~/Documents/github/.dotfiles
./install.sh
sudo ./.osx
```

`install.sh` handles: Homebrew, packages (Brewfile), iTerm2 preferences folder, and wiring up `~/.zshrc`:
- If `~/.zshrc` exists, appends `source .../shell/rc.sh` to it (works on personal and work machines alike)
- If not, copies `.zshrc` from this repo as a starter (Oh My Zsh + Spaceship)

### Work machines — `--minimal`

```bash
./install.sh --minimal   # (alias: --work)
```

Minimal mode wires up **only the portable shell layer** — the `wt` worktree
helpers, shared `rc.sh` config, and `~/.zshrc.local`. It does **not** run
`brew bundle`, install Oh My Zsh, or touch `~/.gitconfig`, `~/.editorconfig`,
or iTerm2 prefs. Safe to run on a machine that already has its own setup.

It never rewrites an existing `~/.zshrc` — it only appends a single `source`
line (idempotently). The full run is also non-destructive: Oh My Zsh is
installed with `KEEP_ZSHRC=yes`, `~/.editorconfig` is left alone if it already
exists, the git config is added as an `[include]` (no keys rewritten), and
iTerm2 is skipped if it already points at a different custom prefs folder.

`.osx` handles: macOS system defaults — run once after a fresh install.
**Don't run `.osx` on a work machine** — it rewrites system-wide defaults.

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
├── .editorconfig            # consistent editor settings across tools
├── .gitconfig               # git defaults + git-delta (included into ~/.gitconfig)
├── .gitignore
├── .osx                     # macOS system defaults
├── .zshrc                   # starter template (used only on fresh machines with no existing .zshrc)
├── Brewfile                 # all Homebrew dependencies
├── install.sh               # onboarding script
├── iterm2/                  # iTerm2 profile (exported manually)
└── shell/
    ├── functions.sh         # shell functions (wt, wt-rm, wt-ls)
    ├── rc.sh                # shared config sourced into any machine's ~/.zshrc
    └── zshrc.local.template # template copied to ~/.zshrc.local on first install
```
