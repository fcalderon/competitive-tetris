#!/bin/bash

export PORT=5105
export MIX_ENV=prod
export GIT_PATH=/home/tetris/src/competitive-tetris

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "tetris" ]; then
	echo "Error: must run as user 'tetris'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/competitivetetris ]; then
	echo mv ~/www/competitivetetris ~/old/$NOW
	mv ~/www/competitivetetris ~/old/$NOW
fi

mkdir -p ~/www/competitivetetris
REL_TAR=~/src/competitive-tetris/_build/prod/rel/competitivetetris/releases/0.0.1/competitivetetris.tar.gz
(cd ~/www/competitive-tetris && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tetris/src/competitive-tetris/start.sh
CRONTAB

#. start.sh