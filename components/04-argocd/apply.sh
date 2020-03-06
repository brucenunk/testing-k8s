#!/usr/bin/env bash
set -euxo pipefail

NAMESPACE=argocd

kubectl apply -f namespace.yaml
kubectl apply -n ${NAMESPACE} -f .

kubectl wait pods \
  --all \
  --for=condition=ready \
  --namespace ${NAMESPACE} \
  --timeout=10m
