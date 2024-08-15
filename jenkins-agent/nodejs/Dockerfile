ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME
COPY ./ ./
ARG VERSION
ENV NODE_VERSION $VERSION

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN node -v
RUN npm -v