#!/bin/bash

rm -f "${HOME}/.vimrc"
rm -f "${HOME}/.tmux.conf"

cp ./files/vimrc "${HOME}/.vimrc"
cp ./files/tmux.conf "${HOME}/.tmux.conf"

cd ~
rm -fr CommandLineSetup