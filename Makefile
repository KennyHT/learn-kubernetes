#############
##  Setup  ##
#############

build: 
	cd simple-server && "$(MAKE)" build

update-kubetail:
	./bin/update-kubetail.sh

#############
##  DEBUG  ##
#############

NAMESPACE=?learn-k8s

debug-container:
	kubectl run my-shell --rm -it --image alpine -- sh --namespace=NAMESPACE

pod-logs:
	./bin/kubetail $(NAME) --namespace $(NAMESPACE)

watch-pods:
	watch -n 1 kubectl get pods -o wide --namespace $(NAMESPACE)

event-stream:
	kubectl get events --sort-by=.metadata.creationTimestamp -o custom-columns=CREATED:.metadata.creationTimestamp,NAMESPACE:involvedObject.namespace,NAME:.involvedObject.name,REASON:.reason,KIND:.involvedObject.kind,MESSAGE:.message -w --all-namespaces

docker-vm-shell:
	docker container run --rm -it --privileged --pid=host debian:stretch-slim nsenter -t 1 -m -u -n -i sh



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

site-server:
	docker container run --rm -v "$(CURDIR)":/usr/src/app -p 8080:8080 rabbitbird/mkdocs:latest

site-build:
	docker container run --rm -v "$(CURDIR)":/usr/src/app rabbitbird/mkdocs:latest mkdocs build --clean --strict

deploy-gh-pages:
	./bin/deploy-site.sh
