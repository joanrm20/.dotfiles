#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Dotfiles: $DOTFILES_DIR"

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew packages
echo "==> Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "==> Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Spaceship theme
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
if [[ ! -d "$SPACESHIP_DIR" ]]; then
  echo "==> Installing Spaceship theme..."
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1
  ln -sf "$SPACESHIP_DIR/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
fi

# asdf plugins
echo "==> Installing asdf plugins..."
asdf plugin add nodejs || true
asdf plugin add pnpm || true

# Symlinks
echo "==> Linking dotfiles..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc" && echo "  ✓ ~/.zshrc"
ln -sf "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig" && echo "  ✓ ~/.editorconfig"

# iTerm2: load preferences from dotfiles
echo "==> Configuring iTerm2..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
echo "  ✓ iTerm2 preferences folder set"
echo "  ! Open iTerm2 → Preferences → General → Preferences and click 'Save current settings to folder' to export your profile"

echo ""
echo "Done! Restart your terminal or run: source ~/.zshrc"
