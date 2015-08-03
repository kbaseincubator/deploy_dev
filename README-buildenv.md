# Building development environment
Instructions to prepare environment to run local KBase deployment

## Get a base image

You can download Ubuntu 14.04 from http://www.ubuntu.com/download/desktop

## Update package management

    sudo apt-get update

## Setup docker

    wget -qO- https://get.docker.com/ | sh
    sudo usermod -aG docker ubuntu # log out and back in

## Install docker-compose

    curl -L https://github.com/docker/compose/releases/download/1.3.3/docker-compose-`uname -s`-`uname -m` > docker-compose
    sudo mv docker-compose /usr/local/bin/
    chmod +x /usr/local/bin/docker-compose

## Get base docker image for KBase

    docker pull kbase/deplbase:1.0

## Allow access to the following ports.

ALLOW 8080:8080 from 0.0.0.0/0
ALLOW 8443:8443 from 0.0.0.0/0
ALLOW 6443:6443 from 0.0.0.0/0
