#!/bin/bash
#K3SMASTER="master"
#K3SMASTERIPADDRESS="192.168.0.200"
NODE_TOKEN=$1
NODE=$(hostname)
sudo apt update
sudo apt install jq vim -y
#echo "$K3SMASTERIPADDRESS       $K3SMASTER" | sudo tee -a /etc/hosts
IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.9.0 INSTALL_K3S_EXEC="--node-ip=${IPADDR} --flannel-iface=enp0s8" K3S_URL=https://192.168.0.200:6443 K3S_TOKEN=$NODE_TOKEN sh -
systemctl status k3s-agent --no-pager
#journalctl -u k3s-agent
sleep 10
tail /var/lib/rancher/k3s/agent/containerd/containerd.log
