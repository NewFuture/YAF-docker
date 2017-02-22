#!/bin/sh

TAG_NAME="newfuture_$1"
CLI_PATH="$(pwd)/docker/$1/cli/"
mkdir -p "$CLI_PATH"

docker build -t $TAG_NAME "./$1/modules/"
docker run -it --rm -v"$CLI_PATH/":/newfuture/yaf/ $TAG_NAME

# build Dockerfile

sed -e 's/${VER_NUM}/5/' -e 's/${PHP_PKG}/php5-cli/' template/cli.Dockerfile > "$CLI_PATH/Dockerfile"
