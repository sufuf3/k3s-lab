#!/bin/bash
MASTER=$(hostname)
sudo apt update
sudo apt install jq vim git -y
# Install Docker
# kubernetes official max validated version: 1.13.1, 17.03, 17.06, 17.09, 18.06, 18.09 (Ref: https://kubernetes.io/docs/setup/release/notes/#unchanged)
export DOCKER_VERSION="18.06.3~ce~3-0~ubuntu"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce=${DOCKER_VERSION}
# Manage Docker as a non-root user
sudo usermod -aG docker $USER

# Install K3s
IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.9.0 INSTALL_K3S_EXEC="--docker --node-ip=${IPADDR} --flannel-iface=enp0s8 --write-kubeconfig-mode 644 --no-deploy=servicelb --no-deploy=traefik" sh -
systemctl status k3s --no-pager
#kubectl taint nodes $MASTER node-role.kubernetes.io/master=true:NoSchedule
#kubectl label node $MASTER kubernetes.io/role=master node-role.kubernetes.io/master=
kubectl version
kubectl get nodes
kubectl cluster-info
k3s -v
cat /etc/rancher/k3s/k3s.yaml
#journalctl -u k3s
cat /var/lib/rancher/k3s/server/node-token
echo "export NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)"
