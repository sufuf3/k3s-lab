# K3s Lab

## On Server

### Intall
install-k3s-server.sh
```
#!/bin/bash
MASTER=$(hostname)
sudo apt update
sudo apt install jq vim git -y
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.8.1 INSTALL_K3S_EXEC="--disable-agent" sh - --kubelet-arg="address=0.0.0.0"
systemctl status k3s
kubectl taint nodes $MASTER node-role.kubernetes.io/master=true:NoSchedule
kubectl label node $MASTER kubernetes.io/role=master node-role.kubernetes.io/master=
cat /var/lib/rancher/k3s/server/node-token
```

### Uninstall

```
/usr/local/bin/k3s-uninstall.sh
```

## On Agent

### Install
install-k3s-node.sh
```
#!/bin/bash
K3SMASTER=$1
K3SMASTERIPADDRESS=$2
NODE_TOKEN=$3
NODE=$(hostname)
sudo apt update
sudo apt install jq vim -y
kubectl label node $NODE kuber
echo "$K3SMASTERIPADDRESS       $K3SMASTER" | sudo tee -a /etc/hosts
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v0.8.1 sh - agent --server https://$K3SMASTER:6443 --kubelet-arg="address=0.0.0.0" --token $NODE_TOKEN
systemctl status k3s-agent
```


```
export NODE_TOKEN=
sh install-k3s-node.sh k3snode-1 192.168.26.11 ${NODE_TOKEN}
```

### Uninstall
```
/usr/local/bin/k3s-agent-uninstall.sh
```


Ref: https://rancher.com/docs/k3s/latest/en/installation/
