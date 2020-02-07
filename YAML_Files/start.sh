#/bin/bash
if [ -z $1 ]; then
	echo "Usage ./start.sh docker-compose-file.yaml"
else
	sudo /usr/local/bin/docker-compose -f $1 up -d
fi
