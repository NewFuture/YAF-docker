FROM alpine:latest
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP${VER_NUM} YAF"

# Environments
ENV PORT=80 \
	TIMEZONE=UTC \
	MAX_UPLOAD=50M \
    PHP_INI="/etc/php${VER_NUM}/php.ini"

#ENV_FOR_FPM

# instal PHP
RUN	PHP_CONF="/etc/php${VER_NUM}/conf.d" \
    && apk add --no-cache ${PHP_PKG}\
		libmemcached-libs \
	#php and ext
		php${VER_NUM}-mcrypt \
		php${VER_NUM}-openssl \
		php${VER_NUM}-curl \
		php${VER_NUM}-json \
		php${VER_NUM}-dom \
		php${VER_NUM}-bcmath \
		php${VER_NUM}-gd \
		php${VER_NUM}-pdo \
		php${VER_NUM}-pdo_mysql \
		php${VER_NUM}-pdo_sqlite \
		php${VER_NUM}-pdo_odbc \
		php${VER_NUM}-pdo_dblib \
		php${VER_NUM}-gettext \
		php${VER_NUM}-iconv \
		php${VER_NUM}-ctype \
		php${VER_NUM}-phar \
	# Set php.ini
	&& ADD_EXT(){ echo -e "extension = ${1}.so; \n${2}" > "$PHP_CONF/${1}.ini"; } \
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
COPY ./modules/*.so /usr/lib/php${VER_NUM}/modules/

COPY entry.sh /entry.sh


WORKDIR /yaf

EXPOSE $PORT

ENTRYPOINT [ "/entry.sh" ]

CMD php -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo '-t public')
