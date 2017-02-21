FROM alpine
ENV TMP="/tmp/" \
    DIR="/newfuture/yaf" \
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
        re2c

RUN apk add \
        "$PHP" \
        "$PHP-dev" \
        "$PHP-session"

RUN  BUILD(){ \
        curl -#SL https://pecl.php.net/get/$1.tgz | tar zx -C $TMP \
        && cd "$TMP/$1" && phpize5 &&./configure --with-php-config=php-config5 && make test && make install \
        && cp /$TMP/$1/modules/*.so $DIR;} \
        && BUILD redis-3.1.1 \
        && BUILD yaf-2.3.5 \
        && BUILD memcached-2.2.0
