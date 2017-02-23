#!/bin/sh

set -e
TAG_NAME="newfuture_$1"

CLI_PATH="$(pwd)/docker/$1/cli/"
FPM_PATH="$(pwd)/docker/$1/fpm/"
TMP_PATH="/tmp/$1/"
mkdir -p "$CLI_PATH" "$FPM_PATH" "$TMP_PATH"

# build modules
if [ "$1" = "php5" ]; then
sed -e 's/${VER_NUM}/5/g' \
    -e 's/${PHP_PKG}/php5/' \
    -e 's/${YAF}/yaf-2.3.5/' \
    -e 's/${MEMCACHED}/memcached-2.2.0/' \
    template/modules > $TMP_PATH/Dockerfile
else
sed -e 's/${VER_NUM}/7/g' \
    -e 's/${PHP_PKG}/php7 php7-session/' \
    -e 's/${YAF}/yaf-3.0.4/' \
    -e 's/${MEMCACHED}/memcached-3.0.3/' \
    template/modules > $TMP_PATH/Dockerfile
fi

docker build -t $TAG_NAME "$TMP_PATH"
docker run -it --rm -v"$CLI_PATH/":/newfuture/yaf/ $TAG_NAME

cp script/entry.sh "$CLI_PATH"
cp -R ${CLI_PATH}* "$FPM_PATH"

cp script/fpm-entry.sh "$FPM_PATH/entry.sh"
cat script/entry.sh >> "$FPM_PATH/entry.sh"

# build Dockerfile

if [ "$1" = "php5" ]; then
sed -e 's/${VER_NUM}/5/g' \
    -e 's/${PHP_PKG}/php5-cli/' \
    template/Dockerfile > "$CLI_PATH/Dockerfile"

sed -e 's/${VER_NUM}/5/g' \
    -e 's/${PHP_PKG}/php5-fpm/' \
    -e 's/PORT=80/PORT=9000/' \
    -e "s,#ENV_FOR_FPM,ENV FPM_USER=www FPM_CONF=/etc/$1/php-fpm.conf FPM_PATH='/etc/$1/fpm.d/'," \
    template/Dockerfile > "$FPM_PATH/Dockerfile"
else
    sed -e 's/${VER_NUM}/7/g' \
        -e 's/${PHP_PKG}/php7 php7-session/' \
        template/Dockerfile > "$CLI_PATH/Dockerfile"

    sed -e 's/${VER_NUM}/7/g' \
        -e 's/${PHP_PKG}/php7-fpm php7-session/' \
        -e 's/PORT=80/PORT=9000/' \
        -e "s,#ENV_FOR_FPM,ENV FPM_USER=www FPM_CONF=/etc/$1/php-fpm.conf FPM_PATH='/etc/$1/fpm.d/'," \
        template/Dockerfile > "$FPM_PATH/Dockerfile"
fi


echo 'CMD ["/usr/bin/php-fpm","-F"]'>>"$FPM_PATH/Dockerfile"

echo 'CMD  php -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo "-t public")'>>"$CLI_PATH/Dockerfile"
