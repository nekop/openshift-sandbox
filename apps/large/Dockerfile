FROM registry.access.redhat.com/rhel7/rhel-tools:latest
MAINTAINER Takayoshi Kimura <tkimura@redhat.com>
RUN dd if=/dev/zero of=filename bs=1024 count=2500K
EXPOSE 2000
ENTRYPOINT nc -vv -l 2000 -k -c 'xargs -n1 echo'
