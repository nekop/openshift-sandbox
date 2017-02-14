FROM registry.access.redhat.com/rhel7/rhel:latest
MAINTAINER Takayoshi Kimura <tkimura@redhat.com>

COPY nginx.repo /etc/yum.repos.d/nginx.repo
COPY nginx.conf /opt/nginx/nginx.conf
RUN yum install -y --setopt=tsflags=nodocs --disablerepo=\* --enablerepo=rhel-7-server-rpms --enablerepo=nginx nginx && \
    yum clean all && \
    chmod 777 /opt/nginx

WORKDIR /opt/nginx

USER 432879
EXPOSE 8080
CMD [ "nginx", "-c", "/opt/nginx/nginx.conf" ]

