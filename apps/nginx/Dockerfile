FROM registry.access.redhat.com/rhel7/rhel:latest
MAINTAINER Takayoshi Kimura <tkimura@redhat.com>

COPY nginx.repo /etc/yum.repos.d/nginx.repo
COPY nginx.conf /etc/nginx/nginx.conf
RUN yum install -y --setopt=tsflags=nodocs --disablerepo=\* --enablerepo=rhel-7-server-rpms --enablerepo=nginx nginx && \
    yum clean all && \
    mkdir -p /var/lib/nginx && chmod -R 777 /var/lib/nginx && \
    mkdir -p /var/log/nginx && chmod -R 777 /var/log/nginx && \
    mkdir -p /var/cache/nginx && chmod -R 777 /var/cache/nginx && \
    mkdir -p /var/run/nginx && chmod -R 777 /var/run/nginx

USER 432879
EXPOSE 8080
CMD [ "nginx" ]

