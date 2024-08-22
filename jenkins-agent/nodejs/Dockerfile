ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME
COPY ./ ./
ARG VERSION
ENV NODE_VERSION $VERSION

RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash -
RUN yum install nodejs-${VERSION} -y
RUN node -v
RUN npm -v