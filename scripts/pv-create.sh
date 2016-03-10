#!/bin/bash

oc project default
for i in $(seq 1 50); do
    PV=$(cat <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv$(printf %04d $i)
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  nfs:
    server: tkimura-ose-single.usersys.redhat.com
    path: /exports/pv$(printf %04d $i)
EOF
)
    echo "$PV" | oc create -f -
    sudo mkdir /exports/pv$(printf %04d $i)
done
sudo chown -R nfsnobody:nfsnobody /exports
sudo chmod -R 777 /exports

