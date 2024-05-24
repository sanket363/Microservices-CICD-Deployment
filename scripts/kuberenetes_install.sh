#!/bin/bash

# Update the package list
sudo apt-get update

# Install Docker
#sudo apt-get install -y docker.io

# Enable and start Docker service
#sudo systemctl enable docker
#sudo systemctl start docker

# Add Kubernetes APT repository and GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'

# Update the package list again
sudo apt-get update

# Install kubeadm, kubelet, and kubectl
sudo apt-get install -y kubeadm kubelet kubectl

# Initialize the Kubernetes cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Configure kubectl for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy a pod network (flannel in this example)
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Print the join command for worker nodes (save this for later)
echo "Run this command on worker nodes to join the cluster:"
sudo kubeadm token create --print-join-command
