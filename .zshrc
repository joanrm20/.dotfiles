#
# .zshrc — starter template for a fresh personal machine
#
# @author Jose Ramirez M.
#

# asdf completions must be on fpath before Oh My Zsh calls compinit
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git colorize pip python brew history zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

source "__DOTFILES_DIR__/shell/rc.sh"
