#!/usr/bin/env bash
set -euxo pipefail

kubectl apply -f ./k8s/argocd/ns.yaml
kubectl apply -n argocd -f ./k8s/argocd/.

