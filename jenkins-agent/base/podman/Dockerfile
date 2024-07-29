ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest

RUN rm -rf /usr/bin/docker
# Install podman
COPY ./jenkins-agent/base ./
RUN chmod +x ./hack/install_podman.sh && ./hack/install_podman.sh

COPY ./jenkins-agent/base/storage.conf /etc/containers/storage.conf

COPY ./jenkins-agent/base/containers.conf /etc/containers/containers.conf

COPY ./jenkins-agent/base/registries.conf /etc/containers/registries.conf

VOLUME /var/lib/containers

CMD ["podman", "info"]