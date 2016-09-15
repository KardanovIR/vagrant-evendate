#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='evendate'
PROJECTFOLDER='evendate'

# create project folder
sudo mkdir "/var/www/html/"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.4
sudo apt-get install -y apache2 apache2-doc apache2-utils

# adding postgresql repo
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" > /etc/apt/sources.list.d/postgresql.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# adding php 7.0 repo
sudo apt-get install -y software-properties-common
sudo LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php

# update after repos 
sudo apt-get update

# install php 7.0 and postgresql 9.5
sudo apt-get install -y --force-yes php7.0
sudo apt-get install -y postgresql-9.5

# installing node v 6.* LTS 
sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

#adding libapache2-mod-php7.0
sudo apt-get install libapache2-mod-php7.0
sudo service apache2 restart

#run php script for configurations editing
sudo php /var/www/html/init.php

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/"
    <Directory "/var/www/html/">
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
sudo a2enmod headers

# installing php drivers 
sudo apt-get -y --force-yes install php-pgsql
sudo apt-get -y --force-yes install php-mysql
sudo apt-get -y --force-yes install php-pear
sudo apt-get -y --force-yes install php-dev
sudo pecl install xdebug

# restart apache
service apache2 restart

sudo apt-get -yq --force-yes dist-upgrade
sudo apt-get install -yq language-pack-en-base
sudo locale-gen en_US.UTF-8

# creating database 
sudo -u postgres psql -c "alter user postgres password 'evendate';"
sudo -u postgres psql -c "CREATE DATABASE evendate WITH TEMPLATE = template0 ENCODING = 'UTF8'"
# sudo su postgres
# sudo createdb -E UTF8 -T template0 --locale=en_US.utf8 evendate

# installing dependences
cd /var/www/html/node
sudo npm install --no-bin-links

cd /
sudo wget http://xdebug.org/files/xdebug-2.4.0rc3.tgz
sudo tar -xvzf xdebug-2.4.0rc3.tgz
cd xdebug-2.4.0RC3/
sudo phpize
sudo ./configure
sudo make
sudo cp modules/xdebug.so /usr/lib/php/20151012

sudo service apache2 restart

sudo php -v
sudo psql --version
sudo node -v
sudo apache2 -v


read  -p "Press enter to show phpinfo()" mainmenuinput
sudo php -r "phpinfo();"
