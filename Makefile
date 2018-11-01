#############
##  Setup  ##
#############

setup:
	docker image pull debian:stretch-slim
	docker image pull gcr.io/kuar-demo/kuard-amd64:1

kube-tools:
	docker container run --rm -it -v $(CURDIR):/usr/src/app ryanblunden/kubetools:latest


#############
##  DEBUG  ##
#############

DEBUG_DEPLOYMENT_NAME=debug-shell

debug-container:
	kubectl run $(DEBUG_DEPLOYMENT_NAME) --rm -it --image alpine:3.8 -- sh

kuard-port-forward:
	kubectl port-forward kuard-pod 8080:8080

kill-debug-container:
	kubectl delete deployment $(DEBUG_DEPLOYMENT_NAME)

pod-logs:
	kubectl run -it --rm -l kail.ignore=true --restart=Never --image=abozanich/kail:latest kail

watch-pods:
	watch kubectl get pods -o wide

event-stream:
	kubectl get events --sort-by=.metadata.creationTimestamp -o custom-columns=CREATED:.metadata.creationTimestamp,NAMESPACE:involvedObject.namespace,NAME:.involvedObject.name,REASON:.reason,KIND:.involvedObject.kind,MESSAGE:.message -w --all-namespaces

delete-all:
	kubectl delete pods,services,configmaps,secrets,replicasets,deployments,jobs,cronjobs,daemonsets,statefulsets,podsecuritypolicies --all --namespace=learn-k8s


##########################
##  Docker for Desktop  ##
##########################

docker-vm-shell:
	docker container run --rm -it --privileged --pid=host debian:stretch-slim nsenter -t 1 -m -u -n -i sh

# TODO: How to add newlines using $(info)
portainer:
	$(info  )
	$(info Open http://localhost:9000/#/init/endpoint to configure Portainer and select "Local" for the environment.)
	$(info  )

	docker container run --rm --name portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer:latest --no-auth


##################
##  Kube Tools  ##
##################

# USAGE: make kubesec FILE=manifests/pod.yaml
kubesec:
	@./bin/kubesec kubesec $(FILE) | jq

# USAGE: make kail FILTER=--pod kuard-pod
# Filters documentation at https://github.com/boz/kail
kail:
	@kubectl run -it --rm -l kail.ignore=true --restart=Never --image=abozanich/kail:latest kail -- "$(FILTER)"

checksums:
	@$(info APP_CONFIGMAP_CHECKSUM=$(shell shasum -a 256 manifests/configmap-app.yaml | cut -d ' ' -f 1))
	@$(info API_TOKEN_SECRET_CHECKSUM=$(shell shasum -a 256 manifests/secret-api-token.yaml | cut -d ' ' -f 1))
	@$(info USERS_DB_SECRET_CHECKSUM=$(shell shasum -a 256 manifests/secret-db-properties.yaml | cut -d ' ' -f 1))

tmpl:
	kubetpl render manifests/pod.yaml -x=$$ -s TAG=$(TAG)

############################
##  Kubernetes Dashboard  ##
############################

# Listens on port 30000

k8s-dashboard-up:
	./bin/kube-dashboard k8s-dashboard-up

k8s-dashboard-down:
	./bin/kube-dashboard k8s-dashboard-down


##################
##  Labs  Site  ##
##################

# Required for lab content development only.
#
# Site deployed at https://ryan-blunden.github.io/learn-kubernetes/

LABS_IMAGE=ryanblunden/mkdocs:latest
LABS_PORT=8000

labs-server:
	docker container run --rm -v "$(CURDIR)":/usr/src/app -p $(LABS_PORT):8000 $(LABS_IMAGE)

labs-build:
	docker container run --rm -v "$(CURDIR)":/usr/src/app $(LABS_IMAGE) mkdocs build --clean --strict

deploy-labs:
	./bin/deploy-site
