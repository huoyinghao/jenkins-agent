ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME

COPY jenkins-agent/base/ ./
ENV DEBIAN_FRONTEND=noninteractive
ARG VERSION
ENV PYTHON_VERSION_FULL=python$VERSION
ENV PYTHON_VERSION=${PYTHON_VERSION_FULL%.*}

RUN ansible-playbook ./ansible/install_packages.yaml -e python_version=$VERSION -vvv
CMD ["python","--version"]
