#!/bin/bash

export PORT=5105

cd ~/www/competitive-tetris
./bin/competitive-tetris stop || true
./bin/competitive-tetris start
