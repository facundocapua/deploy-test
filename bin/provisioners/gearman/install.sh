#!/usr/bin/env bash
apt-get install -y gearman gearman-job-server gearman-tools libgearman-dev and libevent-dev 

pecl install gearman-1.0.3

echo extension=gearman.so | tee /etc/php5/mods-available/gearman.ini
ln -s /etc/php5/mods-available/gearman.ini /etc/php5/conf.d/20-gearman.ini
