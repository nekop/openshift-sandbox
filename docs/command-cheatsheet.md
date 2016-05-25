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
