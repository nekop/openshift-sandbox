FROM registry.access.redhat.com/openshift3/ose-haproxy-router:v3.1.1.6

MAINTAINER Takayoshi Kimura <tkimura@redhat.com>

ADD conf/ /var/lib/haproxy/conf/
ADD reload-haproxy /var/lib/haproxy/reload-haproxy
ENTRYPOINT ["/usr/bin/openshift-router"]