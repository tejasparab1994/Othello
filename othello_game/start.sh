#!/usr/bin/env bash

#!/bin/bash

export PORT=4000

cd ~/www/othello
./bin/othello_game stop || true
./bin/othello_game start
