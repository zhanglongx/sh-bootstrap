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
    echo -e "\nexport EDITOR=vim" >> ~/.bashrc
    echo -e "\nset -o vi\n" >> ~/.bashrc
fi

# ~/.inputrc
download_file _inputrc ~/.inputrc

# ~/.gitconfig
download_file _gitconfig ~/.gitconfig

# ~/.pip/pip.conf
mkdir -p ~/.pip
download_file _pip.conf ~/.pip/pip.conf

# ~/.vimrc
download_file _vimrc ~/.vimrc

# github_release.sh
download_file github_release.sh github_release.sh

bash github_release.sh ropen

rm -f github_release.sh

echo "Done. please re-login"
