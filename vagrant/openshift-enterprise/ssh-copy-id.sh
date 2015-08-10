#!/bin/bash

set -x

NODES="master node01 node02"
DOMAIN=cloud

# silent ssh-keygen

cat /dev/zero | ssh-keygen -q -N "" &> /dev/null

for node in $NODES; do
    ssh-copy-id $node.$DOMAIN -o StrictHostKeyChecking=no
done
