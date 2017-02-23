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
