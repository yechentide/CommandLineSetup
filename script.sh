#!/bin/bash

chsh -s $(which zsh)

rm -fr "${HOME}/.z*"

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

rm -f "${HOME}/.zprezto/runcoms/zpreztorc"
rm -f "${HOME}/.vimrc"
rm -f "${HOME}/.tmux.conf"
cp ./files/zpreztorc "${HOME}/.zprezto/runcoms/zpreztorc"
cp ./files/vimrc "${HOME}/.vimrc"
cp ./files/tmux.conf "${HOME}/.tmux.conf"

source ~/.zpreztorc