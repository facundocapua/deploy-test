#!/usr/bin/env bash
apt-get -y install php5-common php5-mysql php5-dev php5-mcrypt php5-gd php5-curl php5-cli ssl-cert php-pear

service php5-fpm start