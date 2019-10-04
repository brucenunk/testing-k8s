#!/usr/bin/env bash
NAME="test"

set -euo pipefail
trap "kind delete cluster --name ${NAME}" EXIT

kind create cluster --name ${NAME} --config cluster-config.yaml
go test -v ./...

