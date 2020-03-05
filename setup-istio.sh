#!/usr/bin/env bash
set -euxo pipefail

VERSION=${1:?}

NAMESPACE="istio-system"
ROOT="./tmp/istio-${VERSION}"
VALUES="./values-istio.yaml"

# cache install locally.
if [ ! -d ${ROOT} ]; then
  pushd tmp
  export ISTIO_VERSION=${VERSION}
  curl -sL https://istio.io/downloadIstio | sh -
  popd
fi

# init.
helm template "${ROOT}/install/kubernetes/helm/istio-init" \
  --name istio-init \
  --namespace ${NAMESPACE} \
  --values ${VALUES} \
  | kubectl apply -f -

kubectl wait job.batch \
  --all \
  --for=condition=complete \
  --namespace ${NAMESPACE} \
  --timeout=5m

kubectl delete jobs \
  --all \
  --namespace ${NAMESPACE} \
  --wait=true


# main.
helm template "${ROOT}/install/kubernetes/helm/istio" \
  --name istio \
  --namespace ${NAMESPACE} \
  --values ${VALUES} \
  | kubectl apply -f -

kubectl wait job.batch \
  --all \
  --for=condition=complete \
  --namespace ${NAMESPACE} \
  --timeout=5m

kubectl delete jobs \
  --all \
  --namespace ${NAMESPACE} \
  --wait=true

kubectl wait pods \
  --all \
  --for=condition=ready \
  --namespace ${NAMESPACE} \
  --timeout=8m
