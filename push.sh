#/bin/bash
GLOBAL_CONFIG_EXISTS=$(git config -l|grep "user.name"|wc -l)
if [ "${GLOBAL_CONFIG_EXISTS}" == "1" ]; then
	echo "Global config exists."
	git add . --all
	git commit -m "$(date +'%Y-%m-%d_%H:%M:%S')"
	git push origin master
else
	echo "Global config missing"
	echo "Run   git config --global user.email "you@example.com""
	echo "	    git config --global user.name "Your Name""
fi
