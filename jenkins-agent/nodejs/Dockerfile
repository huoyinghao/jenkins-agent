ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME
COPY jenkins-agent/base/ ./
ARG VERSION

ENV NVM_DIR /root/.nvm
ENV SHIPPABLE_NODE_VERSION=$VERSION
ENV PATH $NVM_DIR/versions/node/v$VERSION/bin:$PATH

RUN ansible-playbook ./ansible/install_packages.yaml -e node_version=$VERSION -vvv
CMD ["node","--version"]