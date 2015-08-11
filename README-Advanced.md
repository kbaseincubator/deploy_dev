# Detailed steps performed by deploy script

These steps are done by the deploy.sh script.  Advanced users may need to run some steps separately.

## Create the config from the docker template, and then create self-signed certs (or copy certs to ./ssl). 

    ./scripts/generate_config
    ./scripts/create_certs

## Build images

Get kbase/deplbase:latest from dockerhub and build it.

    docker pull kbase/deplbase:latest
    docker build -t kbase/depl:1.0 .
    ./scripts/build_narrative

## Start Base services

Start Mongo and mysql

    docker run --name mongo -d mongo:2.4
    docker run --name mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:5.5

## Initialize Databases

    ./scripts/initialize.sh

## Start services

Clone kbrouter and use it to start things up

    git clone https://github.com/KBaseIncubator/kbrouter
    cd kbrouter
    cp ../cluster.ini cluster.ini
    docker-compose build
    docker-compose up -d
    curl http://<publichostname>:8080/services/shock-api
    curl http://<publichostname>:8080/services/awe-api
    cd ..

## Start workers

Start a worker.

    ./scripts/start_aweworker

## Start Narrative Proxy Engine

    ./scripts/start_narrative

