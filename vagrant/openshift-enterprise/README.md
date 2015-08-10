# OpenShift Enterprise 3 nodes setup with Vagrant and quick installer

## Prerequisites

For install host, Fedora 22, Vagrant and Vagrant Libvirt.

For OpenShift Enterprise installation, Red Hat user account with valid OpenShift Enterprise subscription.

```
sudo dnf install -y libvirt qemu-kvm vagrant vagrant-libvirt
sudo groupadd libvirt
sudo usermod -aG libvirt <user>
sudo vi /etc/libvirt/libvirtd.conf
  # Enable following lines to skip auth
  unix_sock_group = "libvirt"
  unix_sock_ro_perms = "0777"
  auth_unix_ro = "none"
  auth_unix_rw = "none"
sudo systemctl enable libvirtd && sudo systemctl start libvirtd
```

## Installation Steps

- Download RHEL 7.1 Vagrant libvirt box
  - https://access.redhat.com/downloads/content/293/ver=1/rhel---7/1.0.0/x86_64/product-downloads
- vagrant box add rhel-7.1 rhel-server-libvirt-7.1-0.x86_64.box
- Modify RHSM info in `.rhn-username`, `.rhn-password` and `.rhn-poolid`
- vagrant up
- vagrant ssh master
  - ./sync/ssh-copy-id.sh
  - ./sync/pre-install.sh
  - ./sync/install.sh

```
master.cloud,192.168.232.101,192.168.232.101,master.cloud,master.cloud
node01.cloud,192.168.232.201,192.168.232.201,node01.cloud,node01.cloud
node02.cloud,192.168.232.202,192.168.232.202,node02.cloud,node02.cloud
```

  - ./sync/post-install.sh

  - Modify /etc/openshift/master/master-config.xml auth config as you like.


## Notes

- Why don't perform all pre-install task in the vagrant shell provisioning?
  - Because it doesn't perform tasks in parallel so it's slow. Especially RHSM and yum update.

  

## TODO

- NetworkManager config on host machine