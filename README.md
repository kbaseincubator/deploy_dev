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

    ./deploy.sh

## Starting a client container:

There is a helper script to start a client container.  It will run as your user id using your home directory.

    ./scripts/client.sh

If you encounter problems when trying to deploy, you can look at the README file (https://github.com/kbaseIncubator/deploy_dev/blob/master/README-deploy.md) that describes in detail the steps that are performed by the deployment script.

# Developing Services with Containers (still under development)

Clone the service repo and add a Dockerfile based on Dockerfile.services

    git clone https://github.com/user/myrepo
    cd myrepo
    cp ../Dockerfile.services Dockerfile
    edit Dockerfile

Be sure that your service runs in the foreground when you run start_service.  Otherwise the container will immediately exit and die.

The template will concatentate the deploy.cfg file to /kb/deployment/deployment.cfg.  Modify the template apprioriately based on the
needs of the service.

Build the image and tag it.  You should probably use a tag different from the default.

    docker build -t psmith/myservice:0.1 .

Modify the cluster.ini in the deploy_dev area to include your service.

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

    cd /path/to/deploy_dev
    docker-compose restart router

Access your service via the public proxy and service URL

    curl -X POST -k https://public.hostname.org:8443/services/my_service

#Debugging Tips

Here are a couple of commands to help with debugging some services

Checking logs:  From the deploy_dev directory run...

    docker-compose logs

UJS

    docker logs proxy_ujs |grep -v INFO

Workspace:

Check the Workspace server log.  

    docker logs proxy_ws|grep -v INFO

Shock:

    docker exec proxy_shock-api cat /mnt/Shock/logs/error.log

Web Proxy:

    docker logs deploydev_www_1

