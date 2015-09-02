# Adding an upload/download script (draft)

Creating a full upload and download for a new datatype or data source 
is one of the more complex activities to attempt in KBase.  This guide
will is not a comphrensive guide, but will walk though the high-level
steps and explain how development is done in the deplooy_dev docker
environment.

## Overview

An upload/download requires creating several configurations (both for the
UI pieces and the conversion pieces), creating scripts to do validation and
conversion, and modifying some Javascript files in the narrative.  In the
future we hope to combine this pieces so that everything can be specified in
a single repository.

## Preparing the environment

Start by cloning the deploy_dev environment and following the instructions to
starting a isolated development version of KBase.  See the top-level README
for instructions.

Fork and clone:

* https://github.com/kbase/narrative (docker branch)
* https://github.com/kbase/narrative_method_specs_ci
* https://github.com/kbase/transform

Clone the transform fork directly in the deploy_dev directory.  
The others can be forked in a different area. For example:

    cd deploy_dev
    GITUSER=<username>
    git clone git@github.com:$GITUSER/transform.git
    cd ..
    git clone git@github.com:$GITUSER/narrative.git -b docker
    git clone git@github.com:$GITUSER/narrative_method_specs_ci.git

Modify the Dockerfile to your modifications to the above directories into your image build.
Add the lines below to the Dockerfile in the base of your deploy_dev directory.

<pre><code>
ADD ./transform /kb/dev_container/modules/transform
RUN cd /kb/dev_container/modules/transform && . ../../user-env.sh && make && make deploy
</code></pre>

Modify the method-spec-git-repo parameter in your cluster.ini file to point to your 
fork of narrative_method_specs_ci.  Also modify the method-spec-git-repo-branch to match
the branch you will push changes to.  For example:

    [NarrativeMethodStore]
    method-spec-git-repo-branch=master
    method-spec-git-repo=https://github.com/<username>/narrative_method_specs_ci

## Make the changes

### Creating the scripts

Follow the guide at [https://github.com/kbase/project_guides/blob/master/How_to_add_a_new_data_type.md](How_to_add_a_new_data_type.md).  Create the scripts in your clone of the transform repo.

### Create the UI specs

Create configuration in your fork and clone of the narrative_method_specs.  Conculst the README in that repo
for details.

### Add the type to the sidebar

The narrative data pane has a pop out window to perform upload/download operations.  Currently you need to 
modify a javascript file to recongnize the new type.  Edit the file at:
> src/notebook/ipython_profiles/profile_narrative/kbase_templates/static/kbase/js/widgets/narrative_core/kbaseNarrativeSideImportTab.js

## Build and Test

To test your modifications you will need to rebuild thhe narrative image and redeploy.

    cd ../narrative
    docker build -t kbase/narrative:1.0.3 .
    cd ../deploy_dev
    ./deploy.sh
    
The deploy will rebuild the primary image which will include your modifications to transform and use your method specs file.  If services were already runing you will need to restart them.  You can do this by using the DELETE/kill URL to kill the running service.  You can then poke the normal service url to restart the service.  You will need to do this anytime you make changes to a service.

    . ./site.cfg
    curl -X DELETE http://${PUBLIC_ADDRESS}:8080/kill/transform
    curl http://${PUBLIC_ADDRESS}:8080/services/transform
    curl -X DELETE http://${PUBLIC_ADDRESS}:8080/kill/narrativemethodstore
    curl http://${PUBLIC_ADDRESS}:8080/services/narrativemethodstore

At this point you should be able to navigate to the narrative site and try opening the data tab and test your changes.
