# Developing for KBase using the deploy_dev environment

Developing a full application for KBase requires potentially modifying many parts
of KBase.  The deploy_dev environment gives a developer the ability to quickly modify
and tests all parts of the system in an integrated fashion.

While a complete description of developing KBase applications is beyond the scope of this
guide, here is a quick summary of what is typically required and the steps to perform this
in deploy_dev.

We will take a toy example.  We will add a new service (MyService) that consists of a new
type, a new uploader script, a new service, a new backend job script, a new UI component, 
and changes to the narrative to include the new client functions.  We have broken these out into separate guides.

- [Adding a data type](README-datatype.md)
- [Adding an upload/download script](README-upload-download.md)
- [Adding/modifying a Service](README-service.md)
- [Adding a backend job script](README-job-script.md)
- [Adding a UI widget](README-UI.md)
- [Adding a python client to the narrative backend](README-narrative.md)
