#!/bin/sh
set -e

echo "DONE , FOR NOW"

apk update
apk add ca-certificates curl git




echo "=== installing K3S ==="
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=192.168.56.110" sh -
echo "=== Done K3S ==="

# pending til the containerd is ready
until k3s kubectl get nodes >/dev/null 2>&1; do
    sleep 1
done


echo "=== importing container images ==="
k3s ctr images import /tmp/app1.tar
k3s ctr images import /tmp/app2.tar
k3s ctr images import /tmp/app3.tar


echo "=== deployment ==="

# you may simply k3s kubectl deploy /vagrant/confs/ for the whole directory, but this is 42 ...

k3s kubectl apply -f /vagrant/confs/app1-deployment.yaml
k3s kubectl apply -f /vagrant/confs/app1-service.yaml

k3s kubectl apply -f /vagrant/confs/app2-deployment.yaml
k3s kubectl apply -f /vagrant/confs/app2-service.yaml

k3s kubectl apply -f /vagrant/confs/app3-deployment.yaml
k3s kubectl apply -f /vagrant/confs/app3-service.yaml

k3s kubectl apply -f /vagrant/confs/ingress.yaml