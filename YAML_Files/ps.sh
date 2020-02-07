#/bin/bash
if [ -z $1 ]; then
	echo "Usage ./ps.sh docker-compose-file.yaml"
else
	sudo /usr/local/bin/docker-compose -f $1 ps
fi
