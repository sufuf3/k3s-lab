# K3s Lab using Vagrant

## Setup Vagrant VMs

```sh
vagrant up
```

## On Server

### Enter to Master Node

```sh
vagrant ssh master
```

### Intall

```sh
sudo su -
wget https://raw.githubusercontent.com/sufuf3/k3s-lab/master/install-k3s-server.sh
sh install-k3s-server.sh
```
### Uninstall

```sh
systemctl stop k3s && /usr/local/bin/k3s-uninstall.sh
```

## On Agent

### Enter to Agent Node

```sh
vagrant ssh node1
```
### Install

```sh
export NODE_TOKEN=...
sh install-k3s-node.sh ${NODE_TOKEN}
```
e.g.
```sh
export NODE_TOKEN=K10c08035e861e270218ce974467aa4660fff18a66cbc31f0b9eab738b3cc068307::node:a73d1c5cb46e73cfdb0e7d7dcb2f9f15
sh install-k3s-node.sh ${NODE_TOKEN}
```

### Uninstall

```sh
systemctl stop k3s-agent && /usr/local/bin/k3s-agent-uninstall.sh
```

## Verification

On master node

```sh
$ kubectl get no -o wide
NAME     STATUS   ROLES    AGE   VERSION         INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master   Ready    master   97m   v1.15.4-k3s.1   192.168.0.200   <none>        Ubuntu 18.04.3 LTS   4.15.0-64-generic   containerd://1.2.8-k3s.1
node1    Ready    worker   93m   v1.15.4-k3s.1   192.168.0.201   <none>        Ubuntu 18.04.3 LTS   4.15.0-64-generic   containerd://1.2.8-k3s.1

$ kubectl get componentstatus
NAME                 STATUS    MESSAGE   ERROR
scheduler            Healthy   ok
controller-manager   Healthy   ok

$ kubectl run mynginx --image=nginx --replicas=1 --port=80
deployment.apps/mynginx created
$ kubectl expose deployment mynginx --port 80
service/mynginx exposed

$ kubectl get deploy,po,svc -o wide -l run=mynginx
NAME                            READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS   IMAGES   SELECTOR
deployment.extensions/mynginx   1/1     1            1           115s   mynginx      nginx    run=mynginx

NAME                           READY   STATUS    RESTARTS   AGE    IP          NODE    NOMINATED NODE   READINESS GATES
pod/mynginx-568f57494d-nsc8r   1/1     Running   0          115s   10.42.1.2   node1   <none>           <none>

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE   SELECTOR
service/mynginx   ClusterIP   10.43.220.117   <none>        80/TCP    27s   run=mynginx

$ curl 10.43.220.117
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

Delete test pods
```sh
$ kubectl delete deployment.apps/mynginx
deployment.apps "mynginx" deleted
```

Ref:
- https://rancher.com/docs/k3s/latest/en/installation/
- http://devnetstack.com/kubernetes-the-easy-way-with-k3s/
