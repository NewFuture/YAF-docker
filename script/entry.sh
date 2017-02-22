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