ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest

RUN rm -rf /usr/bin/docker &&  \
    apt-get update &&  \
    apt-get install -y podman &&  \
    ln -s /usr/bin/podman /usr/bin/docker &&  \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

COPY ./jenkins-agent/base/storage.conf /etc/containers/storage.conf
COPY ./jenkins-agent/base/containers.conf /etc/containers/containers.conf
COPY ./jenkins-agent/base/registries.conf /etc/containers/registries.conf

VOLUME /var/lib/containers

CMD ["podman", "info"]