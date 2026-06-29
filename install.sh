#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --minimal (alias --work): wire up only the portable shell layer (rc.sh + the
# worktree helpers + ~/.zshrc.local). Skips everything that could override an
# existing machine's setup — no brew bundle, no Oh My Zsh, no git/editorconfig/
# iTerm2 changes. Use this on a work machine.
MINIMAL=0
for arg in "$@"; do
  case "$arg" in
    --minimal|--work) MINIMAL=1 ;;
    -h|--help) echo "Usage: ./install.sh [--minimal]"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

echo "==> Dotfiles: $DOTFILES_DIR"
[[ $MINIMAL -eq 1 ]] && echo "==> Minimal mode: shell config only, no system/app changes"

if [[ $MINIMAL -eq 0 ]]; then
  # Homebrew
  if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Load Homebrew onto PATH for the rest of this script (arch-aware).
  # A fresh install doesn't put brew on PATH, so brew/asdf below would fail without this.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # Homebrew packages
  echo "==> Installing Homebrew packages..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"

  # Oh My Zsh — KEEP_ZSHRC=yes so the installer never replaces an existing ~/.zshrc
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "==> Installing Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

  # asdf completions — asdf 0.16+ (Go rewrite) no longer ships a static completions dir
  ASDF_COMP_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  mkdir -p "$ASDF_COMP_DIR"
  asdf completion zsh > "$ASDF_COMP_DIR/_asdf" 2>/dev/null || true
fi

echo "==> Configuring shell..."

# .zshrc — append source line, or create from template if none exists.
# Append-only and idempotent: never rewrites an existing ~/.zshrc.
if grep -qF "shell/rc.sh" "$HOME/.zshrc" 2>/dev/null; then
  echo "  ✓ ~/.zshrc already sources rc.sh"
elif [[ -f "$HOME/.zshrc" ]]; then
  printf "\nsource \"%s/shell/rc.sh\"\n" "$DOTFILES_DIR" >> "$HOME/.zshrc"
  echo "  ✓ Appended source line to ~/.zshrc"
else
  sed "s|__DOTFILES_DIR__|$DOTFILES_DIR|g" "$DOTFILES_DIR/.zshrc" > "$HOME/.zshrc"
  echo "  ✓ Created ~/.zshrc from template"
fi

# .zshrc.local — create from template only if none exists
if [[ ! -f "$HOME/.zshrc.local" ]]; then
  cp "$DOTFILES_DIR/shell/zshrc.local.template" "$HOME/.zshrc.local"
  echo "  ✓ Created ~/.zshrc.local from template"
else
  echo "  ✓ ~/.zshrc.local already exists"
fi

if [[ $MINIMAL -eq 1 ]]; then
  echo ""
  echo "Done (minimal). Restart your terminal or run: source ~/.zshrc"
  exit 0
fi

echo "==> Configuring git / editor / iTerm2..."

# .gitconfig — append [include] if not already present (never rewrites existing keys)
if grep -qF "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
  echo "  ✓ ~/.gitconfig already includes dotfiles config"
elif [[ -f "$HOME/.gitconfig" ]]; then
  printf "\n[include]\n\tpath = %s/.gitconfig\n" "$DOTFILES_DIR" >> "$HOME/.gitconfig"
  echo "  ✓ Added include to ~/.gitconfig"
else
  printf "[include]\n\tpath = %s/.gitconfig\n" "$DOTFILES_DIR" > "$HOME/.gitconfig"
  echo "  ✓ Created ~/.gitconfig"
fi

# .editorconfig — symlink, but never clobber an existing real file
if [[ "$(readlink "$HOME/.editorconfig" 2>/dev/null)" == "$DOTFILES_DIR/.editorconfig" ]]; then
  echo "  ✓ ~/.editorconfig already linked"
elif [[ -e "$HOME/.editorconfig" ]]; then
  echo "  ! ~/.editorconfig already exists — leaving it untouched"
else
  ln -s "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
  echo "  ✓ ~/.editorconfig linked"
fi

# iTerm2 — only if we actually ship a prefs folder, and don't hijack an existing custom folder
echo "==> Configuring iTerm2..."
if [[ ! -d "$DOTFILES_DIR/iterm2" ]]; then
  echo "  ! Skipping — no iterm2/ folder in dotfiles yet"
else
  existing="$(defaults read com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null || true)"
  if [[ -n "$existing" && "$existing" != "$DOTFILES_DIR/iterm2" ]]; then
    echo "  ! iTerm2 already uses a custom prefs folder: $existing — leaving it untouched"
  else
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    echo "  ✓ iTerm2 preferences folder set"
  fi
fi

echo ""
echo "Done! Restart your terminal or run: source ~/.zshrc"
