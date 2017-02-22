#!/bin/sh

# FPM_CONF=/etc/php5/php-fpm.conf
echo -e "[global] \n error_log = /proc/self/fd/2 \n include = ${FPM_PATH}/*.conf " > ${FPM_CONF}

if [ !-f "$FPM_PATH/www.conf" ] ; then

    ADD_CONF(){ echo "$*">> $FPM_PATH/www.conf}

    ADD_CONF [www] \
    && ADD_CONF user = $FPM_USER \
    && ADD_CONF group = $FPM_USER \
    && ADD_CONF listen = $PORT \
    && ADD_CONF pm = dynamic \
    && ADD_CONF pm.max_children = 5 \
    && ADD_CONF pm.start_servers = 1 \
    && ADD_CONF pm.min_spare_servers = 1 \
    && ADD_CONF pm.max_spare_servers = 3 \
    && ADD_CONF access.log = /proc/self/fd/2 \
    && ADD_CONF clear_env = no \
    && ADD_CONF catch_workers_output = yes
fi
#!/bin/sh
set -e

CHANGE_INI(){
    if [ $(cat ${PHP_INI} | grep -c "^\s*$1") -eq 0 ] ;
        then echo "$1=$2" >> ${PHP_INI}
        else sed -i "s/^\s*$1.*$/$1=$2/" ${PHP_INI}
    fi
}

CHANGE_INI date.timezone ${TIMEZONE} \
&& CHANGE_INI upload_max_filesize ${MAX_UPLOAD} \
&& CHANGE_INI cgi.fix_pathinfo 0 \
&& CHANGE_INI display_errors 1 \
&& CHANGE_INI display_startup_errors 1 \
&& exec "$@"