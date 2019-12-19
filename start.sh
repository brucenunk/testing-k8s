#!/usr/bin/env bash
set -euxo pipefail

GO111MODULE="on" go get sigs.k8s.io/kind@v0.6.1

CLUSTER_NAME="kind"
K8S_VERSION="v1.14.9"
#KCFG=$(mktemp)

#trap "kind delete cluster --name ${CLUSTER_NAME}" EXIT
kind delete cluster --name ${CLUSTER_NAME}
kind create cluster --name ${CLUSTER_NAME} --image kindest/node:${K8S_VERSION}
#kind get kubeconfig --name ${CLUSTER_NAME} > $KCFG

kubectl create ns istio-system

./install-istio.sh "1.2.7"
#KUBECONFIG="${KCFG}" go test -v -count=1 ./...

./install-knative.sh

