FROM alpine:latest
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP YAF"

# Environments
ENV TIMEZONE=UTC \
	PHP_MEMORY_LIMIT=512M \
	MAX_UPLOAD=50M \
	PHP_INI=/etc/php5/php.ini \
	PORT=80

# instal PHP
RUN	apk add --no-cache \
		libmemcached-libs \
	#php and ext
		php5-mcrypt \
		php5-openssl \
        php5-curl \
		php5-json \
		php5-dom \
		php5-bcmath \
		php5-gd \
        php5-pdo \
		php5-pdo_mysql \
		php5-pdo_sqlite \
        php5-pdo_odbc \
    	php5-pdo_dblib \
		php5-gettext \
		php5-memcache \
		php5-iconv \
		php5-ctype \
		php5-phar \
		php5-cli\
    # Set php.ini
    && CHANGE_INI(){ \
        if [ $(cat ${PHP_INI} | grep -c "^\s*$1") -eq 0 ] ;\
        then echo "$1=$2" >> ${PHP_INI} ;\ 
        else sed -i "s/^\s*$1.*$/$1=$2/" ${PHP_INI}; fi; } \
	&& CHANGE_INI date.timezone ${TIMEZONE} \
	&& CHANGE_INI upload_max_filesize ${MAX_UPLOAD} \
	&& CHANGE_INI cgi.fix_pathinfo 0 \
	&& CHANGE_INI display_errors 1 \
	&& CHANGE_INI display_startup_errors 1 \
	&& ADD_INI(){ echo "$*">> $PHP_INI; } \
	&& ADD_INI extension = redis.so \
	&& ADD_INI extension = memcached.so \
	&& ADD_INI extension = yaf.so \
	&& ADD_INI [yaf] \
	&& ADD_INI yaf.environ = dev \
	# ClEAN
	&& rm -rf /var/cache/apk/* /var/tmp/* /tmp/* /etc/ssl/* /usr/include/*

#COPY build extensions 
COPY modules/ /usr/lib/php5/modules/

WORKDIR /newfuture/yaf

EXPOSE $PORT
	
CMD php -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo '-t public')
