#!/usr/bin/env bash

apt-get update -y
apt-get install -y make socat docker.io

# Solves DNS resolve issues that affect Docker
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

su ubuntu <<EOF
# source <(kubectl completion bash)
sudo minikube start --vm-driver=none

sudo chown -R ubuntu /home/ubuntu/.kube
sudo chgrp -R ubuntu /home/ubuntu/.kube

sudo chown -R ubuntu /home/ubuntu/.minikube
sudo chgrp -R ubuntu /home/ubuntu/.minikube

echo "source <(kubectl completion bash)" >> /home/ubuntu/.bashrc

cd /home/ubuntu/ && git clone https://github.com/ryan-blunden/learn-kubernetes.git && \
    cd learn-kubernetes && \
    sudo make setup
EOF
