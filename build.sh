#!/bin/sh
mkdir "$1/modules/"
docker run -it --rm -v"$(pwd)/$1":/run/ alpine /run/buildext.sh