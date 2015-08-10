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

If you encounter problems when trying to deploy, you can look at the README file (https://github.com/kbaseIncubator/deploy_dev/blob/master/README-deploy.md) that describes in detail the steps that are performed by the deployment script.
