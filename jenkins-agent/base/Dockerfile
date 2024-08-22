FROM --platform=$BUILDPLATFORM golang:1.22.2 AS build

ENV GO111MODULE=on
WORKDIR /app
COPY ./tools ./tools
COPY go.mod go.sum ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -o docker-build ./tools/docker-build

FROM oraclelinux:9

RUN yum install -y  \
        make \
        yum-utils \
        gcc \
        gcc-c++ \
        libcurl-devel \
        openssl-devel \
        wget \
        git \
        curl \
        autoconf \
        zip \
        unzip \
        jq \
        glibc-locale-source \
        glibc-langpack-en \
        glibc-common \
        vim \
        gettext


# CentOS 7 is EOL, replace the mirror
#RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo && \
#    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo && \
#    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo && \
#    echo "sslverify=false" >> /etc/yum.conf && \
#    yum makecache

#RUN yum install -y epel-release ca-certificates && \
#    yum install -y make wget git gcc gcc-c++ curl-devel autoconf openssl-devel && \
#    yum -y clean all --enablerepo='*' && \
#    yum update -y

# make Used to compile binary
# wget Compressed package for downloading related components
# git Used to pull the corresponding code from the code warehouse
# gcc gcc-c++ Provide C environment for compiling binary
# curl-devel curl-devel autoconf openssl-devel Used to provide basic communication services for binary system
# unused temporary...
# unzip zip which bzip2 expat-devel gettext-devel perl-devel zlib-devel

# Set the locale(en_US.UTF-8)

# https://github.com/CentOS/sig-cloud-instance-images/issues/71
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 \
    EXCLUDE_DOCKER=0


# USER jenkins
WORKDIR /home/jenkins

COPY jenkins-agent/base/ ./

RUN chmod +x ./hack/install_utils.sh && \
    ./hack/install_utils.sh && \
    chmod +x ./hack/install_qemu.sh && \
    ./hack/install_qemu.sh

ENV SONAR_SCANNER_VERSION 4.8.0.2856
ENV PATH /opt/sonar-scanner-${SONAR_SCANNER_VERSION}/bin:$PATH
RUN yum -y install unzip && \
    curl -Lo sonar_scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
    unzip sonar_scanner.zip && rm sonar_scanner.zip && \
    mv /home/jenkins/sonar-scanner-${SONAR_SCANNER_VERSION} /opt/sonar-scanner-${SONAR_SCANNER_VERSION} && \
    sed -i '1 a JAVA_HOME=/opt/java-11.0.14' /opt/sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner

RUN sonar-scanner --version

COPY --from=build /app/docker-build  /bin/

CMD ["docker","version"]