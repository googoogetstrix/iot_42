#!/bin/sh
set -e

apk update
apk add ca-certificates curl git


echo "=== BEFORE K3S ==="
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=192.168.56.110" sh -
echo "=== AFTER K3S ==="


mkdir -p /vagrant/shared

echo "=== WAITING FOR node-token TO BE READY  ==="
while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
    sleep 1
done
echo "=== node-token IS READY NOW ==="

cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/node-token
chmod 644 /vagrant/shared/node-token