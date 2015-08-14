#!/bin/bash

set -x

# For master so node doesn't need them
# sudo docker pull registry.access.redhat.com/openshift3/ose-haproxy-router
# sudo docker pull registry.access.redhat.com/openshift3/ose-docker-registry

NODES="node01 node02"
DOMAIN=cloud

for node in $NODES; do
    ssh $node.$DOMAIN & <<EOF
sudo docker pull registry.access.redhat.com/openshift3/ose-deployer
sudo docker pull registry.access.redhat.com/openshift3/ose-sti-builder
sudo docker pull registry.access.redhat.com/openshift3/ose-sti-image-builder
sudo docker pull registry.access.redhat.com/openshift3/ose-docker-builder
sudo docker pull registry.access.redhat.com/openshift3/ose-pod
sudo docker pull registry.access.redhat.com/openshift3/ose-keepalived-ipfailover
sudo docker pull registry.access.redhat.com/openshift3/mysql-55-rhel7
sudo docker pull registry.access.redhat.com/openshift3/nodejs-010-rhel7
sudo docker pull registry.access.redhat.com/openshift3/perl-516-rhel7
sudo docker pull registry.access.redhat.com/openshift3/php-55-rhel7
sudo docker pull registry.access.redhat.com/openshift3/postgresql-92-rhel7
sudo docker pull registry.access.redhat.com/openshift3/python-33-rhel7
sudo docker pull registry.access.redhat.com/openshift3/ruby-20-rhel7
sudo docker pull registry.access.redhat.com/openshift3/mongodb-24-rhel7
sudo docker pull registry.access.redhat.com/jboss-eap-6/eap-openshift
sudo docker pull registry.access.redhat.com/jboss-amq-6/amq-openshift
sudo docker pull registry.access.redhat.com/jboss-webserver-3/tomcat8-openshift
sudo docker pull registry.access.redhat.com/jboss-webserver-3/tomcat7-openshift
EOF
done
wait


