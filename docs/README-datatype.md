# Adding a new datatype to the Workspace

KBase data objects are strongly typed, meaning that each datatype has a structure with required and optional fields.  This structure is enforced during creation.

You can add new types to KBase, but please consult the [Project Guides](https://github.com/kbase/project_guides) before you begin.

The basic steps to adding a new type are: 1) Login and connect to the workspace; 2) Request and approve the new module (i.e, the namespace); 3) Create the typespec; 4) Register, commit and release the typespec.

We will now walk through each step.  In this example, we will register a new module called MyModule.

## Start a new client session

If you have the workspace tools installed locally you can try using them.  Otherwise you can use the client.sh helper script to start a client session. In these instructions, we assume that you've already set up your site.cfg (see [deploy_dev/README.md](https://github.com/kbaseIncubator/deploy_dev/) for instructions). In your site.cfig, you should have set PUBLIC_ADDRESS to your public hostname. You will also need to have successfully completed the bootstrap launch (with the deploy.sh script).

## Connect to the workspace

    ./scripts/client.sh
    . ./site.cfg
    ws-url http://${PUBLIC_ADDRESS}:8080/services/ws
    echo $PASSWORD|kbase-login $USER
You can check that you are successfully logged in by typing
    kbase-whoami

## Register the new module

Workspace types have a Namespace.  The top-level part of the name is called a module.  We must first request the new module and get approval.  In the production system, the approvals would be done by a KBase Administrator.

    ws-typespec-register --request MyModule
    ws-typespec-register --admin '{"command":"listModRequests"}'
    ws-typespec-register --admin '{"command":"approveModRequest" , "module":"MyModule"}'
    ws-typespec-register --admin '{"command":"listModRequests"}'

## Create the typespc file

MyModule.spec
<pre><code>
/* my module, hands off */
module MyModule {

typedef structure {
       string name;
       list<int> values;
} ValueSet;

typedef structure {
   string other_name;
   list <float> values;
} FloatValueSet;

funcdef getValueSet(string id) returns (ValueSet);

};
</code></pre>

## Register, commit, and release the new type spec

    ws-typespec-register  -t MyModule.spec  --add 'ValueSet;FloatValueSet'
This gives you a preview of what will be committed. Now you can do the real commit:
    ws-typespec-register  -t MyModule.spec  --add 'ValueSet;FloatValueSet' --commit
    ws-typespec-register --release MyModule
    ws-typespec-list MyModule --spec
