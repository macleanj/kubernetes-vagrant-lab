# Bare bone Kubernetes

# Setting up a kubernetes cluster with Ansible
- https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-18-04
Will not be discussed in this readme as such.

# Setting up a kubernetes cluster with kubeadm
- https://www.mirantis.com/blog/how-install-kubernetes-kubeadm/
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

The vagrant file is prepared in such a way that kubeadm and docker are installed. From that point on the manual steps need to be taken to practice cluster setup with kubeadm.

# Control Plane(s) / Master(s)
# Initialize master
Now that we have Kubeadm installed, we’ll go ahead and create a new cluster.  Part of this process is choosing a network provider, and there are several choices; we’ll use Calico for this example.

Create the cluster (master node). Because we are in vagrant we have to advertise the internal IP address:
```
IP_ADDR=`ifconfig enp0s8 | grep mask | awk '{print $2}'| cut -f2 -d:`
HOST_NAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=$IP_ADDR --apiserver-cert-extra-sans=$IP_ADDR  --node-name $HOST_NAME --pod-network-cidr=10.245.0.0/16
```

This will output a string to be used in the workers. Example:
```
kubeadm join 10.244.0.10:6443 --token tth2z3.bwd0ozsiw5ij9aoq \
    --discovery-token-ca-cert-hash sha256:c8ba422ad2d1d970e84106867455f186235d96ca2aedda65a44a5baf0fa952f8 -v 5
```

Enable local kubectl:
```
sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

# As vagrant
kubectl get componentstatuses
kubectl get nodes
```
> Notice the Node NotReady. This is because the network provider has not been installed yet. This results in the coreDNS pod being in "Pending".

Install network provides
```
kubectl get pod -n kube-system
kubectl apply -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml
kubectl get pod -n kube-system
kubectl get nodes
```
> The Node should not be demonstrated as Ready.

```
kubectl get componentstatuses
kubectl get nodes
```

# Expose kube api-server to local guest system


# Workers / Nodes
## Join worker
Run the above command to join the worker and check on the control plane if the worked/node joined with ```kubectl get nodes```

Deploy a test application
```
kubectl run hello-world --image=jmaclean/hello-world
```

