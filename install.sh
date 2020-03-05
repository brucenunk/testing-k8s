#!/usr/bin/env bash
set -euxo pipefail

GO111MODULE="on" go get sigs.k8s.io/kind@v0.7.0

kind delete cluster
kind create cluster --config kind-config.yaml --image kindest/node:v1.14.9

# install components
for component in $(ls ./components); do
  echo "applying ${component}"
  pushd "./components/${component}"
  ./apply.sh
  popd
done
