#!/usr/bin/env bash
set -euxo pipefail

kubectl apply -f ./k8s/igw/.
kubectl rollout restart deployment -n istio-system istio-ingressgateway
