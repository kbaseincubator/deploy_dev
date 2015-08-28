#!/bin/sh
. ./site.cfg
[ -z $IMAGE ] && IMAGE=kbase/depl:latest

USER=$(id -u)
WWW=$(docker ps|grep _www_|awk '{print $1}')

docker run -it --rm --name client_$USER --workdir $HOME --volume $HOME:$HOME --env HOME=$HOME --link $WWW:www --entrypoint bash $IMAGE
