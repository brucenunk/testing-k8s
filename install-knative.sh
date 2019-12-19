#!/usr/bin/env bash
set -euxo pipefail

VERSION="v0.11.0"

kubectl apply \
  -f https://github.com/knative/serving/releases/download/${VERSION}/monitoring.yaml \
  -f https://github.com/knative/serving/releases/download/${VERSION}/serving.yaml \
  -l knative.dev/crd-install=true

kubectl apply \
  -f https://github.com/knative/serving/releases/download/${VERSION}/monitoring.yaml \
  -f https://github.com/knative/serving/releases/download/${VERSION}/serving.yaml
