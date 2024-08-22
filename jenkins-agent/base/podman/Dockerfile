ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest

RUN rm -rf /usr/bin/docker && yum -y install podman fuse-overlayfs && ln -s /usr/bin/podman /usr/bin/docker

COPY ./jenkins-agent/base/storage.conf /etc/containers/storage.conf

COPY ./jenkins-agent/base/containers.conf /etc/containers/containers.conf

COPY ./jenkins-agent/base/registries.conf /etc/containers/registries.conf

VOLUME /var/lib/containers

CMD ["podman", "info"]