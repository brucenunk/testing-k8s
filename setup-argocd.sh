#!/usr/bin/env bash
set -euxo pipefail

# add corectl because its deployed into argocd-server pod.
kind load docker-image 519920317464.dkr.ecr.ap-southeast-2.amazonaws.com/corectl:v1.0.0-alpha.28

NAMESPACE=argocd

kubectl apply -f ./k8s/argocd/ns.yaml
kubectl apply -n ${NAMESPACE} -f ./k8s/argocd/.

kubectl wait pods \
  --all \
  --for=condition=ready \
  --namespace ${NAMESPACE} \
  --timeout=10m

echo $(kubectl -n ${NAMESPACE} get pods -lapp.kubernetes.io/name=argocd-server -o json | jq -r '.items[].metadata.name') > ./tmp/ARGO-PASS
