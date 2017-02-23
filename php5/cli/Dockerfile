FROM alpine:latest
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP5 YAF"

# Environments
ENV PORT=80 \
	TIMEZONE=UTC \
	MAX_UPLOAD=50M \
	DISPLAY_ERROR=1 \
	STARTUP_ERROR=1 \
	PHP_INI="/etc/php5/php.ini"
#ENV_FOR_FPM

# instal PHP
RUN	PHP_CONF="/etc/php5/conf.d" \
    && apk add --no-cache php5-cli\
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
		php5-iconv \
		php5-ctype \
		php5-phar \
	# Set php.ini
	&& ADD_EXT(){ echo -e "extension = ${1}.so; \n${2}" > "$PHP_CONF/${1}.ini"; } \
	&& ADD_EXT redis \
	&& ADD_EXT memcached \
	&& ADD_EXT yaf "[yaf]\nyaf.environ = dev" \
	#ClEAN_TAG \
	&& rm -rf /var/cache/apk/* \
		/var/tmp/* \
		/tmp/* \
		/etc/ssl/certs/*.pem \
		/etc/ssl/certs/*.0 \
		/usr/share/ca-certificates/mozilla/* \
		/usr/share/man/* \
		/usr/include/*

#COPY build extensions 
COPY ./modules/*.so /usr/lib/php5/modules/
COPY entry.sh /entry.sh

WORKDIR /yaf

EXPOSE $PORT

ENTRYPOINT [ "/entry.sh" ]

#CMD
CMD  php -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo "-t public")
