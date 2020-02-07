#/bin/bash
if [ -z $1 ]; then
	echo "Usage ./shell.sh docker-compose-file.yaml"
else
	sudo /usr/local/bin/docker-compose -f $1 run pingfederate /bin/sh
fi
