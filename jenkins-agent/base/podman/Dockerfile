ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest

COPY jenkins-agent/base/ ./
COPY ./jenkins-agent/base/storage.conf /etc/containers/storage.conf
COPY ./jenkins-agent/base/containers.conf /etc/containers/containers.conf
COPY ./jenkins-agent/base/registries.conf /etc/containers/registries.conf
VOLUME /var/lib/containers

RUN ansible-playbook ./ansible/install_packages.yaml -vvv -e install_podman=true
CMD ["podman", "info"]