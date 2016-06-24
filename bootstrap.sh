#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PROJECTFOLDER='myproject'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"
sudo mkdir "/var/www/html/${PROJECTFOLDER}/public_html"

# set PHP 5.6
sudo add-apt-repository ppa:ondrej/php5-5.6

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php
sudo apt-get install -y apache2
sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}/public_html"
    <Directory "/var/www/html/${PROJECTFOLDER}/public_html">
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

# install xdebug
apt-get -y install php5-dev php-pear
apt-get -y install make
pecl install xdebug
xdebugsolocation="$(find / -name 'xdebug.so' 2> /dev/null)"
echo "
[xdebug]
zend_extension=\"$xdebugsolocation\"
xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_host=192.168.33.22
;xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.remote_log=/tmp/php5-xdebug.log
xdebug.max_nesting_level=400
" | sudo tee /etc/php5/apache2/php.ini -a

# custom php.ini config 
echo "
max_execution_time=300
max_input_vars = 2000
memory_limit = 1024M
upload_max_filesize = 100M
" | sudo tee /etc/php5/apache2/php.ini -a

# restart apache
service apache2 restart

# install composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# install phpunit
wget https://phar.phpunit.de/phpunit.phar --referer=https://phar.phpunit.de
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit


