#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

PROVISIONERS_FOLDER="/vagrant/bin/provisioners/"

mkdir /home/vagrant/log

#Configure misc
if [ ! -f /home/vagrant/log/miscconfiguration ];
then
  sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/vagrant/.bashrc
  sed -i "s/#alias ls='ls --color=auto'/alias ls='ls --color=auto'/g" /home/vagrant/.bashrc
  sed -i "s/#alias ll='ls -l'/alias ll='ls -l'/g" /home/vagrant/.bashrc
  sed -i "s/#alias la='ls -A'/alias la='ls -A'/g" /home/vagrant/.bashrc
  sed -i "/#alias l='ls -CF'/alias l='ls -CF'/g" /home/vagrant/.bashrc

  touch /home/vagrant/log/miscconfiguration
fi

#Percona MySQL
source ${PROVISIONERS_FOLDER}percona-mysql/install.sh

#Install PHP
source ${PROVISIONERS_FOLDER}php/install.sh

#Install Nginx
source ${PROVISIONERS_FOLDER}nginx/install.sh

#Install VIM
source ${PROVISIONERS_FOLDER}vim/install.sh

#Install xDebug
source ${PROVISIONERS_FOLDER}xdebug/install.sh

#Install Redis
source ${PROVISIONERS_FOLDER}redis/install.sh

#Install n98-magerun
source ${PROVISIONERS_FOLDER}n98-magerun/install.sh

#Install gearman
source ${PROVISIONERS_FOLDER}gearman/install.sh