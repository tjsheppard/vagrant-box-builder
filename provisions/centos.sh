echo -e "\n####### 1. DEPENDENCIES #######################\n"
sudo yum update -y
sudo yum install nano -y
sudo yum install nmap -y
sudo yum install httpd -y
sudo yum install epel-release -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum install yum-utils -y
sudo yum install curl -y
sudo yum install mod_ssl -y

echo -e "\n####### 2. SELINUX ############################\n"
sudo setenforce 0
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config

echo -e "\n####### 3. FIREWALL ###########################\n"
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --remove-service=dhcpv6-client --permanent
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --add-service=mysql --permanent
sudo firewall-cmd --reload

echo -e "\n####### 4. PHP ################################\n"
sudo yum-config-manager --enable remi-php72
sudo yum install php -y
sudo yum install php-mysqlnd php-mysql php-fpm php-mbstring php-intl php-simplexml php-zip php-openssl php-pdo php-tokenizer php-xml php-ctype php-json -y

echo -e "\n####### 5. APACHE #############################\n"
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir /var/www/$1.local/
sudo mkdir /var/www/logs/
sudo chmod -R 777 /etc/httpd/conf.d
sudo echo -e "<VirtualHost *:80>\n\tServerAdmin tom@$1.local\n\tServerName $1.local\n\tServerAlias www.$1.local\n\tDocumentRoot /var/www/$1.local\n\tErrorLog /var/www/logs/error.log\n\tCustomLog /var/www/logs/access.log combined\n\t<Directory "/var/www/$1.local">\n\t\tAllowOverride\n\t\tOrder allow,deny\n\t\tAllow from all\n\t\tRequire all granted\n\t\tAllowOverride All\n\t</Directory>\n</VirtualHost>" >> /etc/httpd/conf.d/000-$1.local.conf
sudo chmod -R 777 /etc/httpd/conf.d/000-$1.local.conf
sudo chown root:root /etc/httpd/conf.d/000-$1.local.conf
sudo echo -e "To Infinity and beyond! Now just add '$(hostname -I)   $1.local' to your hosts file 🚀" >> /var/www/$1.local/index.html
sudo systemctl restart httpd

echo -e "\n####### 6. COMPOSER #############################\n"
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

echo -e "\n####### 7. MYSQL ##############################\n"
sudo curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sudo yum install MariaDB-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
mysql_secure_installation <<EOF

y
vagrant
vagrant
y
y
y
y
y
EOF

echo -e "\n####### 8. NODE.JS ##############################\n"
sudo curl -sL https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum install nodejs -y

echo -e "\n$1 was built! Now 'vagrant reload' to restart the box and get ready to develop 🦕\n"

# CREATE DATABASE
# XDEBUG
# SETUP SSL



