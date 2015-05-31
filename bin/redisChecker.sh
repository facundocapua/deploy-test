#!/bin/sh
DIR="/webapps/www/sites/current/source/var/session"

if [ "$(ls -A $DIR)" ]; then
    echo "Restarting PHP service"
    sudo service php54-php-fpm restart

    echo "Removing session files"
    rm -rf ${DIR}/*
else
    echo "$DIR is Empty"
fi