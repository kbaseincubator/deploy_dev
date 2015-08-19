#!/bin/bash

echo "Warning: This will destory all of you running containers and re-initialize your configuration."
echo "Ctrl-C if you wish to cancel"

t=8
while [ $t -gt 0 ] ; do
  echo -n -e "$t  \r"
  sleep 1
  let t=t-1
done
echo

# Kill all containers
echo "Killing all containers"
docker rm -f $(docker ps -a -q)

echo "Cleaning up dangling images"
docker rmi $(docker images -f dangling=true -q)

echo "Removing configured images"
if [ -e site.cfg ] ; then
  . ./site.cfg
  docker rmi $IMAGE
fi

rm -f cluster.ini
rm -f initialize.out

