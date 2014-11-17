#/bin/bash

set -e

CUR_DIR=$PWD/`dirname $0`

if [ -f ~/.vimrc ] ; then
  mv -f ~/.vimrc ~/.vimrc.bak
fi

LINK_TARGET=`readlink -f ${CUR_DIR}/.vimrc`
ln -s ${LINK_TARGET} ~/.vimrc

if [ -d ~/.vim/bundle/Vundle.vim ] ; then
  echo "Vundle dir exists, won't overwrite it..."
else
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
