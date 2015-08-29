# Adding a UI widget

The UI code typically resides in the ui-common repo.  To test out new UI components you can follow the following basic steps.

    cd deploy_dev
    git clone https://github.com/kbase/ui-common
    cd ui-common
    git submodule update --init --recursive
    cd ..
    echo << EOF >> Dockerfile
    ADD ./ui-common /kb/dev_container/modules/ui-common
    EOF

The ADD is all that is required, since the UI deployment is currently handled in the entrypoint script.  *Note that the submodule update may take a signficant amount of time.*

After you make changes in the UI-common space, you can test the changes by rebuilding the image and restarting the front-end.

    docker build -t kbase/depl:latest .
    docker-compose up -d

The docker-compose will restart several containers including the container that serves up UI-common (narrative).

Note that if any of the changes in UI-common are required in the narrative backend, then you currently will need to separately rebuild that image.  Follow the instructions in [README-narrative.md](README-narrative.md) on how to rebuild that narrative backend image.
