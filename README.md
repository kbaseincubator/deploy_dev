# deploy_dev
Tools for deploying a KBase development environment in docker containers

## Prerequisites

A functioning deployment currently requires around 40GB of disk space available and 8GB of memory in the Docker machine.  For instructions on preparing a deployment environment please refer to the README at https://github.com/kbaseIncubator/deploy_dev/blob/master/README-buildenv.md

## Clone this repo.

    git clone https://github.com/kbaseIncubator/deploy_dev.git

## Create an initial site config.

    cd deploy_dev
    cp site.cfg.example site.cfg

## Edit site.cfg
Fill in your username and password
Fill in your docker machine (in the line that says PUBLIC=)
(Note that your docker machine needs to be accessible from your webbrowser, because this is how you will get to your Narratives; it also has to be resolvable within the docker container.)

## Run the bootstrap script to start things up

    ./scripts/deploy.sh

# Detailed steps

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

## Starting a client container:

There is a helper script to start a client container.  It will run as your user id using your home directory.

    ./scripts/client.sh

# Developing Services with Containers (draft)

Create a Dockerfile similar to this...

    FROM kbase/depl:1.0
    MAINTAINER Pat Smith psmith@mail.org

Build the image and tag it.  You should probably use a tag different from the default.

    docker build -t psmith/myservice:0.1

Modify the kbrouter config (cluster.ini) to include your service.

    # Your service name
    [myservice]
    #required: need to link to the front-end proxy
    service-port=7444
    # Not used in build, but helpful to include
    giturl=https://github.com/psmith/myservice
    host=myservice
    #optional: must match the directory name in /kb/deployment/services/
    #          needed if the directory name is different from the service name
    basedir=myservice
    #services specific paramaters
    myparamter=1.234
    #optional: Used to create the URL path to the service.
    #          Defaults to service name
    urlname=my_service
    #required: should match the tag you specified in the build above
    docker-image=psmith/myservice:0.1
    #optional: can be used to link to other containers, i.e. databases
    docker-links=mongo:mongo               
    #optional: can be used to mount persistent spaces
    docker-volumes=/data/docker/myservice:/mnt/myservice     

Restart the router

    cd kbrouter
    docker-compose restart router

Access your service via the public proxy and service URL

    curl -X POST -k https://public.hostname.org:8443/services/my_service

#Debugging Tips

Here are a couple of quick tricks for debugging

UJS

    docker exec deploytools_ujs_1 cat /kb/deployment/services/userandjobstate/glassfish_domain/UserAndJobState/logs/server.log

Workspace:

    docker exec deploytools_ws_1 cat /kb/deployment/services/workspace/glassfish_domain/Workspace/logs/server.log

Shock:

    docker exec deploytools_shock_1 ls /mnt/Shock/logs

Web Proxy:

    docker exec deploytools_www_1 cat /var/log/nginx/error.log
