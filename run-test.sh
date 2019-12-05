#!/usr/bin/env bash
set -euxo pipefail

GO111MODULE="on" go get sigs.k8s.io/kind@v0.6.1

CLUSTER_NAME="test"
trap "kind delete cluster --name ${CLUSTER_NAME}" EXIT

kind create cluster --name ${CLUSTER_NAME}

./install-istio.sh

go test -v -count=1 ./...
