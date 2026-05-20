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
