# OpenShift Enterprise command cheat sheet

This is command cheat sheet for OpenShift Container Platform.

For more command examples please refer to https://github.com/openshift/origin/blob/master/docs/generated/oc_by_example_content.adoc

## Create an app

```
oc new-app $GIT_URL
```

## List project

```
oc get project
```

## View all in project

```
oc get all
```

Output includes:

- buildconfig
- build
- imagestream
- deploymentconfig
- replicationcontroller
- service
- pod

`pvc` is not included in the `all`, so you may want `oc get all,pvc`.


## Delete all in project

```
oc delete all,pvc --all
```

## List pod

```
oc get pod
```

## List pod with node

```
oc get pod -o wide
```

## List pod names (for scripting)

```
oc get pod -o name
```

## Get specific item using Go template (for scripting)

```
oc get dc docker-registry --template='{{range .spec.template.spec.containers}}{{.image}}{{end}}'
oc get service docker-registry --template='{{.spec.clusterIP}}'
oc get pod docker-registry-2-xxx --template='{{.status.podIP}}'
```

## Get pod log

```
oc get logs $POD_NAME
```

## Get CrashLoop pod log

```
oc get logs -p $POD_NAME
```

## rsh into pod

```
oc rsh $POD_NAME
```

## exec single command in pod

```
oc exec $POD_NAME $COMMAND
```

## Read resource schema doc

```
oc explain dc
oc explain dc.spec
```

## Export

```
oc export is,bc,dc,svc --as-template=app.yaml
```

## Create build from local Dockerfile and deploy

```
cat Dockerfile | oc new-build --dockerfile=- --to=$APP_NAME
oc new-app $APP_NAME
```

## Create build from local dir with Dockerfile and deploy

```
oc new-build --strategy=docker --binary=true --name=$APP_NAME
oc start-build $APP_NAME --from-dir=.
oc new-app $APP_NAME
```

## Debug

```
oc debug dc $DC_NAME
oc debug dc $DC_NAME --as-root=true
oc debug dc $DC_NAME --node-name=$NODENAME
```

## Troubleshoot OpenShift

For infrastructure level issues, get sosreport, logs and configs as root user:

```
# Make sure to install or update sos latest version
rpm -q sos || yum install sos -y; rpm -q sos && yum update sos -y
sosreport -e docker -k docker.all=on
```

To get only openshift logs and configs:

```
journalctl -u atomic-openshift-node -u atomic-openshift-master -u atomic-openshift-master-api -u atomic-openshift-master-controllers | gzip > $(hostname)-openshift.log.gz
tar czf $(hostname)-openshift-config.tar.gz /etc/origin /etc/sysconfig/atomic-openshift-*  /etc/sysconfig/docker*
```

For project, use shell script:

```
#!/bin/bash

# dump-project.sh PROJECT_NAME

PROJECT=$1

if [ -z $PROJECT ]; then
  echo "Usage: $0 PROJECT_NAME"
  exit 1
fi

DEST=$PROJECT-$(date +%Y%m%d%H%M%S).txt.gz
(
  set -x
  date
  oc project $PROJECT
  oc version
  oc status
  oc get all,pvc,quota,limits,sa,secrets -o wide
  oc get all,pvc,quota,limits,sa,secrets -o yaml
  oc get event -w &
  WATCH_PID=$!
  sleep 5
  kill $WATCH_PID
  PODS=$(oc get pod -o name)
  for pod in $PODS; do
      CONTAINERS=$(oc get $pod --template='{{range .spec.containers}}{{.name}}
{{end}}')
      for c in $CONTAINERS; do
      oc logs $pod --container=$c
      oc logs -p $pod --container=$c
      done
  done
  # if admin get additional info
  if [ "$(oc policy can-i get nodes)" == "yes" ]; then
    oc get node -o wide
    oc get node -o yaml
    oc describe node
    oc get hostsubnet
    oadm diagnostics --diaglevel=0
  fi
  date
) 2>&1 | gzip > $DEST
echo "Generated $DEST"
# end
```

## Claim PersistentVolume

```
oc new-app sonatype/nexus
oc volume dc nexus --remove --confirm
oc volume dc nexus --add --name=nexus-storage -t pvc --claim-name=nexus --claim-mode=ReadWriteMany --claim-size=1Gi --mount-path=/sonatype-work
```

## Define resource requests and limits in DeploymentConfig

```
oc patch dc $DC_NAME -p "spec:
  template:
    spec:
      containers:
      - name: $CONTAINER_NAME
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 500m
            memory: 512Mi"
```

## Define livenessProve and readinessProve in DeploymentConfig

```
oc patch dc $DC_NAME -p "spec:
  template:
    spec:
      containers:
      - name: $CONTAINER_NAME
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /
            port: 8080
            scheme: HTTP
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5"
```

