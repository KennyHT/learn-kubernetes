##############
#  Minikube  #
##############

minikube-start:
	minikube start --kubernetes-version=v1.9.2 --bootstrapper=kubeadm

minikube-stop:
	minikube stop

#########
#  API  #
#########

API_IMAGE_NAME=training.io/api
VERSION=1.0

api-build:
	docker build -t $(API_IMAGE_NAME):$(VERSION) api
