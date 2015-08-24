# deploy_dev
Tools for deploying a KBase development environment in docker containers

## Prerequisites

A functioning deployment currently requires around 40GB of disk space available and 8GB of memory in the Docker machine. For instructions on preparing a deployment environment (installing docker and opening ports) please refer to the README at [README-buildenv.md](README-buildenv.md)

## Clone this repo

    git clone https://github.com/kbaseIncubator/deploy_dev.git

## Create an initial site config

    cd deploy_dev
    cp site.cfg.example site.cfg

## Edit site.cfg

    USER=<your username>
    PASSWORD=<your password>
    PUBLIC=<public IP or public hostname of your machine>

Note that your docker machine needs to be accessible from your webbrowser, because this is how you will get to your Narratives; it also has to be resolvable within the docker container.

## Run the bootstrap script to start things up

    ./deploy.sh

If you encounter problems when trying to deploy, you can look at the [README-deploy](README-deploy.md) file that describes in detail the steps that are performed by the deployment script.

## Starting a client container:

There is a helper script to start a client container. It will run as your user id using your home directory.

    ./scripts/client.sh

## Resetting

Sometimes the deployment fails, and you need to start over. Run the reset script before you try again:
    ./scripts/reset.sh
    
# More Resources

Consult the [docs](docs) directory for more information.  You can find more details on developing in the deploy_dev environment in [README-developing.md](./docs/README-developing.md).

You can find tips for debugging in [docs/README-debugging](docs/README-debugging.md).

