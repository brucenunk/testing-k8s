#!/usr/bin/env bash
set -euxo pipefail

NAMESPACE="istio-system"
ROOT="./helm/istio-1.3.2"

kubectl create ns ${NAMESPACE}

# init.
helm template "${ROOT}/install/kubernetes/helm/istio-init" \
  --name istio-init \
  --namespace ${NAMESPACE} \
  | kubectl apply -f -

kubectl wait job.batch \
  --all \
  --for=condition=complete \
  --namespace ${NAMESPACE} \
  --timeout=2m

kubectl delete jobs \
  --all \
  --namespace ${NAMESPACE}


# main.
helm template "${ROOT}/install/kubernetes/helm/istio" \
  --name istio \
  --namespace ${NAMESPACE} \
  --values "./values-istio.yaml" \
  | kubectl apply -f -

kubectl wait job.batch \
  --all \
  --for=condition=complete \
  --namespace ${NAMESPACE} \
  --timeout=2m

kubectl delete jobs \
  --all \
  --namespace ${NAMESPACE}

kubectl wait pod \
  --all \
  --for=condition=ready \
  --namespace ${NAMESPACE} \
  --timeout=5m
