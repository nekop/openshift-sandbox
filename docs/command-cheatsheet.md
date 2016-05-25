# OpenShift Enterprise command cheat sheet

## List project

```
oc get project
```

## View all in a project

```
oc get all
```

- buildconfig
- build
- imagestream
- deploymentconfig
- replicationcontroller
- service
- pod

`pvc` is not included in the `all`, so you may want `oc get all,pvc` sometimes.

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
oc get node       > oc-get-node.txt
oc describe node  > oc-describe-node.txt
oc get hostsubnet > oc-get-hostsubnet.txt
oc get event      > oc-get-event-default.txt
oc get all,pvc -o wide   > oc-get-all-default.txt
oc get all,pvc -o yaml   > oc-get-all-yaml-default.txt
openshift ex diagnostics > openshift-ex-diagnostics.txt
```

Get docker-registry and router logs by `oc get logs $POD_NAME` if needed.

As a root:

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

## Enabling Cluster Metrics


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
