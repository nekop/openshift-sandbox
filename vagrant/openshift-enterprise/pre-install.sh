#!/bin/bash

set -x

NODES="master node01 node02"
DOMAIN=cloud

for node in $NODES; do
    ssh $node.$DOMAIN sh -x sync/pre-install-main.sh $node &
done
wait

echo "Done, you can perform OSE installer."
