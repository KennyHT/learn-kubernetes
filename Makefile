#########
#  API  #
#########

API_IMAGE_NAME=training.io/api
VERSION=1.0

api-build:
	docker build -t $(API_IMAGE_NAME):$(VERSION) api
