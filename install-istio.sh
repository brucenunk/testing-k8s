#!/usr/bin/env bash
set -euxo pipefail

_namespace="istio-system"
_root="./helm/istio-1.3.2"


# init.
helm template "${_root}/install/kubernetes/helm/istio-init" \
  --name istio-init \
  --namespace ${_namespace} \
  | kubectl apply -f -

kubectl wait job.batch \
  --all \
  --for=condition=complete \
  --namespace ${_namespace} \
  --timeout=2m


# delete completed pods so I can wait for all main pods to become ready in the next step.
kubectl delete pods \
  --all \
  --namespace ${_namespace}


# main.
helm template "${_root}/install/kubernetes/helm/istio" \
  --name istio \
  --namespace ${_namespace} \
  --values "./values-istio.yaml" \
  | kubectl apply -f -

kubectl wait pod \
  --all \
  --for=condition=ready \
  --namespace ${_namespace} \
  --timeout=5m
