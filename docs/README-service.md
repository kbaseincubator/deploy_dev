# Developing Services in Containers

## Create the Image

Clone the service repo and add a Dockerfile based on Dockerfile.services

    git clone -b <mybranch> https://github.com/<user>/<myrepo>
    cp deploy_dev/Dockerfile.services <myrepo>/Dockerfile
    edit <myrepo>/Dockerfile
    cd <myrepo> ; git add Dockerfile ; ...

Be sure that your service runs in the foreground when you run start\_service. Otherwise the container will immediately exit and die. E.g., if you are using starman in your start\_service script, make sure you are not passing the daemonize option "-D".

The template will concatenate the deploy.cfg file to /kb/deployment/deployment.cfg. Modify the template apprioriately based on the needs of the service. If you are modifying a service that is already configured in cluster.ini, you MUST comment out the line in your new service Dockerfile that concatenates the deploy.cfg file to /kb/deployment/deployment.cfg and use the second line like so:

    #RUN cd /kb/dev_container/modules/THIS_MODODULE && . ../../user-env.sh && make && make deploy && cat deploy.cfg >> /kb/deployment/deployment.cfg
    RUN cd /kb/dev_container/modules/THIS_MODODULE && . ../../user-env.sh && make && make deploy


Build the image and tag it. You should probably use a tag different from the default.

    docker build -t <user>/<myservice>:<0.1> <myrepo>

## Add the service to the router configuration (or modify an existing service) and restart the router

If you are updating an existing service, modify the cluster.ini file under the section for that service such that the giturl and git-branch variables point to your development repo/branch. Also, update the docker image in cluster.ini under the section for that service to be the one you just built:

    giturl=https://github.com/<user>/<myrepo>
    git-branch=<mybranch>
    docker-image=<user>/<myservice>:<0.1>

If you are adding a new service, modify the cluster.ini file to include your service.

    # Your service name
    [<myservice>]
    #required: need to link to the front-end proxy
    service-port=7444
    # Not used in build, but helpful to include
    giturl=https://github.com/<user>/<myrepo>
    host=<myservice>
    #optional: must match the directory name in /kb/deployment/services/
    #          needed if the directory name is different from the service name
    basedir=myservice
    #services specific paramaters
    myparamter=1.234
    #optional: Used to create the URL path to the service.
    #          Defaults to service name
    urlname=<my_service>
    #required: should match the tag you specified in the build above
    docker-image=<user>/<myservice>:<0.1>
    #optional: can be used to link to other containers, i.e. databases
    #docker-links=mongo:mongo               
    #optional: can be used to mount persistent spaces
    #docker-volumes=/data/docker/<myservice>:/mnt/<myservice>     

If you are testing out changes on an existing service and the service is already running, you may need to stop the existing container:

    docker rm -f proxy_<myservice>

Restart the router

    docker-compose restart router www

## Confirm your service is available

Access your service via the public proxy and service URL

    curl -X POST -k https://public.hostname.org:8443/services/<my_service>
