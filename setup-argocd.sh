#!/usr/bin/env bash
set -euxo pipefail

NAMESPACE=argocd

kubectl apply -f ./k8s/argocd/ns.yaml
kubectl apply -n ${NAMESPACE} -f ./k8s/argocd/.

kubectl wait pods \
  --all \
  --for=condition=ready \
  --namespace ${NAMESPACE} \
  --timeout=10m

echo $(kubectl -n ${NAMESPACE} get pods -lapp.kubernetes.io/name=argocd-server -o json | jq -r '.items[].metadata.name') > PASSWD
