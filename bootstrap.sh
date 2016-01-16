#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='evendate'
PROJECTFOLDER='evendate'


# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.4
sudo apt-get install -y apache2 apache2-doc apache2-utils

# adding postgresql repo
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" > /etc/apt/sources.list.d/postgresql.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# adding php 7.0 repo
sudo add-apt-repository -y ppa:ondrej/php-7.0

# update after repos 
sudo apt-get update

# install php 7.0 and postgresql 9.5
sudo apt-get install -y php7.0
sudo apt-get install -y postgresql-9.5

# installing node v 4.* LTS 
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

#run php script for configurations editing
sudo php /var/www/html/init.php


# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf


sudo apt-get update

# enable mod_rewrite
sudo a2enmod rewrite

# installing php drivers 
sudo apt-get -y install php-pgsql
sudo apt-get -y install php-mysql


# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# clonning repo fot mysql2postgres migration from production server
cd /var/www/html/
sudo git clone "https://$1:$2@github.com/KardanovIR/mysql2postgres.git"

# creating database 
sudo -u postgres psql -c "alter user postgres password 'apassword';"
sudo -u postgres psql -c "CREATE DATABASE evendate WITH ENCODING 'UTF8'"

# running migration
cd mysql2postgres
php index.php config.json

cd /var/www/html/${PROJECTFOLDER}/node
sudo npm install --no-bin-links
