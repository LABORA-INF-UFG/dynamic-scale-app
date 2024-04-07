#!make
include env.dev
export $(shell sed 's/=.*//' env.dev)
export WORKER_NAME=worker
export PYTHON=/usr/bin/python3
export IMAGE_NAME=rabbit-server-custom
export VERSION=latest
export CONTAINER=$(IMAGE_NAME)_container

default: run

run:
	docker-compose up -d
	
stop:
	docker-compose down
