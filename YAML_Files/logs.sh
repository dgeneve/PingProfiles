#/bin/bash
if [ -z $1 ]; then
	echo "Usage ./logs.sh docker-compose-file.yaml"
else
	sudo /usr/local/bin/docker-compose -f $1 logs
fi
