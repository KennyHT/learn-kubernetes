#########
#  API  #
#########

API_IMAGE_NAME=training.io/api
VERSION=1.0

api-build:
	docker build -t $(API_IMAGE_NAME):$(VERSION) ./api

docker-for-mac-vm-exec:
	docker container run --rm -it --privileged --pid=host debian:stretch-slim nsenter -t 1 -m -u -n -i $(CMD)

shell:
	$(MAKE) docker-for-mac-vm-exec CMD="sh"


###############
#  Microsite  #
###############


site-server:
	docker container run --rm -v "$(CURDIR)":/usr/src/app -p 8080:8080 rabbitbird/mkdocs

site-build:
	docker container run --rm -v "$(CURDIR)":/usr/src/app rabbitbird/mkdocs mkdocs build --clean --strict

deploy-gh-pages:
	./bin/deploy-site.sh
