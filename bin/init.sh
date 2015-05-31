#!/usr/bin/env bash
PROJECT_DATA_SERVER="192.168.0.119"
PROJECT_DB_NAME="carrefour"
PROJECT_MAGENTO_ROOT="/vagrant/source/"
PROJECT_URL="carrefour.local"
PROJECT_ADMIN_USER="admin"
PROJECT_ADMIN_PASSWORD="Carrefour2014"


#MYSQL DATABASE
if [ ! -f /vagrant/data/db.sql ];
then
  if [ ! -f /vagrant/data/db.tgz ];
  then
    echo "[$0] Downloading Database..."
    scp -oStrictHostKeyChecking=no vagrant@${PROJECT_DATA_SERVER}:carrefour/db.tgz /vagrant/data
  fi

  echo "[$0] Extracting Database..."
  tar -zxvf /vagrant/data/db.tgz -C /vagrant/data
fi

echo "[$0] Importing Database..."
mysql -uroot <<QUERY_INPUT
DROP DATABASE IF EXISTS ${PROJECT_DB_NAME}; CREATE DATABASE ${PROJECT_DB_NAME};USE ${PROJECT_DB_NAME};SOURCE /vagrant/data/db.sql;
QUERY_INPUT


#MEDIA FOLDER
if [ ! -d ${PROJECT_MAGENTO_ROOT}media ];
then
  echo "[$0] Creating Media Folder..."
  mkdir ${PROJECT_MAGENTO_ROOT}media
fi

#VAR FOLDER
if [ ! -d ${PROJECT_MAGENTO_ROOT}var ];
then
  echo "[$0] Creating Media Folder..."
  mkdir ${PROJECT_MAGENTO_ROOT}var
fi

echo "[$0] Applying write permissions..."
chmod -R 777 /vagrant/source/{app/etc,media,var}


#VIRTUAL HOST
echo "[$0] Creating Virtual Host"
sudo ln -s /vagrant/source /var/www/magento

sudo cp /vagrant/conf/nginx/carrefour.conf /etc/nginx/sites-available/$PROJECT_URL
sudo sed -i "s|\$PROJECT_URL|${PROJECT_URL}|g" /etc/nginx/sites-available/$PROJECT_URL
sudo ln -s /etc/nginx/sites-available/$PROJECT_URL /etc/nginx/sites-enabled/$PROJECT_URL
sudo service nginx restart

#MAGENTO INSTALLATION
echo "[$0] Installing Magento..."
rm -f ${PROJECT_MAGENTO_ROOT}app/etc/local.xml
php ${PROJECT_MAGENTO_ROOT}install.php -- \
       --license_agreement_accepted "yes" \
       --locale "en_US" \
       --timezone "America/Los_Angeles" \
       --default_currency "USD" \
       --db_host "localhost" \
       --db_name ${PROJECT_DB_NAME} \
       --skip_url_validation "yes" \
       --db_user "root" \
       --db_pass "" \
       --url "http://${PROJECT_URL}" \
       --secure_base_url "http://${PROJECT_URL}" \
       --use_rewrites "yes" \
       --use_secure "no" \
       --use_secure_admin "no" \
       --admin_firstname "Admin" \
       --admin_lastname "General" \
       --admin_email "admin@carrefour.com" \
       --admin_username "${PROJECT_ADMIN_USER}" \
       --admin_password "${PROJECT_ADMIN_PASSWORD}"