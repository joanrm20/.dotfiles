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

echo ""
echo "Done! Restart your terminal or run: source ~/.zshrc"
