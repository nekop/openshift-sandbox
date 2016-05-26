# OpenShift Enterprise command cheat sheet

This is command cheat sheet for OpenShift Enterprise (OSE).

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

## Troubleshoot OSE infrastructure

It includes docker, openshift services, node, docker-registry and router in default project

```
oc project default
oc version        > oc-version.txt
oc get node       > oc-get-node.txt
oc describe node  > oc-describe-node.txt
oc get hostsubnet > oc-get-hostsubnet.txt
oc get event      > oc-get-event-default.txt
oc get all,pvc -o wide   > oc-get-all-default.txt
oc get all,pvc -o yaml   > oc-get-all-yaml-default.txt
openshift ex diagnostics > openshift-ex-diagnostics.txt
```

Get docker-registry and router logs by `oc get logs $POD_NAME` if needed.

As root:

```
sosreport -e docker -k docker.all=on
journalctl -u atomic-openshift-master -u atomic-openshift-master-api -u atomic-openshift-master-controllers > `hostname`-openshift-master.log
journalctl -u atomic-openshift-node   > `hostname`-openshift-node.log
tar czf `hostname`-openshift-config.tar.gz /etc/origin /etc/sysconfig/atomic-openshift-*  /etc/sysconfig/docker*
```

## Troubleshoot specific project

```
oc project $PROJECT
oc get all,pvc -o wide > oc-get-all-$PROJECT.txt
oc get all,pvc -o yaml > oc-get-all-yaml-$PROJECT.txt
oc get event > oc-get-event-$PROJECT.txt
```

## Define resource requests and limits in DeploymentConfig

```
oc patch dc $DC_NAME -p 'spec:
  template:
    spec:
      resources:
        limits:
          cpu: 500m
          memory: 512Mi
        requests:
          cpu: 500m
          memory: 512Mi'
```

## Define Horizontal Pod Autoscaler (hpa)

```
oc create -f - <<EOF
apiVersion: extensions/v1beta1
kind: HorizontalPodAutoscaler
metadata:
  name: $HPA_NAME
spec:
  scaleRef:
    apiVersion: v1
    kind: DeploymentConfig
    name: $DC_NAME
    subresource: scale
  minReplicas: 1
  maxReplicas: 4
  cpuUtilization:
    targetPercentage: 10
```

## Define nodeSelector in DeploymentConfig

```
oc patch dc $DC_NAME -p 'spec:
  template:
    spec:
      nodeSelector:
        region: infra'
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
```

## Access heapster API

```
curl --cacert /etc/origin/master/ca.crt --cert /etc/origin/master/admin.crt --key /etc/origin/master/admin.key https://$MASTER_URL/api/v1/proxy/namespaces/openshift-infra/services/https:heapster:/api/v1/model/namespaces/default/pods/
```

https://github.com/kubernetes/heapster/blob/master/docs/model.md

## Access Hawkular Metrics API

Direct access to Hawkular Metrics API is not officially supported. We can use `-k` instead of `--cacert ...`. The `$METRICS_ID` can be extracted from the first 2 examples, "id" field.

```
curl --cacert /etc/origin/master/ca.crt -H "Authorization: Bearer $(oc whoami -t)" -H 'Hawkular-Tenant: $PROJECT' https://$HAWKULAR_METRICS_HOSTNAME/hawkular/metrics/metrics?type=gauge | python -mjson.tool
curl --cacert /etc/origin/master/ca.crt -H "Authorization: Bearer $(oc whoami -t)" -H 'Hawkular-Tenant: $PROJECT' https://$HAWKULAR_METRICS_HOSTNAME/hawkular/metrics/metrics?type=counter | python -mjson.tool
curl --cacert /etc/origin/master/ca.crt -H "Authorization: Bearer $(oc whoami -t)" -H 'Hawkular-Tenant: $PROJECT' https://$HAWKULAR_METRICS_HOSTNAME/hawkular/metrics/counters/$(perl -MURI::Escape -e 'print uri_escape($ARGV[0])' $METRICS_ID)/data?bucketDuration=1d | python -m json.tool
```

## Dump etcd

```
curl --cacert /etc/origin/master/ca.crt --cert /etc/origin/master/master.etcd-client.crt --key /etc/origin/master/master.etcd-client.key https://`hostname`:4001/v2/keys/?recursive=true > etcd.dump
cat etcd.dump | python -mjson.tool > etcd.dump.pretty
```

## Setup NFS on master node

```
mkdir -p /exports
chown -R nfsnobody:nfsnobody /exports
chmod 770 /exports/
sh -c "cat << EOM > /etc/exports
/exports *(rw,sync,root_squash)
EOM"
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT
service iptables save
systemctl enable nfs-server
systemctl restart nfs-server
```

## Create PVs on master node

```
SERVER=`hostname`
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
done
```

## Deploy docker-registry with PV

```
oc project default
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
oc create -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: registry
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 500Gi
EOF
oadm registry --selector="region=infra" --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --replicas=1 --service-account=registry
oc volume deploymentconfigs/docker-registry --add --name=registry-storage -t pvc --claim-name=registry --overwrite
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

```
KIBANA_HOSTNAME=
PUBLIC_MASTER_URL=

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
oc process logging-deployer-template -n openshift -v KIBANA_HOSTNAME=$KIBANA_HOSTNAME,ES_CLUSTER_SIZE=1,PUBLIC_MASTER_URL=$PUBLIC_MASTER_URL | oc create -f -

echo "Make sure to add the follwoing to the master-config.xml and restart master."
echo "loggingPublicURL: https://$KIBANA_HOSTNAME/"
```
