FROM newfuture/yaf
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP YAF with php-fpm"

ENV FPM_PORT=9000 \
	FPM_CONF=/etc/php5/php-fpm.conf \
	FPM_PATH=/etc/php5/fpm.d \
	FPM_USER=www-data
	
# instal PHP-fpm
RUN	apk add --no-cache php5-fpm \
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
	# Clean
	&& rm -rf /var/cache/apk/* \
		/var/tmp/* \
		/etc/ssl/* \
		/etc/init.d/php-fpm \
		/usr/include/* \
		/tmp/* 

EXPOSE $FPM_PORT

CMD ["/usr/bin/php-fpm","-F"]
