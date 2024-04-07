#!make
#include env.dev
#export $(shell sed 's/=.*//' env.dev)
export WORKER_NAME=worker
export PYTHON=/usr/bin/python3
export IMAGE_NAME=keda_python-rabbit
export VERSION=latest
export CONTAINER=$(IMAGE_NAME)_container
export REGISTRY=sricanesh #conta no Docker Hub

default: run

build:
	$(PYTHON) -m pip install -r ./requirements/requirements-dev.txt

run:
	$(PYTHON) run.py

buildc:
	docker build --tag $(IMAGE_NAME):${VERSION} . -f Dockerfile

stopc:
	docker rm --force $(CONTAINER)

runc:
	docker run --env-file env.dev --name ${CONTAINER} $(IMAGE_NAME):${VERSION}

publishc:
	docker build -t queue-consumer .
	docker tag queue-consumer $(REGISTRY)/queue-consumer
	docker push $(REGISTRY)/queue-consumer