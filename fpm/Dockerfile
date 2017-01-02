FROM alpine:latest
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP YAF with php-fpm"

ENV FPM_PORT=9000 \
	FPM_USER=www-data \
	TIMEZONE=UTC \
	MAX_UPLOAD=50M 	
	
# instal PHP-fpm
RUN	PHP_INI='/etc/php5/php.ini' \
	&& FPM_CONF=/etc/php5/php-fpm.conf \
	&& FPM_PATH=/etc/php5/fpm.d \	
	&& apk add --no-cache \
		php5-fpm \
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
	# config
	&& echo -e "[global] \
		\n error_log = /proc/self/fd/2 \
		\n include = ${FPM_PATH}/*.conf "> $FPM_CONF \
	&& ADD_CONF(){ echo "$*">> $FPM_PATH/www.conf;} \
	&& ADD_CONF [www] \
	&& ADD_CONF user = $FPM_USER \
	&& ADD_CONF group = $FPM_USER \
	&& ADD_CONF listen = $FPM_PORT \
	&& ADD_CONF pm = dynamic \
	&& ADD_CONF pm.max_children = 5 \
	&& ADD_CONF pm.start_servers = 1 \
	&& ADD_CONF pm.min_spare_servers = 1 \
	&& ADD_CONF pm.max_spare_servers = 3 \
	&& ADD_CONF access.log = /proc/self/fd/2 \
	&& ADD_CONF clear_env = no \
	&& ADD_CONF catch_workers_output = yes \
	&& addgroup -g 82 -S $FPM_USER \
	&& adduser -u 82 -D -S -G $FPM_USER $FPM_USER \
		&& CHANGE_INI(){ \
		if [ $(cat ${PHP_INI} | grep -c "^\s*$1") -eq 0 ] ;\
		then echo "$1=$2" >> ${PHP_INI} ;\ 
		else sed -i "s/^\s*$1.*$/$1=$2/" ${PHP_INI}; fi; } \
	&& CHANGE_INI date.timezone ${TIMEZONE} \
	&& CHANGE_INI upload_max_filesize ${MAX_UPLOAD} \
	&& CHANGE_INI cgi.fix_pathinfo 0 \
	&& CHANGE_INI display_errors 1 \
	&& CHANGE_INI display_startup_errors 1 \
	&& ADD_EXT(){ echo "extension = ${1}.so; \\n${2}" > "/etc/php5/conf.d/90_${1}.ini"; } \
	&& ADD_EXT redis \
	&& ADD_EXT memcached \
	&& ADD_EXT yaf "[yaf]\\nyaf.environ = dev" \
	# Clean
	&& rm -rf /var/cache/apk/* \
		/var/tmp/* \
		# /etc/ssl/* \
		/etc/init.d/php-fpm \
		/usr/include/* \
		/tmp/* 

EXPOSE $FPM_PORT

CMD ["/usr/bin/php-fpm","-F"]
