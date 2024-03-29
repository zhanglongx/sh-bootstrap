#! /usr/bin/env bash

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

# ~/.bashrc
if ! [ -e ~/.bashrc ]; then
    touch ~/.bashrc
fi

if ! egrep -xq "set -o vi" ~/.bashrc; then
    echo -e "\nexport EDITOR=vim\n" >> ~/.bashrc
    echo -e "\nset -o vi\n" >> ~/.bashrc
fi

# ~/.inputrc
download_file _inputrc ~/.inputrc

# ~/.gitconfig
download_file _gitconfig ~/.gitconfig

# ~/.vimrc
download_file _vimrc ~/.vimrc

echo "Done. please re-login"
