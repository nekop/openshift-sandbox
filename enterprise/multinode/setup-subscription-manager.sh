#/bin/bash

subscription-manager register --username=$(cat .rhn-username) --password=$(cat .rhn-password)
subscription-manager attach --pool $(cat .rhn-poolid)
subscription-manager repos --disable=*
subscription-manager repos \
  --enable=rhel-7-server-rpms \
  --enable=rhel-7-server-extras-rpms \
  --enable=rhel-7-server-optional-rpms \
  --enable=rhel-7-server-ose-3.0-rpms
yum update -y
