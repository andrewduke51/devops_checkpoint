#!/usr/bin/env bash

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker images -a
docker rmi $(docker images -a -q)


