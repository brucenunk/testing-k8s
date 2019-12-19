#!/usr/bin/env bash

set -euxo pipefail

RQ=${BASH_ARGV[0]}
H=$(echo ${RQ} | awk -F/ '{print $3}')

curl -k \
  --connect-to ${H}:80:127.0.0.1:8080 \
  --connect-to ${H}:443:127.0.0.1:8443 \
  "$@"
