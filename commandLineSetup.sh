#!/bin/bash

set -eu

ESC=$(printf '\033') RESET="${ESC}[0m"


function fn_check_shell() {
    if [[ $SHELL != $(which zsh)  ]]; then
        echo "使用中のシェルはzshではないです"
        echo "まずはzshをインストールしてください"
        echo 'すでにインストールした場合は、chsh -s $(which zsh)コマンドで切り替えてください'
        exit 1
    fi
}

function fn_install_Prezto() {
    echo "${ESC}[33m==========Preztoのインストール==========${RESET}"
    echo "${ESC}[33m========================================${RESET}"

    cd $HOME

    rm -fr .zlogin .zlogout .zprezto .zpreztorc .zprofile .zshenv .zshrc .zcompdump

    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" > /dev/null

    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done

    echo "Preztoのインストールが完了しました！"
    
    echo "" >> .zshrc
    echo "# aliases" >> .zshrc
    echo "alias ll='ls -al'" >> .zshrc
    echo "alias l='ls -l'" >> .zshrc
    echo "alias ..='cd ..'" >> .zshrc
    echo "alias ...='cd ../..'" >> .zshrc
}

function fn_replace_configuration_files() {
    echo "${ESC}[33m==========設定ファイルを入れ替える==========${RESET}"
    echo "${ESC}[33m============================================${RESET}"

    cd $HOME

    if [[ -d ".zprezto" ]]; then
        echo "zpreztorcファイルを削除"
        rm -f "${HOME}/.zprezto/runcoms/zpreztorc"
        echo "zpreztorcファイルを移動"
        cp ~/CommandLineSetup/files/zpreztorc "${HOME}/.zprezto/runcoms/zpreztorc"
        echo "設定を反映"
        source ~/.zpreztorc
    else
        echo ".zpreztoディレクトリが存在しない"
    fi

    echo ".vimrcファイルを削除"
    rm -f "${HOME}/.vimrc"
    echo ".vimrcファイルを移動"
    cp ~/CommandLineSetup/files/vimrc "${HOME}/.vimrc"

    echo ".tmux.confファイルを削除"
    rm -f "${HOME}/.tmux.conf"
    echo ".tmux.confファイルを移動"
    cp ~/CommandLineSetup/files/tmux.conf "${HOME}/.tmux.conf"

    echo "設定ファイルの入れ替えが完了しました！"
}

function fn_clean_up() {
    # 実行するスクリプトのパスを”簡単に”得る方法がわからないため、リスクがある
    # 新たにコマンドをインストールしないで済むような方法がわかれば、実装する
    return 1
    PS3="CommandLineSetupを削除しますか==> "
    select option in 削除 そのまま; do
        if [[ $option == "削除" ]]; then
            cd ~
            rm -fr CommandLineSetup
        fi
        break
    done
}


#########################################################
# run
if [[ $1 == "setup" ]]; then
    fn_check_shell
    fn_install_Prezto
    fn_replace_configuration_files
elif [[ $1 == "update" ]]; then
    fn_replace_configuration_files
else
    echo "正しい引数を入力してください。"
    echo "引数の数は１個で、setupかupdateです。"
fi
