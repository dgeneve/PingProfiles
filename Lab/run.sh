#/bin/bash
OPTION=$1
main()
{
if [ -z "$OPTION" ]; then
	show_help
	exit
fi
case "$OPTION" in
	up)
		DCMD="up -d"
	;;
	down)
		DCMD=down
	;;
	ps)
		DCMD=ps
	;;
	*)
		echo "Invalid option"
		show_help
		exit
	;;
esac
if [ ! -z "$YAML_FILE" ]; then
	YAML_CMD="-f $YAML_FILE"
fi
sudo --preserve-env=PING_IDENTITY_DEVOPS_TAG,PING_IDENTITY_DEVOPS_USER,PING_IDENTITY_DEVOPS_KEY,PING_IDENTITY_DEVOPS_HOME /usr/local/bin/docker-compose $DCMD
}
show_help()
{
echo "Usage: "
echo "./run.sh up"
echo "./run.sh down"
echo "./run.sh ps"
}
main
