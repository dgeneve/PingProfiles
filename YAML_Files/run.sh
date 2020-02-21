#/bin/bash
case "$1" in
	start)
		DCMD="up -d"
	;;
	stop)
		DCMD=down
	;;
	logs)
		DCMD=logs
	;;
	ps)
		DCMD=ps
	;;
esac
if [ ! -z "$2" ]; then
	YAML_FILE="-f $2"
fi
sudo --preserve-env=PING_IDENTITY_DEVOPS_TAG,PING_IDENTITY_DEVOPS_USER,PING_IDENTITY_DEVOPS_KEY,PING_IDENTITY_DEVOPS_HOME /usr/local/bin/docker-compose $YAML_FILE $DCMD

