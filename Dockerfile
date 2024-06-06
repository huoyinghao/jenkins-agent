FROM --platform=linux/amd64 ubuntu:22.04 as build
ENV JENKINS_HOME /var/jenkins_home
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get update -y && apt-get --no-install-recommends install wget default-jre ca-certificates maven bzip2 openssh-server openssh-client vim -y
RUN wget -qP /tmp https://github.com/jenkins-zh/jenkins-cli/releases/latest/download/jcli-linux-amd64.tar.gz
RUN tar -xzf /tmp/jcli-linux-amd64.tar.gz -C /usr/local/bin
RUN wget -qP /tmp https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -jxf /tmp/phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /tmp
RUN mv /tmp/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
COPY formula.yaml /
COPY remove-bundle-plugins.groovy /
WORKDIR /
RUN jcli cwp --install-artifacts --config-path formula.yaml

FROM jenkins/jenkins:2.413
COPY --from=build /tmp/output/target/daocloud-jenkins-1.0-SNAPSHOT.war /usr/share/jenkins/jenkins.war

USER root
RUN adduser git
RUN git init --bare $JENKINS_HOME/amamba-shared-lib-bare.git
RUN chown -R git:git $JENKINS_HOME/amamba-shared-lib-bare.git
# 后续需要把groovy脚本挂载到 $JENKINS_HOME/amamba-shared-lib这个目录中
RUN git clone $JENKINS_HOME/amamba-shared-lib-bare.git $JENKINS_HOME/amamba-shared-lib
RUN git config --global user.email "amamba" && git config --global user.name "amamba"
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENTRYPOINT ["tini", "--", "/usr/local/bin/jenkins.sh"]
