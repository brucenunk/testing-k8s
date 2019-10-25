#!/usr/bin/env bash
set -euxo pipefail

CLUSTER_NAME="${1?}"

kind create cluster --name ${CLUSTER_NAME}
export KUBECONFIG="$(kind get kubeconfig-path --name="${CLUSTER_NAME}")"


kubectl create namespace "istio-system"
./install-istio.sh
