#!/bin/sh

set -e
TAG_NAME="newfuture_$1"
CLI_PATH="$(pwd)/docker/$1/cli/"
FPM_PATH="$(pwd)/docker/$1/fpm/"
mkdir -p "$CLI_PATH" "$FPM_PATH"

docker build -t $TAG_NAME "./$1/modules/"
docker run -it --rm -v"$CLI_PATH/":/newfuture/yaf/ $TAG_NAME

cp script/entry.sh "$CLI_PATH"
cp -R ${CLI_PATH}* "$FPM_PATH"

cp script/fpm-entry.sh "$FPM_PATH/entry.sh"
cat script/entry.sh >> "$FPM_PATH/entry.sh"

# build Dockerfile

sed -e 's/${VER_NUM}/5/' \
    -e 's/${PHP_PKG}/php5-cli php5-memcache/' \
    template/Dockerfile > "$CLI_PATH/Dockerfile"

sed -e 's/${VER_NUM}/5/g' \
    -e 's/${PHP_PKG}/php5-fpm php5-memcache/' \
    -e 's/PORT=80/PORT=9000/' \
    -e "s,#ENV_FOR_FPM,ENV FPM_USER=www FPM_CONF=/etc/$1/php-fpm.conf FPM_PATH='/etc/$1/fpm-conf.d/'," \
    template/Dockerfile > "$FPM_PATH/Dockerfile"
