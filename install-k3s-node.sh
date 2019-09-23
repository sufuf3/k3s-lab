#!/bin/bash
#K3SMASTER="master"
#K3SMASTERIPADDRESS="192.168.0.200"
NODE_TOKEN=$1
NODE=$(hostname)
sudo apt update
sudo apt install jq vim -y
#echo "$K3SMASTERIPADDRESS       $K3SMASTER" | sudo tee -a /etc/hosts
# Install Docker
# kubernetes official max validated version: 1.13.1, 17.03, 17.06, 17.09, 18.06, 18.09 (Ref: https://kubernetes.io/docs/setup/release/notes/#unchanged)
export DOCKER_VERSION="18.06.3~ce~3-0~ubuntu"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce=${DOCKER_VERSION}
# Manage Docker as a non-root user
sudo usermod -aG docker $USER

# Install K3s-angent
IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.9.0 INSTALL_K3S_EXEC="--docker --node-ip=${IPADDR} --flannel-iface=enp0s8" K3S_URL=https://192.168.0.200:6443 K3S_TOKEN=$NODE_TOKEN sh -
systemctl status k3s-agent --no-pager
#journalctl -u k3s-agent
