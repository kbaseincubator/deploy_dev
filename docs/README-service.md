# Developing Services with Containers (still under development)

## Create the Image

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

## Add the service to the router configuration and restart the router

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

## Confirm your service is available

Access your service via the public proxy and service URL

    curl -X POST -k https://public.hostname.org:8443/services/my_service
