#!/usr/bin/env bash
set -euxo pipefail
kubectl apply --validate=false -f .
