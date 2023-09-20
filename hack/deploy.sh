#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

source hack/util.sh

# specific a helm package version
CHART_VERSION=${1:-}
KUBE_CONF=${2:-"/root/.kube/config"}
TARGET_NS=${3:-"jenkins"}

LOCAL_RELEASE_NAME=jenkins
values="-f config/e2e.yaml"

# If CHART_VERSION is empty, then use the local chart package
if [[ -n "${CHART_VERSION}" ]]; then
    values="${values} --version ${CHART_VERSION}"
fi

# install or upgrade
set -x

helm upgrade --install  --create-namespace --cleanup-on-fail \
      ${LOCAL_RELEASE_NAME}  charts/ \
      ${values} \
      -n "${TARGET_NS}" \
      --kubeconfig "${KUBE_CONF}"

set +x

# check it
helm list -n "${TARGET_NS}" --kubeconfig ${KUBE_CONF}

util::wait_pod_ready "${LOCAL_RELEASE_NAME}" "${TARGET_NS}" 600s