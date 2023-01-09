#! /usr/bin/env bash

set -x

URL_PREFIX=https://raw.githubusercontent.com/zhanglongx/sh-bootstrap/main

failed_exit()
{
    echo "$1"
    exit 1
}

download_file() {
    remote=$1
    filename=$2

    wget -nc $URL_PREFIX/$remote -O $filename
}

# apt
apt install vim git

# ~/.bashrc
if ! [ -e ~/.bashrc ]; then
    touch ~/.bashrc
fi

if ! egrep -Fxq "set -o vi" ~/.bashrc; then
    echo "\nset -o vi\n" >> ~/.bashrc
fi

# ~/.inputrc
download_file _inputrc ~/.inputrc

# ~/.gitconfig
download_file _gitconfig ~/.gitconfig

# ~/.vimrc
download_file _vimrc ~/.vimrc

echo "Done. please re-login"
