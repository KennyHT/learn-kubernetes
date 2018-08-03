#############
##  Setup  ##
#############

build: 
	cd simple-server && "$(MAKE)" build

update-kubetail:
	./bin/update-kubetail.sh


###########
##  API  ##
###########

docker-vm-shell:
	docker container run --rm -it --privileged --pid=host debian:stretch-slim nsenter -t 1 -m -u -n -i sh

api-tail:
	./bin/kubetail api

############################
##  Kubernetes Dashboard  ##
############################

# Listens on port 30000

k8s-dashboard-start:
	./bin/kube-dashboard.sh k8s-dashboard-start

k8s-dashboard-stop:
	./bin/kube-dashboard.sh k8s-dashboard-stop


#################
##  Microsite  ##
#################

site-server:
	docker container run --rm -v "$(CURDIR)":/usr/src/app -p 8080:8080 rabbitbird/mkdocs:latest

site-build:
	docker container run --rm -v "$(CURDIR)":/usr/src/app rabbitbird/mkdocs:latest mkdocs build --clean --strict

deploy-gh-pages:
	./bin/deploy-site.sh

