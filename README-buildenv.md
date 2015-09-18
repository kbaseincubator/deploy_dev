# Building development environment
Instructions to prepare environment to run local KBase deployment. There are currently 2 options for building a development environment. Option 1 is to run a docker natively in Ubuntu, option 2 is to run Docker in a virtual machine under OSX or Windows using the Docker Toolbox.

## Option 1: Docker natively (Ubuntu)

### Get a base image

You can download Ubuntu 14.04 from http://www.ubuntu.com/download/desktop

## Update package management

    sudo apt-get update

### Download/install the latest docker package. Create docker group and add your user.

    wget -qO- https://get.docker.com/ | sh
    sudo usermod -aG docker ubuntu # log out and back in

### Install docker-compose

    curl -L https://github.com/docker/compose/releases/download/1.3.3/docker-compose-`uname -s`-`uname -m` > docker-compose
    sudo mv docker-compose /usr/local/bin/
    chmod +x /usr/local/bin/docker-compose


### Allow access to the following TCP ports.
<ul>
<li>ALLOW 8080:8080 from 0.0.0.0/0</li>
<li>ALLOW 8888:8888 from 0.0.0.0/0</li>
<li>ALLOW 8443:8443 from 0.0.0.0/0</li>
<li>ALLOW 6443:6443 from 0.0.0.0/0</li>
</ul>

e.g. OpenStack, create security group using nova tools:

    nova secgroup-create mykbdepl "my kb deployment ports"
    nova secgroup-add-rule mykbdepl tcp 8080 8080 0.0.0.0/0
    nova secgroup-add-rule mykbdepl tcp 8888 8888 0.0.0.0/0
    nova secgroup-add-rule mykbdepl tcp 8443 8443 0.0.0.0/0
    nova secgroup-add-rule mykbdepl tcp 6443 6443 0.0.0.0/0
    

## Option 2: Docker Toolbox / Kitematic (Mac OS X 10.9+ and Windows 7+)

Install Docker Toolbox from 
https://www.docker.com/toolbox

This will install docker and docker-compose. Docker will run in a VirtualBox VM in the background. Open "Docker Quickstart Terminal" (or "Kitematic"). When you open the Docker terminal, a message tells you the IP Docker uses. You will need to specify this IP as PUBLIC_ADDRESS in the site.cfg for your deployment. Kitematic provides a GUI to run Docker container but you can also invoke a terminal by clicking on the "DOCKER CLI" button in the bottom left corner.

You can also find the Docker/VM IP using one of these commands:

    ifconfig vboxnet0
    netstat -rn | grep vboxnet
