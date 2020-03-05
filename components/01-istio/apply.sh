#!/usr/bin/env bash
set -euxo pipefail

NAMESPACE="istio-system"
VERSION="1.4.3"


# cache install locally.
if [ ! -d "/tmp/istio-${VERSION}" ]; then
  pushd /tmp
  export ISTIO_VERSION=${VERSION}
  curl -sL https://istio.io/downloadIstio | sh -
  popd
fi


kubectl create namespace ${NAMESPACE} || true

# init.
helm template \
  "/tmp/istio-${VERSION}/install/kubernetes/helm/istio-init" \
  --name istio-init \
  --namespace ${NAMESPACE} \
  --values ./values.yaml \
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
helm template \
  "/tmp/istio-${VERSION}/install/kubernetes/helm/istio" \
  --name istio \
  --namespace ${NAMESPACE} \
  --values ./values.yaml \
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
