#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -x

ARCH=$(uname -m)
echo $ARCH

function install_docker() {
  DOCKER_VERSION=$1
  echo "Installing docker ${DOCKER_VERSION}"
  if [[ ${ARCH} == 'x86_64' || ${ARCH} == 'aarch64' ]]; then
      curl -f https://download.docker.com/linux/static/stable/${ARCH}/docker-$DOCKER_VERSION.tgz | tar xvz
      mv docker/docker /usr/bin/
      rm -rf docker
  else
      echo "docker do not support this arch"
      exit 1
  fi
}

function install_helm() {
  HELM3_VERSION=$1
  echo "Installing helm ${HELM3_VERSION}"
  if [[ ${ARCH} == 'x86_64' ]]; then
      ARCH_PATH="amd64"
  elif [[ ${ARCH} == 'aarch64' ]]; then
      ARCH_PATH="arm64"
  else
      echo "helm do not support this arch"
      exit 1
  fi
  curl -f https://get.helm.sh/helm-v${HELM3_VERSION}-linux-${ARCH_PATH}.tar.gz | tar xzv
  mv linux-${ARCH_PATH}/helm /usr/bin/helm
  rm -rf linux-${ARCH_PATH}
}

function install_helm_plugins() {
  echo "Installing helm plugin: helm-push"
  helm plugin install https://github.com/chartmuseum/helm-push
}

function install_kubectl() {
  version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  echo "Installing kubectl ${version}"
  if [[ ${ARCH} == 'x86_64' ]]; then
      ARCH_PATH="amd64"
  elif [[ ${ARCH} == 'aarch64' ]]; then
      ARCH_PATH="arm64"
  else
      echo "kubectl do not support this arch"
      exit 1
  fi

  curl -f -LO https://storage.googleapis.com/kubernetes-release/release/${version}/bin/linux/${ARCH_PATH}/kubectl
  chmod +x kubectl
  mv kubectl /usr/bin/
  kubectl --help
}

# install specific java version for sonarqube cli
function install_java11() {
  JAVA_VERSION=11.0.14.9.1
  echo "Installing java $JAVA_VERSION"
  if [[ ${ARCH} == 'x86_64' ]]; then
      ARCH_PATH="x64"
  elif [[ ${ARCH} == 'aarch64' ]]; then
      ARCH_PATH="aarch64"
  else
      echo "java do not support this arch"
      exit 1
  fi

  curl -fLo jdk-11.0.14.tar.gz https://aka.ms/download-jdk/microsoft-jdk-${JAVA_VERSION}-linux-${ARCH_PATH}.tar.gz
  tar zxf jdk-11.0.14.tar.gz
  rm -rf jdk-11.0.14.tar.gz
  mv jdk-11.0.14+9 /opt/java-11.0.14
}

function install_argocd_cli() {
  ARGOCD_CLI_VERSION=$1
  echo "Installing argocd cli ${ARGOCD_CLI_VERSION}"
  if [[ ${ARCH} == 'x86_64' ]]; then
      ARCH_PATH="amd64"
  elif [[ ${ARCH} == 'aarch64' ]]; then
      ARCH_PATH="arm64"
  else
      echo "argocd cli do not support this arch"
      exit 1
  fi

  curl -sSL -o argocd-linux-${ARCH_PATH} https://github.com/argoproj/argo-cd/releases/${ARGOCD_CLI_VERSION}/download/argocd-linux-${ARCH_PATH}
  install -m 555 argocd-linux-${ARCH_PATH} /usr/local/bin/argocd
  rm argocd-linux-${ARCH_PATH}
}

function install_argo_rollouts_cli() {
  ARGO_ROLLOUT_CLI_VERSION=$1
  echo "Installing argo rollouts cli ${ARGO_ROLLOUT_CLI_VERSION}"
  if [[ ${ARCH} == 'x86_64' ]]; then
      ARCH_PATH="amd64"
  elif [[ ${ARCH} == 'aarch64' ]]; then
      ARCH_PATH="arm64"
  else
      echo "argo rollouts cli do not support this arch"
      exit 1
  fi

  curl -LO https://github.com/argoproj/argo-rollouts/releases/${ARGO_ROLLOUT_CLI_VERSION}/download/kubectl-argo-rollouts-linux-${ARCH_PATH}
  chmod +x ./kubectl-argo-rollouts-linux-${ARCH_PATH}
  mv ./kubectl-argo-rollouts-linux-${ARCH_PATH} /usr/local/bin/kubectl-argo-rollouts
}

function install_yq() {
  YQ_VERSION=$1
  echo "Installing yq ${YQ_VERSION}"
  if [[ ${ARCH} == 'x86_64' ]]; then
      ARCH_PATH="amd64"
  elif [[ ${ARCH} == 'aarch64' ]]; then
      ARCH_PATH="arm64"
  else
      echo "argocd cli do not support this arch"
      exit 1
  fi

  wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${ARCH_PATH} -O /usr/bin/yq
  chmod +x /usr/bin/yq
  yq --version
}

function install_kustomize() {
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash && mv kustomize /usr/bin/ && kustomize version
}

install_docker 27.1.2
install_helm 3.15.4
install_helm_plugins
install_kubectl
install_java11
install_argocd_cli v2.12.1
install_argo_rollouts_cli v1.7.2
install_yq v4.44.3
install_kustomize