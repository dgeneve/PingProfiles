#/bin/bash

case "$1" in
	start)
sudo docker run -d \
--name pingfederate \
--publish 9999:9999 \
--publish 9031:9031 \
--env-file /home/dkgeneve/.pingidentity/devops \
--env PING_IDENTITY_ACCEPT_EULA=YES \
--env PF_LOG_LEVEL=DEBUG \
--env SERVER_PROFILE_URL=https://github.com/dgeneve/PingProfiles \
--env SERVER_PROFILE_PATH=serverProfiles/pingfederate \
--env OPERATIONAL_MODE=CLUSTERED_CONSOLE \
pingidentity/pingfederate:9.3.3-edge
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
	*)
		echo "Usage:"
		echo "./PF.sh start"
		echo "./PF.sh stop"
	       	echo "./PF.sh remove"
		echo "./PF.sh logs"
		echo "./PF.sh shell"
	;;	
esac
