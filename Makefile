#########
#  API  #
#########

API_IMAGE_NAME=training.io/api
VERSION=1.0

build:
	cd /tmp && \
	rm -fr learn-docker && \
    git clone https://github.com/ryan-blunden/learn-docker && \
    cd learn-docker && \
    "$(MAKE)" build && \
    cd ../ && \
    rm -fr learn-docker

docker-for-mac-vm-exec:
	docker container run --rm -it --privileged --pid=host debian:stretch-slim nsenter -t 1 -m -u -n -i $(CMD)

shell:
	"$(MAKE)" docker-for-mac-vm-exec CMD="sh"


###############
#  Microsite  #
###############


site-server:
	docker container run --rm -v "$(CURDIR)":/usr/src/app -p 8080:8080 rabbitbird/mkdocs

site-build:
	docker container run --rm -v "$(CURDIR)":/usr/src/app rabbitbird/mkdocs mkdocs build --clean --strict

deploy-gh-pages:
	./bin/deploy-site.sh
