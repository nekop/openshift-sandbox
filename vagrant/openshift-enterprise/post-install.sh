#!/bin/bash

set -x

DOMAIN=cloud
APP_DOMAIN=apps.cloud

oc label node master.$DOMAIN region=infra
oadm manage-node master.$DOMAIN --schedulable=true
echo '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"registry"}}' | oc create -f -
echo '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"router"}}' | oc create -f -
sudo mkdir -p /registry
(oc get scc privileged -o yaml -n default; echo "- system:serviceaccount:default:registry"; echo "- system:serviceaccount:default:router") | oc replace -f -
sudo oadm registry --selector="region=infra" --config=/etc/openshift/master/admin.kubeconfig --credentials=/etc/openshift/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --replicas=1 --service-account=registry --mount-host=/registry
sudo oadm router   --selector="region=infra" --config=/etc/openshift/master/admin.kubeconfig --credentials=/etc/openshift/master/openshift-router.kubeconfig   --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --replicas=1 --service-account=router
sleep 5
# With first creation time, ReplicationController may not be updated with replicas=1, so do it again
oc scale rc docker-registry-1 --replicas=1
oc scale rc router-1 --replicas=1
# Wait for pull images
sleep 60
oadm manage-node master.$DOMAIN --schedulable=false
oc delete pod docker-registry-1-deploy
oc delete pod router-1-deploy
sudo perl -i -pe "s/  subdomain: router.default.local/  subdomain: $APP_DOMAIN/" /etc/openshift/master/master-config.yaml
sudo systemctl restart openshift-master
