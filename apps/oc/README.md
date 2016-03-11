oc new-app https://github.com/nekop/openshift-sandbox --context-dir=apps/oc --name oc

This doesn't work:

No package atomic-openshift-clients-redistributable available.
Error: Nothing to do
F0311 03:58:11.374217       1 builder.go:185] Error: build error: The command '/bin/sh -c yum install -y atomic-openshift-clients-redistributable && yum clean all && mkdir -p /opt/oc && cp -r /usr/share/atomic-openshift/* /opt/oc && chmod -R 777 /opt/oc' returned a non-zero code: 1

