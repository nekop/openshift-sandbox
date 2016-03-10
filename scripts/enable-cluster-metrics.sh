#!/bin/bash

oc create -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
API
oadm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster
oc secrets new metrics-deployer nothing=/dev/null
oc process -f /usr/share/openshift/examples/infrastructure-templates/enterprise/metrics-deployer.yaml -v HAWKULAR_METRICS_HOSTNAME=hawkular-metrics.apps.shift.nekop.io,USE_PERSISTENT_STORAGE=false | oc create -f -

