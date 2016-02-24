FROM registry.access.redhat.com/rhel7/rhel-tools:latest
MAINTAINER Takayoshi Kimura <tkimura@redhat.com>
RUN cat /etc/resolv.conf
RUN ip a && ip r && dig www.google.com
EXPOSE 2000
ENTRYPOINT nc -vv -l 2000 -k -c 'xargs -n1 echo'
