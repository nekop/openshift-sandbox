FROM registry.access.redhat.com/rhel7/rhel:latest
MAINTAINER Takayoshi Kimura <tkimura@redhat.com>

RUN yum-config-manager --disable \* > /dev/null && \
    yum-config-manager --enable rhel-7-server-rpms --enable rhel-7-server-ose-3.1-rpms > /dev/null && \
    yum update-minimal -y --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
    yum install -y --setopt=tsflags=nodocs atomic-openshift-clients-redistributable && \
    yum clean all && \
    mkdir -p /opt/oc && \
    cp -r /usr/share/atomic-openshift/* /opt/oc && \
    chmod -R 777 /opt/oc

WORKDIR /opt/oc

USER 432879
EXPOSE 8000

# why is /opt/oc not the entrypoint?
ENTRYPOINT python -m SimpleHTTPServer 8000
