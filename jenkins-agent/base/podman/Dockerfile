ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest

RUN rm -rf /usr/bin/docker && apt-get update && apt-get install -y podman && ln -s /usr/bin/podman /usr/bin/docker

COPY ./jenkins-agent/base/storage.conf /etc/containers/storage.conf

COPY ./jenkins-agent/base/containers.conf /etc/containers/containers.conf

COPY ./jenkins-agent/base/registries.conf /etc/containers/registries.conf

VOLUME /var/lib/containers

#COPY ./jenkins-agent/base ./
#RUN chmod +x ./hack/install_podman.sh && ./hack/install_podman.sh

CMD ["podman", "info"]