## Define Horizontal Pod Autoscaler (hpa)

```
oc autoscale dc $DC_NAME --max=4 --cpu-percent=10
```

## Define nodeSelector in DeploymentConfig

```
oc patch dc $DC_NAME -p "spec:
  template:
    spec:
      nodeSelector:
        region: infra"
```

## Define nodeSelector in Project

```
oc annotate namespace default openshift.io/node-selector=region=infra
```

## Disable defaultNodeSelector in Project

```
oc annotate namespace default openshift.io/node-selector=""
```

## Access kubelet API

```
curl --cacert /etc/origin/master/ca.crt --cert /etc/origin/master/admin.crt --key /etc/origin/master/admin.key -v https://$NODE:10250/pods
curl --cacert /etc/origin/master/ca.crt --cert /etc/origin/master/admin.crt --key /etc/origin/master/admin.key -v https://$NODE:10250/stats/$NAMESPACE/$POD_NAME/$POD_UID/$POD_SHORT_NAME
```

## Access heapster API

```
curl --cacert /etc/origin/master/ca.crt --cert /etc/origin/master/admin.crt --key /etc/origin/master/admin.key https://$MASTER_URL/api/v1/proxy/namespaces/openshift-infra/services/https:heapster:/api/v1/model/namespaces/default/pods/
```

https://github.com/kubernetes/heapster/blob/master/docs/model.md

## Access Hawkular Metrics API

Direct access to Hawkular Metrics API is not officially supported. We can use `-k` instead of `--cacert ...`. The `$METRICS_ID` can be extracted from the first 2 examples, "id" field.

```
curl --cacert /etc/origin/master/ca.crt -H "Authorization: Bearer $(oc whoami -t)" -H "Hawkular-Tenant: $PROJECT" https://$HAWKULAR_METRICS_HOSTNAME/hawkular/metrics/metrics?type=gauge | python -mjson.tool
curl --cacert /etc/origin/master/ca.crt -H "Authorization: Bearer $(oc whoami -t)" -H "Hawkular-Tenant: $PROJECT" https://$HAWKULAR_METRICS_HOSTNAME/hawkular/metrics/metrics?type=counter | python -mjson.tool
curl --cacert /etc/origin/master/ca.crt -H "Authorization: Bearer $(oc whoami -t)" -H "Hawkular-Tenant: $PROJECT" https://$HAWKULAR_METRICS_HOSTNAME/hawkular/metrics/counters/$(perl -MURI::Escape -e 'print uri_escape($ARGV[0])' $METRICS_ID)/data?bucketDuration=1d | python -m json.tool
```

## Dump etcd

```
curl --cacert /etc/origin/master/ca.crt --cert /etc/origin/master/master.etcd-client.crt --key /etc/origin/master/master.etcd-client.key https://$(hostname):4001/v2/keys/?recursive=true > etcd.dump
cat etcd.dump | python -mjson.tool > etcd.dump.pretty
```

## Setup NFS on master node

```
mkdir -p /exports
chown -R nfsnobody:nfsnobody /exports
chmod 770 /exports/
sh -c "cat << EOM > /etc/exports
/exports *(rw,sync,root_squash,no_wdelay)
EOM"
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT
service iptables save
systemctl enable nfs-server
systemctl restart nfs-server
```

## Create PVs on master node

```
SERVER=$(hostname)
COUNT=50

mkdir -p /exports
chmod 770 /exports
chown nfsnobody:nfsnobody /exports
oc project default

for i in $(seq 1 $COUNT); do
    PV=$(cat <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv$(printf %04d $i)
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: $SERVER
    path: /exports/pv$(printf %04d $i)
EOF
)
    echo "$PV" | oc create -f -
    mkdir -p /exports/pv$(printf %04d $i)
    chown nfsnobody:nfsnobody /exports/pv$(printf %04d $i)
    chmod 770 /exports/pv$(printf %04d $i)
done
```

## Deploy docker-registry with PV

```
oc project default
mkdir -p /exports/registry
chown nfsnobody:nfsnobody /exports/registry
chmod 770 /exports/registry
oc create -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: registry
spec:
  capacity:
    storage: 500Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  nfs:
    server: $SERVER
    path: /exports/registry
EOF
oadm registry --selector="region=infra" --config=/etc/origin/master/admin.kubeconfig --service-account=registry --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'
oc volume dc docker-registry --add --name=registry-storage -t pvc --claim-name=registry --claim-mode=ReadWriteMany --claim-size=500Gi --mount-path=/registry --overwrite
```

## Enabling Cluster Metrics

No PV example.

