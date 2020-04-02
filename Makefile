SHELL = /bin/bash
include .env
.EXPORT_ALL_VARIABLES:

.DEFAULT_GOAL = help
.PHONY: help build-image delete-image push-image check-clean clean build-package

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build-image: .cache/Python.tgz .cache/get-pip.py ## Build builder Docker image
	docker-compose build

delete-image: check-clean ## Remove docker image
	docker image rmi ${NAME}:${TAG}

push-image:  ## Push image to the regestry
	docker push ${NAME}:${TAG}

.cache/Python.tgz:
	cd .cache && wget -O Python.tgz https://www.python.org/ftp/python/${PYTHON}/Python-${PYTHON}.tgz

.cache/get-pip.py:
	cd .cache && wget https://bootstrap.pypa.io/get-pip.py

check-clean:
	@echo -n "Are you sure? Docker image ${NAME}:${TAG} will be deleted [y/N] " && read ans && [ $${ans:-N} = y ]

clean:  ## Clean dirs
	rm -fr .package .build .cache
	mkdir .package .build .cache
	touch .package/.gitkeep .build/.gitkeep .cache/.gitkeep

build-package:  ## Build lambda package with container /scripts/builder.sh
	docker-compose up

build-package-custom:  ## Build lambda package with local ./scripts/custom_builder.sh
	docker-compose -f docker-compose.custom.yml up

test-package:  ## Test lambda with the help of lambci/lambda
	docker-compose -f docker-compose.lambci.yml up