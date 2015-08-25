# Adding a new datatype to the Workspace

KBase data objects are strongly typed, meaning that the datatype has a structure with required and optional fields.  This structure is enforced during creation.
You can add types to the system.  However, please consult the [Project Guides](https://github.com/kbase/project_guides) before trying to add new types.

The basic steps to adding a new type are: 1) login and connect to the workspace 2) Request and approve the new module (i.e. namespace)  3) Create the typespec 4) Register, commit and release the typespec

We will now walk through each step.  We will register a new module call MyModule.

## Connect to the workspace

If you have the workspace tools installed locally you can try using them.  Otherwise you can use the client.sh helper script to start a client session

    ./client.sh
    . ./path/to/site.cfg
    ws-url http://${PUBLIC_ADDRESS}:8080/services/ws
    echo $PASSWORD|kbase-login $USER
    kbase-whoami

## Register the new module

Workspace types have a Namespace.  The top-level part of the name is called a module.  We must first request and approve the module.  In production system, the approvals would be done by a KBase Administrator.

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
    ws-typespec-register  -t MyModule.spec  --add 'ValueSet;FloatValueSet' --commit
    ws-typespec-register --release MyModule
    ws-typespec-list MyModule --spec
