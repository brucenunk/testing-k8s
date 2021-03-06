#!/usr/bin/env bash
set -euxo pipefail

# add corectl because its deployed into argocd-server pod.
kind load docker-image 519920317464.dkr.ecr.ap-southeast-2.amazonaws.com/corectl:v1.0.0-alpha.28

NAMESPACE=argocd

kubectl apply -f namespace.yaml
kubectl apply -n ${NAMESPACE} -f .

kubectl wait pods \
  --all \
  --for=condition=ready \
  --namespace ${NAMESPACE} \
  --timeout=10m
