#!/bin/sh
set -e

cd ~/.vim_runtime

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/base.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
" source ~/.vim_runtime/vimrcs/plugins_config.vim // no plugins yet :P
source ~/.vim_runtime/vimrcs/extended.vim
' > ~/.vimrc

echo "🚀"
