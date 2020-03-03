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
	start)
		DCMD=start
	;;
	stop)
		DCMD=stop
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
/usr/local/bin/docker-compose $DCMD
}
show_help()
{
echo "Usage: "
echo "./run.sh up"
echo "./run.sh down"
echo "./run.sh ps"
}
main
