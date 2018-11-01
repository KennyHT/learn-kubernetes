IMAGE=ryanblunden/api
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
COMMIT_SHA=$(shell git rev-parse --short HEAD)


##########
##  CI  ##
##########

docker-lint:
	docker container run -it --rm --privileged \
	-v "$(CURDIR)":/root/ projectatomic/dockerfile-lint \
	dockerfile_lint -f Dockerfile

docker-build:
	docker image build \
		--build-arg JOB_NUMBER=$(JOB_NUMBER) \
		--build-arg COMMIT_SHA=$(GIT_SHA) \
		--build-arg VERSION=$(VERSION) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

docker-run:
	docker container run --rm -it \
	-p 5000:5000 $(IMAGE):latest $(CMD)

app-lint:
	"$(MAKE)" docker-run CMD="flake8 ./ \
    --exclude=migrations,.git,static,data,fixtures,*.json,templates \
    --max-complexity 12 \
    --ignore=E501"

app-test:
	"$(MAKE)" docker-run CMD="py.test -x -s --color=yes"

push:
	docker image push

build: docker-lint app-lint
	"$(MAKE)" build JOB_NUMBER=1 VERSION=0.0.1-dev


##########
##  CD  ##
##########

###################
##  DEVELOPMENT  ##
###################

run-dev:
	docker container run --rm -it \
	-v "$(CURDIR)":/usr/src/app \
	-p 5000:5000 $(IMAGE):latest $(CMD)
