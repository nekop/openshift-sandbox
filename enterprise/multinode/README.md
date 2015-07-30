# Steps

- ssh-keygen on installer host (master)
- ssh-copy-id to all nodes
- Check timezone, hostname, /etc/hosts and /etc/resolv.conf
- init.sh
- sh -x <(curl -s https://install.openshift.com/ose)
- echo '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"registry"}}' | oc create -f -
- oc edit scc privileged # Add "system:serviceaccount:default:registry" under users
- mkdir -p /registry
- oadm registry --config=/etc/openshift/master/admin.kubeconfig --credentials=/etc/openshift/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --mount-host=/registry --service-account=registry
- oadm router   --config=/etc/openshift/master/admin.kubeconfig --credentials=/etc/openshift/master/openshift-router.kubeconfig   --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --replicas=1


# Checkpoints

- hostnamectl
- timedatectl
- /etc/hosts
- /etc/resolv.conf
- df
- docker-storage


# Remaining Tasks

- Modify auth config in /etc/openshift/master/master-config.yaml
- Modify subdomain of routingConfig in /etc/openshift/master/master-config.yaml


