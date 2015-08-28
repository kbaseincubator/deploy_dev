# Adding a backend job script

Backend jobs are executed via AWE.  In order for AWE to execute a backend task any required scripts, executables or libraries most be installed.  These simplest approach is to extend the existing configured image.

For example, let's assume we have cloned a git repo in the base directory of the deploy_dev checkout that contains the backend scripts and libraries.  We will also assume the repo requires certain libraries and utilities to be present.  The following lines could be added to the Dockerfile in the base deploy_dev repo to add the new back end scripts.

    echo >> Dockerfile << EOF
    RUN apt-get install -y lib-foo utility-bar
    ADD ./myrepo /kb/dev_container/modules/myrepo
    RUN cd /kb/dev_container/modules/myrepo && \
        . ../../user-env.sh && \
        make && make deploy-scripts
    EOF

Once these lines are added, then re-run ./deploy.sh.  Alternatively, you could do the following:

    docker build -t kbase/depl:latest .
    docker-compose up -d

This would rebuild the base image and restart the containers managed by docker-compose.  This would include restarting the aweworker container which would make use of the rebuilt image.
