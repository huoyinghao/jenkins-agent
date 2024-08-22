#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -x

ARCH=$(uname -m)
echo $ARCH

if [[ ${EXCLUDE_DOCKER} != '1' ]]; then
  # Docker
  DOCKER_VERSION=27.1.2
  if [[ ${ARCH} == 'x86_64' ]]; then
    curl -f https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz | tar xvz && \
    mv docker/docker /usr/bin/ && \
    rm -rf docker
  elif [[ ${ARCH} == 'aarch64' ]]
  then
    curl -f https://download.docker.com/linux/static/stable/aarch64/docker-$DOCKER_VERSION.tgz | tar xvz && \
    mv docker/docker /usr/bin/ && \
    rm -rf docker
  else
    echo "do not support this arch"
    exit 1
  fi
fi

# Helm
HELM3_VERSION=3.15.4
JAVA_VERSION=11.0.14.9.1
if [[ ${ARCH} == 'x86_64' ]]; then
  curl -f https://get.helm.sh/helm-v${HELM3_VERSION}-linux-amd64.tar.gz | tar xzv && \
  mv linux-amd64/helm /usr/bin/helm && \
  rm -rf linux-amd64
elif [[ ${ARCH} == 'aarch64' ]]
then
  curl -f https://get.helm.sh/helm-v${HELM3_VERSION}-linux-arm64.tar.gz | tar xzv && \
  mv linux-arm64/helm /usr/bin/helm && \
  rm -rf linux-arm64
else
  echo "do not support this arch"
  exit 1
fi

helm plugin install https://github.com/chartmuseum/helm-push

# kubectl

if [[ ${ARCH} == 'x86_64' ]]; then
  curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
elif [[ ${ARCH} == 'aarch64' ]]
then
  curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/arm64/kubectl
else
  echo "do not support this arch"
  exit 1
fi

chmod +x kubectl && \
mv kubectl /usr/bin/ && \
kubectl --help

# install java
if [[ ${ARCH} == 'x86_64' ]]; then
  curl -fLo jdk-11.0.14.tar.gz https://aka.ms/download-jdk/microsoft-jdk-${JAVA_VERSION}-linux-x64.tar.gz
elif [[ ${ARCH} == 'aarch64' ]]
then
  curl -fLo jdk-11.0.14.tar.gz https://aka.ms/download-jdk/microsoft-jdk-${JAVA_VERSION}-linux-${ARCH}.tar.gz
else
  echo "do not support this arch"
  exit 1
fi

tar zxf jdk-11.0.14.tar.gz && \
rm -rf jdk-11.0.14.tar.gz && \
mv jdk-11.0.14+9 /opt/java-11.0.14


# argocd cli
ARGOCD_CLI_VERSION=v2.12.1
if [[ ${ARCH} == 'x86_64' ]]; then
  curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/${ARGOCD_CLI_VERSION}/download/argocd-linux-amd64
  install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
  rm argocd-linux-amd64
elif [[ ${ARCH} == 'aarch64' ]]
then
  curl -sSL -o argocd-linux-arm64 https://github.com/argoproj/argo-cd/releases/${ARGOCD_CLI_VERSION}/download/argocd-linux-arm64
  install -m 555 argocd-linux-arm64 /usr/local/bin/argocd
  rm argocd-linux-arm64
else
  echo "argocd cli do not support this arch"
  exit 1
fi

# argo-rollouts
ARGO_ROLLOUT_CLI_VERSION=v1.7.2
if [[ ${ARCH} == 'x86_64' ]]; then
  curl -LO https://github.com/argoproj/argo-rollouts/releases/${ARGO_ROLLOUT_CLI_VERSION}/download/kubectl-argo-rollouts-linux-amd64
  chmod +x ./kubectl-argo-rollouts-linux-amd64
  mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
elif [[ ${ARCH} == 'aarch64' ]]
then
  curl -LO https://github.com/argoproj/argo-rollouts/releases/${ARGO_ROLLOUT_CLI_VERSION}/download/kubectl-argo-rollouts-linux-arm64
  chmod +x ./kubectl-argo-rollouts-linux-arm64
  mv ./kubectl-argo-rollouts-linux-arm64 /usr/local/bin/kubectl-argo-rollouts
else
  echo "argo rollouts cli do not support this arch"
  exit 1
fi

# yq
YQ_VERSION=v4.44.3
if [[ ${ARCH} == 'x86_64' ]]; then
  wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq && yq --version
elif [[ ${ARCH} == 'aarch64' ]]
then
  wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_arm64 -O /usr/bin/yq && chmod +x /usr/bin/yq && yq --version
else
  echo "yq do not support this arch"
  exit 1
fi

# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash && mv kustomize /usr/bin/ && kustomize version
