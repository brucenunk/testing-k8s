#!/usr/bin/env bash
set -euxo pipefail

GO111MODULE="on" go get sigs.k8s.io/kind@v0.6.1

CLUSTER_NAME="test"
KCFG=$(mktemp)

trap "kind delete cluster --name ${CLUSTER_NAME}" EXIT
kind create cluster --name ${CLUSTER_NAME}
kind get kubeconfig --name ${CLUSTER_NAME} > $KCFG

kubectl create ns istio-system

./install-istio.sh "1.2.7"
KUBECONFIG="${KCFG}" go test -v -count=1 ./...

./install-istio.sh "1.3.2"
KUBECONFIG="${KCFG}" go test -v -count=1 ./...

