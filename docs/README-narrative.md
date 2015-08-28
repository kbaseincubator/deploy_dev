# Adding a client to the narrative backend

In some cases, a developer may need some additional clients, libraries or dependencies available in the narrative backend.
Depending on how significant the change, this can be achieved in two ways: 1) Fork and clone the narrative repo and rebuild
the image; or 2) Add the dependency into the narrative/Dockerfile that is included with this repo.  We will describe the
second case, since the first case is beyond the scope of this README.

## Modify the narrative/Dockerfile

There is already a commented example in the Dockerfile for a python pip install.  For example, if you need to install any additional
modules using pip, you would add the following to the narrative/Dockerfile:

    RUN /kb/deployment/services/narrative-venv/bin/pip install <pip module>

## Rebuild the narrative image.

Next rebuild the narrative image using the build_narrative script.

    ./scripts/build_narrative

## Restart the front-end narrative proxy

Restart the front-end narrative proxy so the new image will get used.  **This will kill any running narrative containers.**

    docker-compose up -d

That is all that is required.  The new module should be available from within a code cell of the IPython notebook.  Other
dependencies such as R packages could be handled in a simliar manner.
