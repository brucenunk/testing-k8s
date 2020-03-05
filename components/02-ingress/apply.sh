#!/usr/bin/env bash
set -euxo pipefail

kubectl apply -f .
kubectl rollout restart deployment -n istio-system istio-ingressgateway
