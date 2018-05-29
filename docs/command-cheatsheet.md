# OpenShift command cheat sheet

This is command cheat sheet for OpenShift.

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

## Delete all in project

```
oc delete all --all
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
oc logs $POD_NAME --timestamps
```

## Get CrashLoop pod log

```
oc logs -p $POD_NAME --timestamps
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

## Allow access to OpenShift API from default application service account

```
oc policy add-role-to-user view -z default
```

## Debug

```
oc debug dc $DC_NAME
oc debug dc $DC_NAME --as-root=true
oc debug dc $DC_NAME --node-name=$NODENAME
```

## Mount PVC used by other pod for maintenance

```
oc run sleep --image=registry.access.redhat.com/rhel7 -- tail -f /dev/null
oc volume dc/sleep --add -t pvc --name=test --claim-name=test --mount-path=/test
oc rsh sleep-X-XXXXX
oc delete all -l app=sleep
```

## Get metrics

```
oc adm top pod --heapster-namespace=openshift-infra --heapster-scheme=https
```

## Troubleshoot OpenShift

For infrastructure level issues, get sosreport, logs and configs as root user:

```
# Make sure to install or update sos latest version
rpm -q sos || yum install sos -y; rpm -q sos && yum update sos -y
sosreport -k docker.all=on -k docker.logs=on
```

To get only openshift logs and configs:

```
journalctl | gzip > $(hostname)-journal-$(date +%Y%m%d%H%M%S).log.gz
tar czf $(hostname)-openshift-config.tar.gz /etc/origin /etc/sysconfig/atomic-openshift-*  /etc/sysconfig/docker* /etc/etcd
```

For project, use OpenShift sos plugin (for v3.7+) <https://github.com/bostrt/openshift-sos-plugin>.

Or use the following shell script:

```
#!/bin/bash

# dump-project.sh PROJECT_NAME

# If you prefer multiple files, you can split it:
#   zcat *.txt.gz | awk 'BEGIN{f=""}  match($0, /^+ ((oc|date).*)$/, a){f=a[1] ".txt"; gsub(/[ \/=]/,"_",f);} {print $0 >> f}'

PROJECT=$1

if [ -z $PROJECT ]; then
  echo "Usage: $0 PROJECT_NAME"
  exit 1
fi

DEST=$PROJECT-$(date +%Y%m%d%H%M%S).txt.gz
(
  set -x
  date
  oc whoami
  oc project $PROJECT
  oc version
  oc status -v
  oc get project $PROJECT -o yaml
  oc get all,pvc,hpa,quota,limits,sa,rolebinding,secret -o wide
  oc get daemonset,configmap -o wide # separated because not supported in v3.1
  oc get all,pvc,hpa,quota,limits,sa,rolebinding,secret -o yaml
  oc get daemonset,configmap -o yaml
  timeout 15 oc get event -w &
  PODS=$(oc get pod -o name)
  for pod in $PODS; do
    CONTAINERS=$(oc get $pod --template='{{range .spec.containers}}{{.name}}
{{end}}')
    for c in $CONTAINERS; do
      oc logs $pod --container=$c --timestamps
      oc logs -p $pod --container=$c --timestamps
    done
  done
  # if admin get additional info
  if [ "$(oc policy can-i get nodes)" == "yes" ]; then
    oc get node -o wide
    oc get node -o yaml
    oc describe node
    oc get hostsubnet
    oc get clusterrolebindings
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
oc set resources deployment nginx --limits=cpu=200m,memory=512Mi --requests=cpu=100m,memory=256Mi
```

## Define livenessProve and readinessProve in DeploymentConfig

```
oc set probe dc/nginx --readiness --get-url=http://:8080/healthz --initial-delay-seconds=10
oc set probe dc/nginx --liveness --get-url=http://:8080/healthz --initial-delay-seconds=10
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

## Pruning

You need to create a user and add `system:image-pruner` role to the user.

```
oc adm policy add-cluster-role-to-user system:image-pruner pruner
```

```
oc login -u "system:admin"
oc adm prune deployments --confirm
oc adm prune builds --confirm
oc login -u pruner
oc adm prune images --confirm
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

