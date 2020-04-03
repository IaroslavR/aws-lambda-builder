SHELL = /bin/bash
include .env
.EXPORT_ALL_VARIABLES:

.DEFAULT_GOAL = help
.PHONY: help build-image delete-image push-image check-clean clean build-package

#export HTTP_PROXY = "http://127.0.0.1:3128"
#export HTTPS_PROXY = "http://127.0.0.1:3128"
#export FTP_PROXY = "http://127.0.0.1:3128"

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build-image: .cache/Python.tgz .cache/get-pip.py ## Build base builder Docker image
	docker-compose build

build-image-custom: ## Build custom runtime from ./examples/Doskerfile
	docker build \
		-t ${CUSTOM_IMAGE_NAME}:${CUSTOM_IMAGE_TAG} \
		--build-arg BASE_IMAGE=${NAME}:${TAG}\
		./example

push-image:  ## Push image to the regestry
	docker push ${NAME}:${TAG}

.cache/Python.tgz:
	cd .cache && wget -O Python.tgz https://www.python.org/ftp/python/${PYTHON}/Python-${PYTHON}.tgz

.cache/get-pip.py:
	cd .cache && wget https://bootstrap.pypa.io/get-pip.py

clean:  ## Clean everything
	rm -fr .package .build .cache .wheelhouse
	mkdir .package .build .cache .wheelhouse
	touch .package/.gitkeep .build/.gitkeep .cache/.gitkeep .wheelhouse/.gitkeep

build-package: build-image-custom ## Build lambda package with ./examples/Doskerfile as runtime
	NAME=${CUSTOM_IMAGE_NAME} TAG=${CUSTOM_IMAGE_TAG} docker-compose -f docker-compose.yml up

test-package:  ## Test lambda with the help of lambci/lambda
	docker-compose -f docker-compose.lambci.yml up

start-proxy:  ## Start Squid proxy for more fast builds
	docker-compose -f docker-compose.squid.yml up