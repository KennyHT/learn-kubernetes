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

# usage: make build JOB_NUMBER=1 VERSION=0.0.1-dev
build: docker-lint app-lint
	docker image build \
		--build-arg JOB_NUMBER=$(JOB_NUMBER) \
		--build-arg COMMIT_SHA=$(GIT_SHA) \
		--build-arg VERSION=$(VERSION) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest .
	
	"$(MAKE)" app-test

docker-run:
	docker container run --rm -it \
	-v "$(CURDIR)":/usr/src/app \
	-p 5000:5000 $(IMAGE):latest $(CMD)

app-lint:
	"$(MAKE)" docker-run CMD="flake8 ./ \
    --exclude=migrations,.git,static,data,fixtures,*.json,templates \
    --max-complexity 12 \
    --ignore=E501"

app-test:
	"$(MAKE)" docker-run CMD="py.test -x -s --color=yes"

# usage: make push VERSION=0.0.1-dev
push:
	docker image push $(IMAGE):$(VERSION)
	docker image push $(IMAGE):latest


##########
##  CD  ##
##########

kube-validate:
	kubeval manifests/*

kube-security-score:
	"$(MAKE)" kubesec FILE=manifests/deployment.yaml

kubesec:
	@./bin/kubesec kubesec $(FILE) | jq

# usae: render-templates TAG=0.0.1-dev
render-templates: kube-validate
	printf "# AUTO-GENERATED. DO NOT EDIT.\n" > manifests/deployment.yaml
	kubetpl render manifests/templates/deployment.yaml -x=$$ -s TAG=$(TAG) >> manifests/deployment.yaml

kube-deploy:
	kubectl apply -f manifests/
