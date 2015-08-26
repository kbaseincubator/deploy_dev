#!/bin/sh
DEPL=kbase/deplbase:latest
BASE=kbase/narrative:base2.0
KBR=https://github.com/KBaseIncubator/kbrouter
MONGO=mongo:2.4
MYSQL=mysql:5.5
NGINX=nginx:1.9.2

# Pre-reqs
echo "Preflight"
for image in $DEPL $BASE $MONGO $MYSQL $NGINX; do
  #docker inspect $image > /dev/null
  #if [ $? -ne 0 ] ; then
    echo "Pulling $image"
    docker pull $image
  #fi
done

# Check for the site.cfg
if [ ! -e ./site.cfg ] ; then
  echo "No site.cfg"
  echo "Copy site.cfg.example and modify appropriately, inserting your KBase developer username and password"
  exit
fi

# We need docker compose
which docker-compose > /dev/null
if [ $? -ne 0 ] ; then
  echo "Missing docker-compose"
  echo "Install it from here.."
  echo "https://docs.docker.com/compose/install/"
  exit
fi

# Source the config
. ./site.cfg

# Run some other checks (this script could expand over time)
./scripts/preflight || exit

[ -e ./cluster.ini ] || ./scripts/generate_config

if [ $(ls -1 ssl/{narrative.crt,narrative.key,proxy.crt,proxy.key} 2> /dev/null | wc -l) -ne 4 ] ; then
  echo "Creating self-signed certs"
  ./scripts/create_certs
fi

# No longer needed.  Provided in base.
# Check that there is a tag file
#if [ ! -e ./tagfile ] ; then
#  echo "Create a tagfile"
#  ./deploy_cluster mkhashfile tagfile
#fi

echo "Creating Configured Image"
[ ! -z $SKIPBUILD ] || docker build -t $IMAGE . > build.out
if  [ $? -ne 0 ] ; then
  echo "Failed build "
  tail build.out
  exit
fi

echo "Building Narrative Image"
[ ! -z $SKIPBUILD ] || ./scripts/build_narrative >> build.out

T=0
if [ $(docker ps -q -f name=mongo|wc -l) -eq 0 ] ; then
  docker run --name mongo --volume /data/docker/mongo:/data/db -d mongo:2.4 --smallfiles || exit
  T=5
fi

if [ $(docker ps -q -f name=mysql|wc -l) -eq 0 ] ; then
  docker run --name mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:5.5 || exit
  T=10
fi

echo "Waiting $T seconds for database servers to start"
sleep $T
while [ $(docker logs mysql 2>&1|grep -c 'mysqld: ready for connections.') -lt 1 ] ; do
  echo "Still waiting for mysql"
  sleep 1
done

while [ $(./scripts/setup_mysql|grep -c ERROR) -gt 1 ] ; do
  echo "mysql may not be up yet"
  sleep 1
done

if [ ! -e initialize.out ] ; then
  echo "Initializing database"
  ./scripts/initialize.sh > initialize.out
else
  echo ""
  echo "WARNING:  Skipping Initialize."
  echo "WARNING:  Run ./scripts/initialize.sh by hand if you need to re-initialize"
  echo ""
fi
sleep 1

if [ ! -e ./kbrouter ] ; then
  echo "Cloning kbrouter"
  git clone $KBR
fi

echo "Building Router"
docker-compose build >> build.out

echo "Starting Router"
docker-compose up -d
if [ $? -ne 0 ] ; then
  echo "==========================="
  echo ""
  echo "Failed on docker-compose up"
  echo "Make sure your image names specified in docker-compose.yml match the name in site.cfg ($IMAGE)"
  exit 2
fi

echo "Waiting for router to start"
while [ $(curl -s http://${PUBLIC_ADDRESS}:8080/services/|grep -c user_profile) -lt 1 ] ; do
  sleep 1
done
echo ""

echo "Checking deployment"
./scripts/check_deployment || exit 1

echo "Waiting"
echo ""
wait
echo "Done"
echo "Point your browser to: https://${PUBLIC_ADDRESS}:6443/"
echo "But visit https://${PUBLIC_ADDRESS}:8443/services/ first to accept the SSL certificate."
