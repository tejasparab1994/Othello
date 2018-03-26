#!/usr/bin/env bash

export PORT=4000
export MIX_ENV=prod
export GIT_PATH=/home/othello/src/Othello/othello_game

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "othello" ]; then
	echo "Error: must run as user 'othello'"
	echo "  Current user is $USER"
	exit 2
fi


mix deps.get
(cd apps/othello_hall/assets && npm install)
(cd apps/othello_hall/assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod


mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/othello ]; then
	echo mv ~/www/othello ~/old/$NOW
	mv ~/www/othello ~/old/$NOW
fi

mkdir -p ~/www/othello
REL_TAR=~/src/Othello/othello_game/_build/prod/rel/othello_game/releases/0.0.1/othello_game.tar.gz
(cd ~/www/othello && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tasktracker/src/tasktracker/start.sh
CRONTAB

#. start.sh