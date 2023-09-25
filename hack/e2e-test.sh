#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

KIND_IMAGE=${KIND_IMAGE:-"kindest/node:v1.26.0"}
KIND_KUBECONFIG=${KIND_KUBECONFIG:-"/root/.kube/config"}

source hack/util.sh

util::create_cluster "jenkins-e2e-test"  "${KIND_KUBECONFIG}" "${KIND_IMAGE}" "config/kind/cluster.yaml"

./hack/deploy.sh "" "${KIND_KUBECONFIG}"
