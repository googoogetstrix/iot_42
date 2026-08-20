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
    echo "waiting..."
    sleep 2
done

echo "token ready: $TOKEN"

# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=192.168.56.111" | \
# K3S_URL=https://192.168.56.110:6443 \
# K3S_TOKEN="$TOKEN" \
# sh -



# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 --node-ip=192.168.56.111 K3S_TOKEN=$TOKEN" sh -

curl -sfL https://get.k3s.io | \
  K3S_URL=https://192.168.56.110:6443 \
  K3S_TOKEN="$TOKEN" \
  INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111" \
  sh -