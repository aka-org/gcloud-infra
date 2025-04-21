#!/bin/bash
set -e

echo "[+] Installing containerd"
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
sudo touch /etc/containerd/config.toml
containerd config default > /etc/containerd/config.toml
sudo systemctl restart containerd

echo "[+] Installing Kubernetes components"
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo swapoff -a
