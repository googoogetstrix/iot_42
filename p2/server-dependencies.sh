#!/bin/sh
set -e

apk update
apk add ca-certificates curl git

curl -sfL https://get.k3s.io | sh -

mkdir -p /vagrant/shared

while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
    sleep 1
done

cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/node-token
chmod 644 /vagrant/shared/node-token