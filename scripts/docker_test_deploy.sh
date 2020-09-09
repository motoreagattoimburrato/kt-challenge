#!/usr/bin/env bash

docker network create -d overlay example_network
docker service create --name example_service --publish published=8080,target=80 --replicas 2 --network example_network nginx:latest
