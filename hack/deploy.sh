#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

source hack/util.sh

# specific a jenkins and agent version
VERSION=${1:-"v0.2.1"}
KUBE_CONF=${2:-"/root/.kube/config"}
TARGET_NS=${3:-"jenkins"}

LOCAL_RELEASE_NAME=jenkins

echo "Rendering values.yaml with VERSION=${VERSION}"
envsubst -i config/e2e.yaml -o /tmp/e2e.yaml

values="-f /tmp/e2e.yaml"

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