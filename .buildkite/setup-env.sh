#!/bin/bash

# Install Go
export PATH=$PATH:/usr/local/go/bin

# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

# Install Docker
bash scripts/install-docker.sh

# Delete dangling clusters
kind delete clusters --all

# Install kubectl.
curl -LO https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.12.2-linux-amd64.tar.gz
tar -zxvf helm.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
helm repo add kuberay https://ray-project.github.io/kuberay-helm/
helm repo update

# Bypass Git's ownership check due to unconventional user IDs in Docker containers
git config --global --add safe.directory /workdir
