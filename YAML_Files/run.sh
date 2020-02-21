#/bin/bash
if [ -z "$1" ]; then
	echo "Usage: "
	echo "./run.sh up"
	echo "./run.sh up yaml_file.yaml"
	echo "./run.sh down"
	echo "./run.sh down yaml_file.yaml"
	echo "./run.sh ps"
	echo "./run.sh ps yaml_file.yaml"
	exit
fi
case "$1" in
	up)
		DCMD="up -d"
	;;
	down)
		DCMD=down
	;;
	ps)
		DCMD=ps
	;;
esac
if [ ! -z "$2" ]; then
	YAML_FILE="-f $2"
fi
sudo --preserve-env=PING_IDENTITY_DEVOPS_TAG,PING_IDENTITY_DEVOPS_USER,PING_IDENTITY_DEVOPS_KEY,PING_IDENTITY_DEVOPS_HOME /usr/local/bin/docker-compose $YAML_FILE $DCMD

