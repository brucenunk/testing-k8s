#!/usr/bin/env bash
set -euxo pipefail

_cluster_name="test"
trap "kind delete cluster --name ${_cluster_name}" EXIT

./setup-cluster.sh ${_cluster_name}

_disable_cache="-count=1"
go test -v ${_disable_cache} ./...
