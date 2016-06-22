# vagrant-lamp

Vagrantfile / bootstrap.sh to setup a LAMP stack


* setup a Ubuntu 14.04 LTS "Trustry Thar" 64bit box

* make the box accessable by the host at IP `33.33.33.10`

* sync the current folder with `/var/www/html` inside the box

* automatically perform all the commands in bootstrap.sh directly after setting up the box for the first time

The bootstrap.sh will:

* update, upgrade

* create a folder inside /var/www/html

* install apache 2.4, php 5.6 (5.5), MySQL, PHPMyAdmin, git,composer,xdebug, phpunit

* also setting a pre-chosen password for MySQL and PHPMyAdmin

* activate mod_rewrite and add *AllowOverride All* to the vhost settings

You can folder and password inside the bootstrap.sh for sure.

### How to use ?

Put `Vagrantfile` and `bootstrap.sh` inside a folder and do a `vagrant up` on the command line.
This box uses Ubuntu 14.04 LTS "Trustry Thar" 64bit, so if you don't have the basic box already, do a 
`vagrant box add ubuntu/trusty64` before.

Set C:\Windows\System32\drivers\etc\host 
33.33.33.10       test.vm
