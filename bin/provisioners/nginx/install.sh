#!/usr/bin/env bash

#Install Nginx
apt-get -y install nginx php5-fpm
update-rc.d -f nginx defaults
service nginx start

sed -i '/display_errors = Off/c display_errors = On' /etc/php5/fpm/php.ini
sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/fpm/php.ini
sed -i '/html_errors = Off/c html_errors = On' /etc/php5/fpm/php.ini

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
NGINX_FOLDER="/etc/nginx/"
mv ${NGINX_FOLDER}nginx.conf ${NGINX_FOLDER}nginx.conf.orig
cp ${DIR}nginx.conf ${NGINX_FOLDER}nginx.conf

mkdir /var/www