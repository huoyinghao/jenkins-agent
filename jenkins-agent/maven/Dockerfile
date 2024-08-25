ARG RUNTIME
ARG REGISTRY_REPO
FROM $REGISTRY_REPO/jenkins-agent-base:latest$RUNTIME

COPY jenkins-agent/base/ ./

ARG JAVA_VERSION
# install java and maven
RUN ansible-playbook ./ansible/install_packages.yaml -vvv -e java_version=$JAVA_VERSION

# maven
ENV MAVEN_VERSION 3.9.9
ENV M2_HOME /opt/apache-maven-$MAVEN_VERSION
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH:$JAVA_HOME/bin

# Set JDK to be 32bit
COPY jenkins-agent/maven/set_java $M2
RUN chmod +x $M2/set_java && $M2/set_java && rm $M2/set_java

CMD ["mvn","-version"]