# Detailed steps

These steps are done by the deploy.sh script.  Advanced users may need to run some steps separately.

## Create self-signed certs or copy in certs to ./ssl.  Create the config from the docker template.

    ./scripts/generate_config
    ./scripts/create_certs

## Build images

Make sure kbase/deplbase:latest is available. This is available at dockerhub.

    docker pull kbase/deplbase:latest
    docker build -t kbase/depl:latest .
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
    docker-compose build
    docker-compose up -d
    curl http://<publichostname>:8080/services/shock-api
    curl http://<publichostname>:8080/services/awe-api

## Check the deployment

    ./scripts/check_deployment
