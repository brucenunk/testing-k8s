#!/usr/bin/env bash
NAME="test"

set -euo pipefail
trap "kind delete cluster --name ${NAME}" EXIT

kind create cluster --name ${NAME}
export KUBECONFIG="$(kind get kubeconfig-path --name="${NAME}")"


./install-istio.sh


_disable_cache="-count=1"
go test -v ${_disable_cache} ./...
