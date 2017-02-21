#!/bin/sh
mkdir php5/modules
docker run --it --rm -v"$(pwd)"/php5:/run/ alpine /run/buildext.sh