#!/bin/sh

TOKEN=$1
kx='kubectl exec'
$kx jlee -- curl -v -H "Jwt: $TOKEN" nginx
