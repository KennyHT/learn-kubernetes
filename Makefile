#############
##  Setup  ##
#############

setup:
	docker image pull debian:stretch-slim
	docker image pull gcr.io/kuar-demo/kuard-amd64:1

update-kubetail:
	./bin/update-kubetail.sh

#############
##  DEBUG  ##
#############

DEBUG_DEPLOYMENT_NAME=debug-shell

debug-container-up:
	kubectl run $(DEBUG_DEPLOYMENT_NAME) --rm -it --image alpine:latest -- sh

debug-container-down:
	kubectl delete deployment $(DEBUG_DEPLOYMENT_NAME)

pod-logs:
	./bin/kubetail $(NAME)

watch-pods:
	watch kubectl get pods -o wide --all-namespaces

event-stream:
	kubectl get events --sort-by=.metadata.creationTimestamp -o custom-columns=CREATED:.metadata.creationTimestamp,NAMESPACE:involvedObject.namespace,NAME:.involvedObject.name,REASON:.reason,KIND:.involvedObject.kind,MESSAGE:.message -w --all-namespaces

delete-all:
	kubectl delete pods,services,configmaps,secrets,deployments,pods --all

##########################
##  Docker for Desktop  ##
##########################

docker-vm-shell:
	docker container run --rm -it --privileged --pid=host debian:stretch-slim nsenter -t 1 -m -u -n -i sh

portainer:
	docker container run -p 9000:9000 --rm -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer:latest --no-auth

############################
##  Kubernetes Dashboard  ##
############################

# Listens on port 30000

k8s-dashboard-up:
	./bin/kube-dashboard.sh k8s-dashboard-up

k8s-dashboard-down:
	./bin/kube-dashboard.sh k8s-dashboard-down


############
##  Docs  ##
############

# Required for content development only
#
# Site deployed at https://ryan-blunden.github.io/learn-kubernetes/

DOCS_IMAGE_NAME=ryanblunden/mkdocs
DOCS_PORT=9000
DOCS_VERSION=latest

site-server:
	docker container run --rm -v "$(CURDIR)":/usr/src/app -p $(DOCS_PORT):8000 $(DOCS_IMAGE_NAME):$(DOCS_VERSION)

site-build:
	docker container run --rm -v "$(CURDIR)":/usr/src/app $(DOCS_IMAGE_NAME):$(DOCS_VERSION) mkdocs build --clean --strict

deploy-gh-pages:
	./bin/deploy-site.sh
