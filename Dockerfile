FROM alpine:latest
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP YAF"

# Environments
ENV PORT=80 \
	TIMEZONE=UTC \
	MAX_UPLOAD=50M 

# instal PHP
RUN	PHP_INI='/etc/php5/php.ini' \
	&& PHP_CONF='/etc/php5/conf.d' \
	&& apk add --no-cache \
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
	&& ADD_EXT(){ echo -e "extension = ${1}.so; \n${2}" > "$PHP_CONF/90_${1}.ini"; } \
	&& ADD_EXT redis \
	&& ADD_EXT memcached \
	&& ADD_EXT yaf "[yaf]\nyaf.environ = dev" \
	# ClEAN
	&& rm -rf /var/cache/apk/* \
		/var/tmp/* \
		/tmp/* \
		/etc/ssl/certs/*.pem \
		/etc/ssl/certs/*.0 \
		/usr/share/ca-certificates/mozilla/* \
		/usr/share/man/* \
		/usr/include/*

#COPY build extensions 
COPY fpm/modules/*.so /usr/lib/php5/modules/

WORKDIR /newfuture/yaf

EXPOSE $PORT
	
CMD php -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo '-t public')
