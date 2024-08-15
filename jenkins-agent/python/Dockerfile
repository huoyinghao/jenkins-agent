ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME


RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    python3 -m pip install --upgrade --force-reinstall --no-cache-dir pip && \
    rm -rf /usr/bin/python &&  \
    cp /usr/bin/python3 /usr/bin/python

CMD ["python","--version"]
