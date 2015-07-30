#/bin/bash

# run with "-x > logfile 2>&1" is recommended, you may have nohup too.

SETUP_DOCKER=false

OSE3_MASTER=$(cat .ose3-master)
OSE3_NODES=$(cat .ose3-nodes)

for n in $OSE3_MASTER $OSE3_NODES; do
    scp -rp ../ose3-setup $n:/tmp/
done

for n in $OSE3_MASTER $OSE3_NODES; do
    # This also perform yum update
    ssh $n "cd /tmp/ose3-setup/ ; sh setup-subscription-manager.sh" &
done
wait
for n in $OSE3_MASTER $OSE3_NODES; do
    ssh $n yum remove NetworkManager\* -y &
done
wait
for n in $OSE3_MASTER $OSE3_NODES; do
    ssh $n yum install docker wget git net-tools bind-utils iptables-services bridge-utils -y &
done
wait

ssh $OSE3_MASTER yum install python-virtualenv gcc -y &
wait

if [ "$SETUP_DOCKER" == "true" ]; then
    for n in $OSE3_MASTER $OSE3_NODES; do
        ssh $n sh -c '"cat << EOM >> /etc/sysconfig/docker-storage-setup
VG=docker-vg
EOM"'
        ssh $n systemctl stop docker
        ssh $n rm -rf /var/lib/docker/\*
        ssh $n docker-storage-setup
        ssh $n systemctl restart docker
    done
fi

for n in $OSE3_MASTER $OSE3_NODES; do
    ssh $n rm -rf /tmp/ose3-setup/
done

for n in $OSE3_MASTER $OSE3_NODES; do
    ssh $n <<EOF &
docker pull registry.access.redhat.com/openshift3/ose-haproxy-router
docker pull registry.access.redhat.com/openshift3/ose-deployer
docker pull registry.access.redhat.com/openshift3/ose-sti-builder
docker pull registry.access.redhat.com/openshift3/ose-sti-image-builder
docker pull registry.access.redhat.com/openshift3/ose-docker-builder
docker pull registry.access.redhat.com/openshift3/ose-pod
docker pull registry.access.redhat.com/openshift3/ose-docker-registry
docker pull registry.access.redhat.com/openshift3/sti-basicauthurl
docker pull registry.access.redhat.com/openshift3/ose-keepalived-ipfailover
docker pull registry.access.redhat.com/openshift3/mysql-55-rhel7
docker pull registry.access.redhat.com/openshift3/nodejs-010-rhel7
docker pull registry.access.redhat.com/openshift3/perl-516-rhel7
docker pull registry.access.redhat.com/openshift3/php-55-rhel7
docker pull registry.access.redhat.com/openshift3/postgresql-92-rhel7
docker pull registry.access.redhat.com/openshift3/python-33-rhel7
docker pull registry.access.redhat.com/openshift3/ruby-20-rhel7
docker pull registry.access.redhat.com/openshift3/mongodb-24-rhel7
docker pull registry.access.redhat.com/jboss-eap-6/eap-openshift
docker pull registry.access.redhat.com/jboss-amq-6/amq-openshift
docker pull registry.access.redhat.com/jboss-webserver-3/tomcat8-openshift
docker pull registry.access.redhat.com/jboss-webserver-3/tomcat7-openshift
EOF
done
wait

echo "Done, you can perform OSE installer."

