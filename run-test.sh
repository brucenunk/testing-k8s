#!/usr/bin/env bash
NAME="test"

set -euo pipefail
trap "kind delete cluster --name ${NAME}" EXIT

kind create cluster --name ${NAME}
go test -v ./...

