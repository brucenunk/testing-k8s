#!/usr/bin/env bash
set -euxo pipefail

#CORECTL_VERSION="v1.0.0-alpha.28"
CLUSTER_NAME="kind"
K8S_VERSION="v1.14.9"
#KCFG=$(mktemp)

GO111MODULE="on" go get sigs.k8s.io/kind@v0.6.1

#trap "kind delete cluster --name ${CLUSTER_NAME}" EXIT
kind delete cluster --name ${CLUSTER_NAME}
kind create cluster --name ${CLUSTER_NAME} --config kind-config.yaml --image kindest/node:${K8S_VERSION}
#kind load docker-image 519920317464.dkr.ecr.ap-southeast-2.amazonaws.com/corectl:${CORECTL_VERSION}
#kind get kubeconfig --name ${CLUSTER_NAME} > $KCFG

kubectl create ns istio-system

./install-istio.sh "1.2.7"
#KUBECONFIG="${KCFG}" go test -v -count=1 ./...

./install-knative.sh

