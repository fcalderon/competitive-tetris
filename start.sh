#!/bin/bash

export PORT=5105

cd ~/www/competitivetetris
./bin/competitivetetris stop || true
./bin/competitivetetris start
