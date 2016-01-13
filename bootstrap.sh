#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='evendate'
PROJECTFOLDER='evendate'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2 apache2-doc apache2-utils
sudo add-apt-repository -y ppa:ondrej/php-7.0
sudo apt-get update
sudo apt-get install -y php7.0

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

# install mysql and give password to installer
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
#sudo apt-get -y install mysql-server
#sudo apt-get install php5-mysql

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

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git