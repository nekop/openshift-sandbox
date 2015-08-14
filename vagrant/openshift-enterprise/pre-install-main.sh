#!/bin/bash

set -xe

DOMAIN=cloud
APP_DOMAIN=apps.cloud
NODENAME=$1

DIRNAME=$(dirname $0)
RHSM_USERNAME=$(cat $DIRNAME/.rhn-username)
RHSM_PASSWORD=$(cat $DIRNAME/.rhn-password)
RHSM_POOLID=$(cat $DIRNAME/.rhn-poolid)

# setup RHSM

sudo subscription-manager status > /dev/null &&:
if [ $? -eq 1 ]; then
    sudo subscription-manager register --username=$RHSM_USERNAME --password=$RHSM_PASSWORD
    sudo subscription-manager attach --pool $RHSM_POOLID
    sudo subscription-manager repos --disable=*
    sudo subscription-manager repos \
         --enable=rhel-7-server-rpms \
         --enable=rhel-7-server-extras-rpms \
         --enable=rhel-7-server-optional-rpms \
         --enable=rhel-7-server-ose-3.0-rpms
    sudo yum update -y
    sudo systemctl disable NetworkManager
    sudo systemctl stop NetworkManager
    sudo yum remove NetworkManager\* -y
    sudo yum install docker wget git net-tools bind-utils iptables-services bridge-utils nfs-utils sos sysstat bash-completion -y
    if [ "$NODENAME" == "master" ]; then
        sudo yum install python-virtualenv gcc -y
    fi
fi

# add HWADDR otherwise it doesn't come up next time because we removed NetworkManager

sudo pkill dhclient
ETH0_HWADDR=$(/usr/sbin/ip a | grep -A1 eth0 | grep link | cut -d' ' -f6)
sudo sh -c "cat << EOM >> /etc/sysconfig/network-scripts/ifcfg-eth0
HWADDR=$ETH0_HWADDR
DNS1=192.168.232.201
EOM"
sudo systemctl restart network

# setup dnsmask on node01

if [ "$NODENAME" == "node01" ]; then
    sudo cp /etc/resolv.conf /etc/resolv.conf.upstream
    sudo yum install dnsmasq -y
    sudo sh -c "cat << EOM > /etc/dnsmasq.conf
strict-order
domain-needed
local=/$DOMAIN/
bind-dynamic
resolv-file=/etc/resolv.conf.upstream
address=/.$APP_DOMAIN/192.168.232.101
log-queries
EOM"
    sudo iptables -I INPUT -p tcp --dport 53 -j ACCEPT
    sudo iptables -I INPUT -p udp --dport 53 -j ACCEPT
    sudo service iptables save
    sudo systemctl enable dnsmasq
    sudo systemctl restart dnsmasq
fi

# setup 2nd disk

sudo pvs | grep "/dev/vdb" > /dev/null &&:
if [ $? -eq 1 ]; then
    sudo pvcreate /dev/vdb
    sudo vgextend VolGroup00 /dev/vdb
    # sudo lvextend /dev/VolGroup00/LogVol00 --size 10G --resizefs
    sudo lvextend /dev/VolGroup00/docker-pool --size 8G
fi

# setup NFS export on master

if [ "$NODENAME" == "master" ]; then
    sudo yum install -y rpcbind
    sudo mkdir -p /exports
    sudo chown -R nfsnobody:nfsnobody /exports
    sudo chmod 777 /exports/
    sudo sh -c "cat << EOM > /etc/exports
/exports *(rw,sync,all_squash)
EOM"
    sudo perl -i -pe 's/STATDARG=""/STATDARG="-p 50825"/' /etc/sysconfig/nfs
    sudo perl -i -pe 's/RPCMOUNTDOPTS=""/RPCMOUNTDOPTS="-p 20048"/' /etc/sysconfig/nfs
    sudo systemctl restart rpcbind nfs-server rpc-statd # Boot once, otherwise sysctl -p fails
    sudo sh -c "cat << EOM >> /etc/sysctl.conf
fs.nfs.nlm_tcpport=53248
fs.nfs.nlm_udpport=53248
EOM"
    sudo sysctl -p
    sudo iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 111 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 20048 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 50825 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 53248 -j ACCEPT
    sudo service iptables save
    sudo systemctl enable rpcbind nfs-server rpc-statd nfs-idmapd
    sudo systemctl restart rpcbind nfs-server rpc-statd
    sudo systemctl restart nfs-idmapd
fi

# Allow NFS writes

sudo setsebool -P virt_use_nfs 1

echo "$NODENAME done"
