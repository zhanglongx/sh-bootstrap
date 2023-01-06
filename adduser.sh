#! /usr/bin/env bash

set -x

USERNAME=zhlx

failed_exit()
{
    echo "$1"
    exit 1
}

adduser_ubuntu() {
    name=$1

    adduser $USERNAME
    usermod -aG sudo $USERNAME
}

[ `id -u` = 0 ] || failed_exit "$0 *MUST* ran by root or sudo"

if egrep -q "^$USERNAME:" /etc/passwd; then
    failed_exit "$USERNAME already exists"
fi

adduser_ubuntu