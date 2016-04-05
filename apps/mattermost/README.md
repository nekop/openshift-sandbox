# Mattermost for OpenShift Enterprise 3

This is instant mattermost application for OpenShift Enterprise 3.

```
oc new-project mattermost
oc project mattermost
oc new-app -f https://raw.githubusercontent.com/goern/openshift-sandbox/master/apps/mattermost/mattermost.yaml
```

You need to provision a PV:
```
# cat mattermost-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  nfs:
    path: /srv/nfs/path
    server: nfs-server
  persistentVolumeReclaimPolicy: Retain

# oc create -f mattermost-pv.yaml
```

and a route:

`oc expose service/mattermost --hostname=mattermost.example.com`
