IMAGE=ryanblunden/api
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA=$(shell git rev-parse --short HEAD)


##########
##  CI  ##
##########

docker-lint:
	docker container run --rm -i hadolint/hadolint:latest /bin/hadolint - --ignore DL3008 < Dockerfile

# usage: make build JOB_NUMBER=1 VERSION=0.0.1-dev
build:
	docker image build \
		--build-arg JOB_NUMBER=$(JOB_NUMBER) \
		--build-arg GIT_SHA=$(GIT_SHA) \
		--build-arg VERSION=$(VERSION) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

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
	kubeval manifests/final/*.yaml

kube-security-score:
	"$(MAKE)" kubesec FILE=manifests/final/deployment.yaml | jq
	# To fail if its score is less than an acceptable threshold
	#"$(MAKE)" kubesec FILE=manifests/final/deployment.yaml | jq --exit-status '.score > 5' >/dev/null

kubesec:
	@./bin/kubesec kubesec $(FILE)

# You should avoid using template rendering until you absolutely need it. 
# Lots of students ask for examples of manifest files with variables which
# is why it's included here. Keep it as simple as possible!
#
# usage: make render-templates TAG=0.0.1-dev REPLICAS=2
render-templates:
	-rm manifests/final/deployment.yaml

	kubetpl render manifests/templates/deployment.yaml -x=$$ -s TAG=$(TAG) -s REPLICAS=$(REPLICAS) > manifests/final/deployment.yaml

kube-deploy:
	kubectl apply -f manifests/final

pipeline-build:
	"$(MAKE)" docker-lint
	"$(MAKE)" build JOB_NUMBER=1 VERSION=0.0.1-dev
	"$(MAKE)" app-lint
	"$(MAKE)" app-test

pipeline-deploy:
	"$(MAKE)" render-templates TAG=0.0.1-dev REPLICAS=2
	"$(MAKE)" kube-validate
	"$(MAKE)" kube-security-score
	"$(MAKE)" kube-deploy
