#!/bin/bash
MASTER=$(hostname)
sudo apt update
sudo apt install jq vim git -y
IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=${IPADDR} --flannel-iface=enp0s8 --write-kubeconfig-mode 644 --no-deploy=servicelb --no-deploy=traefik" sh -
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
