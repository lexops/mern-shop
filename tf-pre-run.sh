#!/bin/bash
echo "Installing pre-requisites ..."
apt-get update
apt-get install -y unzip

echo "Installing awscli ..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

echo "Installing kubectl ..."
STABLE=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${STABLE}/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

echo "Installing helm ..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
