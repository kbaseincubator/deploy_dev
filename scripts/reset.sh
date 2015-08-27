#!/bin/bash

#TODO: this script has to be executed from the deploy_dev directory, may need to check


DIRNAME=$(basename `pwd` | tr -d '_')
KILLCONTAINER="-f name=proxy_ -f name=${DIRNAME}_ -f name=mysql -f name=mongo -f name=testweb"
echo "Warning: This will kill your running containers (${KILLCONTAINER}) and reinitialize your configuration."
echo "Hit Ctrl-C if you wish to cancel..."

t=8
while [ $t -gt 0 ] ; do
  echo -n -e "$t  \r"
  sleep 1
  let t=t-1
done
echo



# Kill containers
echo "Killing containers"

docker rm -f $(docker ps ${KILLCONTAINER} -a -q)

echo "Killing Narrative containers"

for container in $(docker ps -a -q) ; do
  if [ "$(docker inspect  -f {{.Args}} ${container} | grep -c 'run_magellan_narrative.sh')" -eq 1 ] ; then
    echo "deleting narrative container ${container}"
    docker rm -f ${container}
  fi
done



echo "Cleaning up dangling images"
docker rmi $(docker images -f dangling=true -q)

echo "Removing configured images"
if [ -e site.cfg ] ; then
  . ./site.cfg
  docker rmi $IMAGE
fi

rm -f initialize.out

