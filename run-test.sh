#!/usr/bin/env bash
set -euxo pipefail

_cluster_name="test"
trap "kind delete cluster --name ${_cluster_name}" EXIT

kind create cluster --name ${_cluster_name}
export KUBECONFIG="$(kind get kubeconfig-path --name="${_cluster_name}")"

./install-istio.sh

_disable_cache="-count=1"
go test -v ${_disable_cache} ./...
