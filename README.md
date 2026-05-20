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

## Manual steps (can't be automated)

- **FileVault**: System Settings → Privacy & Security → FileVault → Turn On
- **1Password**: Install from App Store, sign in
- **iCloud**: System Settings → Apple ID → iCloud
- **asdf plugins**: `asdf plugin add nodejs && asdf plugin add pnpm`
- **Oh My Zsh**: `curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh`
- **Spaceship theme**: `git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 && ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"`
- **iTerm2 profile**: After running `install.sh`, open iTerm2 → Preferences → General → Preferences → Save current settings to folder
- **Git worktrees**: `wt <branch>`, `wt-rm <branch>`, `wt-ls`

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
