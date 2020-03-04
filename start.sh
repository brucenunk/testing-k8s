#!/usr/bin/env bash
set -euxo pipefail

CLUSTER_NAME="kind"
K8S_VERSION="v1.14.9"

GO111MODULE="on" go get sigs.k8s.io/kind@v0.7.0

#trap "kind delete cluster --name ${CLUSTER_NAME}" EXIT
KIND=kind #"sudo /Users/jlee/go/bin/kind"
${KIND} delete cluster --name ${CLUSTER_NAME}
${KIND} create cluster --name ${CLUSTER_NAME} --config kind-config.yaml --image kindest/node:${K8S_VERSION}

kubectl create ns istio-system

./setup-istio.sh "1.4.3"
./setup-igw.sh
./setup-argocd.sh
