ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME

COPY ./ ./
ENV DEBIAN_FRONTEND=noninteractive
ARG VERSION
ENV PYTHON_VERSION_FULL=python$VERSION
ENV PYTHON_VERSION=${PYTHON_VERSION_FULL%.*}

RUN chmod +x ./hack/install_utils.sh && ./hack/install_utils.sh && rm -rf ./*
CMD ["python","--version"]
