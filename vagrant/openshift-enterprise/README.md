# OpenShift Enterprise 3 nodes setup with Vagrant and quick installer


## Prerequisites

Requires Fedora 22 (possibly 21, not tested), Vagrant and Vagrant Libvirt for installation host. 4CPUs, 8GB memory, 60GB disk space.

Red Hat user account with valid OpenShift Enterprise subscription for OpenShift Enterprise installation.

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


## Setup details

- master.cloud (192.168.232.101)
  - OpenShift master and node (schedulable=false)
  - registry
  - router
  - NFS
- node01.cloud (192.168.232.201)
  - OpenShift node
  - DNS (dnsmasq)
- node02.cloud (192.168.232.202)
  - OpenShift node


## Installation Steps

- Download RHEL 7.1 Vagrant libvirt box
  - https://access.redhat.com/downloads/content/293/ver=1/rhel---7/1.0.0/x86_64/product-downloads
- vagrant box add rhel-7.1 rhel-server-libvirt-7.1-0.x86_64.box
- Git clone https://github.com/nekop/openshift-sandbox and cd openshift-sandbox/vagrant/openshift-enterprise
- Create and describe RHSM info in `.rhn-username`, `.rhn-password` and `.rhn-poolid` files in this directory
- vagrant up
- vagrant ssh master
  - ./sync/ssh-copy-id.sh # asks password, input "vagrant" 3 times
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
- Vagrant/VirtualBox?
  - Not supported yet, pull request welcome.
- `.cloud` domain revoled to `127.0.53.53` and routed to localhost
  - It's a conflict domain, see https://www.icann.org/news/announcement-2-2014-08-01-en
  - This is a hack. You can port forward 127.0.53.53 to openshift router node and access to `*.apps.cloud`, without DNS setting
  - ssh -fNL 127.0.53.53:8080:192.168.232.101:80 vagrant@192.168.232.101
