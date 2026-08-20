#!/bin/sh
set -ex

apk update
apk add ca-certificates curl git

COUNT=0
while [ ! -f /vagrant/shared/node-token ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    [ "$COUNT" -ge 60 ] && exit 1
done

TOKEN=$(cat /vagrant/shared/node-token)

until curl -k https://192.168.56.110:6443 >/dev/null 2>&1; do
    sleep 2
done

echo "token ready: $TOKEN"

curl -sfL https://get.k3s.io | \
K3S_URL=https://192.168.56.110:6443 \
K3S_TOKEN="$TOKEN" \
sh -