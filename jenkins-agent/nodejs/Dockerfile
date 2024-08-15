ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME
COPY ./ ./
ARG VERSION
ENV NODE_VERSION=$VERSION

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

ENV NVM_DIR /root/.nvm
ENV SHIPPABLE_NODE_VERSION=$NODE_VERSION
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN . "$NVM_DIR/nvm.sh" && \
        nvm install $NODE_VERSION && \
        nvm alias default $NODE_VERSION && \
        nvm use default

RUN node -v && npm -v