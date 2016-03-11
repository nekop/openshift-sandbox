FROM registry.access.redhat.com/rhel7/rhel:latest
MAINTAINER Takayoshi Kimura <tkimura@redhat.com>
RUN yum install -y atomic-openshift-clients-redistributable && yum clean all && mkdir -p /opt/oc && cp -r /usr/share/atomic-openshift/* /opt/oc && chmod -R 777 /opt/oc
WORKDIR /opt/oc
USER 432879
EXPOSE 8000
ENTRYPOINT python -m SimpleHTTPServer 8000
