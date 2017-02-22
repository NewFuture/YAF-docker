#!/bin/sh
# CONFIG FPM
echo -e "[global] \n error_log = /proc/self/fd/2 \n include = ${FPM_PATH}/*.conf " > ${FPM_CONF}
ADD_CONF(){ 
    echo "$*">> ${FPM_PATH}www.conf
}
if [ ! -f "${FPM_PATH}www.conf" ] ; then
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
addgroup -g 82 -S $FPM_USE
adduser -u 82 -D -S -G $FPM_USER $FPM_USER
#!/bin/sh
set -e
#conf PHP
CHANGE_INI(){
    if [ $(cat ${PHP_INI} | grep -c "^\s*$1") -eq 0 ] ;
        then echo "$1=$2" >> ${PHP_INI}
        else sed -i "s/^\s*$1.*$/$1=$2/" ${PHP_INI}
    fi
}
[ "${TIMEZONE}" ] && CHANGE_INI date.timezone ${TIMEZONE}
[ "${MAX_UPLOAD}" ] && CHANGE_INI upload_max_filesize ${MAX_UPLOAD}
[ "${DISPLAY_ERROR}" ] && CHANGE_INI display_errors ${DISPLAY_ERROR}
[ "${STARTUP_ERROR}" ] && CHANGE_INI display_startup_errors ${STARTUP_ERROR}
[ "${ASSERTIONS}" ] && CHANGE_INI zend.assertions ${ASSERTIONS}

exec "$@"
