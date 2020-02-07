#/bin/bash
case "$1" in
	start)
sudo docker run -d \
--name pingfederate \
--publish 9999:9999 \
--publish 9031:9031 \
--env-file /home/dkgeneve/.pingidentity/devops \
--env SERVER_PROFILE_URL=https://github.com/dgeneve/Docker.git \
--env SERVER_PROFILE_PATH=server_profiles/PingFederate/9.3.1/Admin \
--env PING_IDENTITY_ACCEPT_EULA=YES \
pingidentity/pingfederate:edge
	;;
	stop)
sudo docker stop pingfederate
	;;
	remove)
sudo docker rm pingfederate
	;;
	logs)
sudo docker container logs -f pingfederate
	;;
	shell)
sudo docker container exec -it pingfederate /bin/sh
	;;
esac
