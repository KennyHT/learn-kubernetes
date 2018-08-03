IMAGE_NAME=rabbitbird/simple-server
VERSION=1.0
WORKDIR=/usr/src/app
PORT=8080

build:
	docker image build -t $(IMAGE_NAME):$(VERSION) -t $(IMAGE_NAME):latest .

run:
	docker container run --rm -p $(PORT):$(PORT) $(IMAGE_NAME):$(VERSION) $(CMD)

dev: build
	docker container run --rm -it -p $(PORT):$(PORT) -v "$(CURDIR)":$(WORKDIR) $(IMAGE_NAME):$(VERSION) $(CMD)
