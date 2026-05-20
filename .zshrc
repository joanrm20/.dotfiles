#
# .zshrc
#
# @author Jose Ramirez M.
#

# Don't save commands starting with a space to history (useful for secrets)
setopt HIST_IGNORE_SPACE

# Colors
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Nicer prompt
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git colorize pip python brew history zsh-autosuggestions zsh-syntax-highlighting)

# PATH
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
export PATH=$HOME/Go/bin:$PATH
export PATH=/usr/local/opt/openjdk/bin:$PATH
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

source $ZSH/oh-my-zsh.sh

# Shell functions (resolved relative to this file via symlink)
DOTFILES_DIR="$(dirname "$(readlink "$HOME/.zshrc")")"
source "$DOTFILES_DIR/shell/functions.sh"

# asdf completions
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
