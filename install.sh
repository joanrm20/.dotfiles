#!/bin/sh
set -e

cd ~/.vim_runtime

echo '" Install minpac to manage plugins.'
git clone https://github.com/k-takata/minpac.git ~/.vim_runtime/pack/minpac/opt/minpac

echo 'set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/base.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins.vim
source ~/.vim_runtime/vimrcs/extended.vim
' > ~/.vimrc

echo "

🚀🚀🚀🚀🚀

"
