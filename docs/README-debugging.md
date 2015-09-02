#Debugging

Here are a couple of commands to help with debugging some services.

Checking logs:  From the deploy_dev directory run...

    docker-compose logs

UJS

    docker logs proxy_userandjobstate |grep -v INFO

Workspace:

Check the Workspace server log.  

    docker logs proxy_ws|grep -v INFO

Shock:

    docker exec proxy_shock-api cat /mnt/Shock/logs/error.log

Web Proxy:

    docker logs deploydev_www_1

