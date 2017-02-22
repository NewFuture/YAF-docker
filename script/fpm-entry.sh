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
