#!/bin/sh

OUT_PATH="$(pwd)/docker/$1/modules"
TAG_NAME="newfuture_$1"
mkdir -p "$OUT_PATH"
mkdir -p docker/php5/cli

# docker run -it --rm -v"$(pwd)/$1":/run/ alpine /run/buildext.sh

docker build -t $TAG_NAME "./$1/modules/"

docker run -it --rm -v"$OUT_PATH":/modules/ $TAG_NAME

sudo chown -R $USER $OUT_PATH
ls -al docker/
ls -al $OUT_PATH 


cp php5/Dockerfile docker/php5/cli/