```
HAWKULAR_METRICS_HOSTNAME=

oc project openshift-infra
oc secrets new metrics-deployer nothing=/dev/null
oc create -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
EOF
oadm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster
oc process -f /usr/share/openshift/examples/infrastructure-templates/enterprise/metrics-deployer.yaml -v HAWKULAR_METRICS_HOSTNAME=$HAWKULAR_METRICS_HOSTNAME,USE_PERSISTENT_STORAGE=false,REDEPLOY=true | oc create -f -

echo "Make sure to add the follwoing to the master-config.xml and restart master. Note the URL should end with '/hawkular/metrics'"
echo "metricsPublicURL: https://$HAWKULAR_METRICS_HOSTNAME/hawkular/metrics"
```

## Aggregating Container Logs

No PV example.

For 3.3:

```
SUBDOMAIN=
ENABLE_OPS_CLUSTER=false
KIBANA_HOSTNAME=kibana.$SUBDOMAIN
PUBLIC_MASTER_URL=https://$(hostname):8443
KIBANA_OPS_HOSTNAME=kibana-ops.$SUBDOMAIN

oadm new-project logging --node-selector=""
oc project logging
oc new-app logging-deployer-account-template
oadm policy add-cluster-role-to-user oauth-editor system:serviceaccount:logging:logging-deployer
oadm policy add-scc-to-user privileged system:serviceaccount:logging:aggregated-logging-fluentd
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:logging:aggregated-logging-fluentd
oc label node --all logging-infra-fluentd=true
oc create configmap logging-deployer \
  --from-literal kibana-hostname=$KIBANA_HOSTNAME \
  --from-literal enable-ops-cluster=$ENABLE_OPS_CLUSTER \
  --from-literal kibana-ops-hostname=$KIBANA_OPS_HOSTNAME \
  --from-literal public-master-url=$PUBLIC_MASTER_URL \
  --from-literal es-cluster-size=1 \
  --from-literal es-instance-ram=8G
oc new-app logging-deployer-template

echo "Make sure to add the follwoing to the master-config.xml and restart master."
echo "loggingPublicURL: https://$KIBANA_HOSTNAME/"
```

For 3.2 or lower:

```
SUBDOMAIN=
ENABLE_OPS_CLUSTER=false
KIBANA_HOSTNAME=kibana.$SUBDOMAIN
PUBLIC_MASTER_URL=https://$(hostname):8443
KIBANA_OPS_HOSTNAME=kibana-ops.$SUBDOMAIN

oadm new-project logging --node-selector=""
oc project logging
oc secrets new logging-deployer nothing=/dev/null
oc create -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: logging-deployer
secrets:
- name: logging-deployer
EOF
oc policy add-role-to-user edit system:serviceaccount:logging:logging-deployer
oadm policy add-scc-to-user privileged system:serviceaccount:logging:aggregated-logging-fluentd
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:logging:aggregated-logging-fluentd
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:logging:aggregated-logging-fluentd
oc process logging-deployer-template -n openshift -v KIBANA_HOSTNAME=$KIBANA_HOSTNAME,ES_CLUSTER_SIZE=1,PUBLIC_MASTER_URL=$PUBLIC_MASTER_URL,ENABLE_OPS_CLUSTER=$ENABLE_OPS_CLUSTER,KIBANA_OPS_HOSTNAME,$KIBANA_OPS_HOSTNAME | oc create -f -

echo "Make sure to add the follwoing to the master-config.xml and restart master."
echo "loggingPublicURL: https://$KIBANA_HOSTNAME/"
```

For 3.2.0, https://access.redhat.com/solutions/2339271:

```
oc new-app logging-support-template
oc import-image logging-elasticsearch:3.2.0 --from registry.access.redhat.com/openshift3/logging-elasticsearch:3.2.0
oc import-image logging-auth-proxy:3.2.0    --from registry.access.redhat.com/openshift3/logging-auth-proxy:3.2.0
oc import-image logging-kibana:3.2.0        --from registry.access.redhat.com/openshift3/logging-kibana:3.2.0
oc import-image logging-fluentd:3.2.0       --from registry.access.redhat.com/openshift3/logging-fluentd:3.2.0
```

## Pruning

You need to create a user and add `system:image-pruner` role to the user.

```
oadm policy add-cluster-role-to-user system:image-pruner pruner
```

```
oc login -u "system:admin"
oadm prune deployments --confirm
oadm prune builds --confirm
oc login -u pruner
oadm prune images --confirm
oc login -u "system:admin"
```

## Manage nodes using Ansible ad-hoc command

```
ansible masters -a "sudo systemctl restart atomic-openshift-master"
ansible nodes -a "sudo systemctl restart atomic-openshift-node"
```

## Playbooks

```
ansible-playbook -vvv /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml
ansible-playbook -vvv /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
ansible-playbook -vvv /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-cluster/upgrades/v3_3/upgrade.yml
ansible-playbook -vvv /usr/share/ansible/openshift-ansible/playbooks/byo/openshift_facts.yml
```