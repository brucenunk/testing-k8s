#!/usr/bin/env bash
set -euxo pipefail
kubectl apply -f namespace.yaml
kubectl apply -f .
