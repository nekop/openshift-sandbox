FROM registry.access.redhat.com/rhel7:latest
MAINTAINER Takayoshi Kimura <tkimura@redhat.com>
RUN yum-config-manager --disable \* > /dev/null && \
    yum-config-manager --enable rhel-7-server-rpms > /dev/null
RUN yum install -y tar && \
    yum clean all
RUN cd /opt && \
    curl -LO https://github.com/mattermost/platform/releases/download/v1.4.0/mattermost.tar.gz && \
    tar xf mattermost.tar.gz &&\
    rm mattermost.tar.gz && \
    chmod -R 777 /opt/mattermost
COPY mattermost-launch.sh /usr/local/bin/mattermost-launch.sh
COPY config.json /opt/mattermost/config/config.json
RUN chmod 777 /opt/mattermost/config/config.json
# Make sure we can run with random UID, even in standalone docker
USER 2273
EXPOSE 8065
CMD mattermost-launch.sh
