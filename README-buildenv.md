# Building development environment
Instructions to prepare environment to run local KBase deployment. There are currently 2 options for building a development environment. Option 1 is to run a docker natively in Ubuntu, option 2 is to run docker thru a VM on a Mac OSX (running OS X 10.6 “Snow Leopard” or newer) using Boot2Docker.

# Option 1 (Ubuntu)

## Get a base image

You can download Ubuntu 14.04 from http://www.ubuntu.com/download/desktop

## Update package management

    sudo apt-get update

## Download/install the latest docker package. Create docker group and add your user.

    wget -qO- https://get.docker.com/ | sh
    sudo usermod -aG docker ubuntu # log out and back in

## Install docker-compose

    curl -L https://github.com/docker/compose/releases/download/1.3.3/docker-compose-`uname -s`-`uname -m` > docker-compose
    sudo mv docker-compose /usr/local/bin/
    chmod +x /usr/local/bin/docker-compose


## Allow access to the following TCP ports.
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
    

# Option 2 (Mac OSX 10.6 or newer)

## Install Boot2Docker

Download and install Boot2Docker from: https://github.com/boot2docker/osx-installer/releases/download/v1.7.1/Boot2Docker-1.7.1.pkg

## Install docker-compose

    curl -L https://github.com/docker/compose/releases/download/1.3.3/docker-compose-`uname -s`-`uname -m` > docker-compose
    sudo mv docker-compose /usr/local/bin/
    chmod +x /usr/local/bin/docker-compose

# Option 3 Docker Toolbox / Kitematic- not tested (Mac OS X 10.8+ and Windows 7+ (64-bit))

Install Docker Toolbox from 
https://www.docker.com/toolbox

This will install docker and docker-compose. Docker and container run in VirtualBox VM in the background.
