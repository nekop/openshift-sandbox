# OpenShift Enterprise 3.1.1.6 custom router image example

```
oc project default
oc new-app -f https://raw.githubusercontent.com/nekop/openshift-sandbox/master/custom-router/custom-router.yaml
oc edit dc router
```

In `oc edit dc router`, replace:

```
image: registry.access.redhat.com/openshift3/ose-haproxy-router:v3.1.1.6
```

with:

```
image: <your docker registry IP like 172.30.x.x>:5000/default/custom-router:latest
```

To reflect further changes:

```
oc start-build custom-router
oc deploy router --latest
```

Note that the router deployment config doesn't have ImageChange trigger by default, so we need to deploy it manually.