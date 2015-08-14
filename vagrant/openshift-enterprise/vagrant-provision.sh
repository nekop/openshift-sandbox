#!/bin/bash

set -x

DOMAIN=cloud
APP_DOMAIN=apps.cloud
NODENAME=$1

# set timezone and hostname

sudo timedatectl set-timezone Asia/Tokyo
sudo hostnamectl set-hostname $NODENAME.$DOMAIN

# setup /etc/hosts

grep "master.$DOMAIN" /etc/hosts > /dev/null
if [ $? -eq 1 ]; then
    sudo sh -c "cat << EOM >> /etc/hosts

192.168.232.101 master.$DOMAIN master
192.168.232.201 node01.$DOMAIN node01
192.168.232.202 node02.$DOMAIN node02
EOM"
fi

