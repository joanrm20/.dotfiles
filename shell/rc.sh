# Shared zsh config — source this from any machine's ~/.zshrc:
#   source ~/Documents/github/.dotfiles/shell/rc.sh

# Don't save commands starting with a space to history
setopt HIST_IGNORE_SPACE

# Colors
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Homebrew prefix — arch-aware (Apple Silicon vs Intel)
if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW_PREFIX=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  BREW_PREFIX=/usr/local
fi

# PATH — typeset -U deduplicates on every reload
path=(
  ${BREW_PREFIX:+$BREW_PREFIX/bin $BREW_PREFIX/sbin}
  $HOME/Go/bin
  ${BREW_PREFIX:+$BREW_PREFIX/opt/openjdk/bin}
  "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
  $path
)
typeset -U path

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
path=($PNPM_HOME $path)

# Shell functions — resolve dotfiles dir from this file's location
_DOTFILES_DIR="${0:A:h:h}"
source "$_DOTFILES_DIR/shell/functions.sh"
unset _DOTFILES_DIR

# Machine-specific config (not tracked in git)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
