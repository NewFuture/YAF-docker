FROM alpine

ENV DIR="/newfuture/yaf" \
    PHP="php5"

WORKDIR $DIR
VOLUME ["/home/newfuture/docker/YAF-docker/modules","$DIR"]


RUN apk update && apk upgrade

RUN apk add \
        curl \
        autoconf \
        pkgconf \
        file \
        g++ \
        gcc \
        make \
        zlib-dev \
        re2c \
        libmemcached-dev \
        cyrus-sasl-dev

RUN apk add \
        "${PHP}" \
        "${PHP}-dev"

RUN  TMP="/tmp/" &&\
     BUILD(){ \
        curl -#SL https://pecl.php.net/get/$1.tgz | tar zx -C $TMP \
        && cd "$TMP/$1" && phpize5 &&./configure --with-php-config=php-config5 && make test && make install \
        && cp ${TMP}$1/modules/*.so /modules/;} \
    && mkdir /modules/ \
    && BUILD redis-3.1.1 \
    && BUILD yaf-2.3.5 \
    && BUILD memcached-2.2.0

CMD cp -R /modules "$DIR"
