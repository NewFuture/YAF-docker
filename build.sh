#!/bin/sh

set -e
TAG_NAME="newfuture_$1"

CLI_PATH="$(pwd)/docker/$1/cli/"
FPM_PATH="$(pwd)/docker/$1/fpm/"
TMP_PATH="/tmp/$1/"
APK_PKG="$1"
PHP_EXT='yaf-3.0.5'
ADD_EXT='#ADD_EXT'
PRE_FPM='#ClEAN_TAG'

if [ "$1" = "php5" ]; then
PHP_VER="5"
PHP_EXT='yaf-2.3.5 \&\& BUILD memcached-2.2.0 \&\& BUILD redis-3.1.4 '
ADD_EXT='\&\& ADD_EXT redis \&\& ADD_EXT memcached'
CLI_PKG="php5-cli "
FPM_PKG="php5-fpm "
else
PHP_VER="7"
APK_PKG="${APK_PKG} php7-session php7-memcached php7-redis "
CLI_PKG="${APK_PKG}"
FPM_PKG="${APK_PKG} php7-fpm"
PRE_FPM='\&\& ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm'
fi

mkdir -p "$CLI_PATH" "$FPM_PATH" "$TMP_PATH"

# build modules
sed -e "s/\${VER_NUM}/${PHP_VER}/g" \
    -e "s/\${PHP_PKG}/${APK_PKG}/" \
    -e "s/\${PHP_EXT}/${PHP_EXT}/" \
    template/modules > $TMP_PATH/Dockerfile

docker build -t $TAG_NAME "$TMP_PATH"
docker run -it --rm -v"$CLI_PATH/":/newfuture/yaf/ $TAG_NAME

cp script/entry.sh "$CLI_PATH"
cp -R ${CLI_PATH}* "$FPM_PATH"

cp script/fpm-entry.sh "$FPM_PATH/entry.sh"
cat script/entry.sh >> "$FPM_PATH/entry.sh"

# build Dockerfile
sed -e "s/\${VER_NUM}/${PHP_VER}/g" \
    -e "s/\${PHP_PKG}/${CLI_PKG}/" \
    -e "s,#MORE_ENV,ASSERTIONS=0," \
    -e "s/#ADD_EXT/${ADD_EXT}/" \
    template/Dockerfile > "$CLI_PATH/Dockerfile"

sed -e "s/\${VER_NUM}/${PHP_VER}/g" \
    -e "s/\${PHP_PKG}/${FPM_PKG}/" \
    -e 's/PORT=80/PORT=9000/' \
    -e "s,#MORE_ENV,ASSERTIONS=0 FPM_USER=www FPM_CONF=/etc/$1/php-fpm.conf FPM_PATH='/etc/$1/fpm.d/'," \
    -e "s,#ADD_EXT,${ADD_EXT}," \
    -e "s,#ClEAN_TAG,${PRE_FPM}," \
    template/Dockerfile > "$FPM_PATH/Dockerfile"



echo 'CMD ["/usr/bin/php-fpm","-F"]'>>"$FPM_PATH/Dockerfile"

echo 'CMD  php -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo "-t public")'>>"$CLI_PATH/Dockerfile"

cp README.md docker/
