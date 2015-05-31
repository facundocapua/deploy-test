#!/usr/bin/env bash

apt-get -y install redis-server

pecl install redis

echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
ln -s /etc/php5/mods-available/redis.ini /etc/php5/conf.d/20-redis.ini