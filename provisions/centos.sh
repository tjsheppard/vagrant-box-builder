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
sudo yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm -y
sudo yum install git -y

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
sudo yum install php-mysqlnd php-mysql php-mcrypt php-fpm php-mbstring php-intl php-simplexml php-zip php-openssl php-pdo php-tokenizer php-xml php-ctype php-json -y

echo -e "\n####### 5. APACHE #############################\n"
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir /var/www/$1.local/
sudo mkdir /var/www/logs/
sudo chmod -R 777 /etc/httpd/conf.d

sudo echo -e "<VirtualHost *:80>\n\tServerAdmin tom@$1.local\n\tServerName $1.local\n\tServerAlias www.$1.local\n\tDocumentRoot /var/www/$1.local\n\tErrorLog /var/www/logs/error.log\n\tCustomLog /var/www/logs/access.log combined\n\t<Directory "/var/www/$1.local">\n\t\tOrder allow,deny\n\t\tAllow from all\n\t\tRequire all granted\n\t\tAllowOverride All\n\t</Directory>\n</VirtualHost>" >> /etc/httpd/conf.d/000-$1.local.conf

sudo chmod -R 777 /etc/httpd/conf.d/000-$1.local.conf
sudo chown root:root /etc/httpd/conf.d/000-$1.local.conf

sudo echo -e "<VirtualHost *:443>\n\tServerAdmin tom@$1.local\n\tServerName $1.local\n\tServerAlias www.$1.local\n\tDocumentRoot /var/www/$1.local\n\tErrorLog /var/www/logs/error-ssl.log\n\tCustomLog /var/www/logs/access-ssl.log combined\n\t<Directory "/var/www/$1.local">\n\t\tOrder allow,deny\n\t\tAllow from all\n\t\tRequire all granted\n\t\tAllowOverride All\n\t</Directory>\n\tSSLEngine on\n\tSSLCertificateFile /var/www/ssl/server.crt\n\tSSLCertificateKeyFile /var/www/ssl/server.key\n</VirtualHost>" >> /etc/httpd/conf.d/000-ssl-$1.local.conf

sudo chmod -R 777 /etc/httpd/conf.d/000-ssl-$1.local.conf
sudo chown root:root /etc/httpd/conf.d/000-ssl-$1.local.conf

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

mysql -uroot -pvagrant<<MYSQL_SCRIPT
CREATE DATABASE $1;
GRANT ALL PRIVILEGES ON $1.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo -e "\n####### 8. NODE.JS ##############################\n"
sudo curl -sL https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum install nodejs -y

echo -e "\n####### 9. SSL ##############################\n"
sudo mkdir /var/www/ssl
sudo chmod -R 777 /var/www/ssl
cd /var/www/ssl

sudo echo -e "[req]\ndefault_bits = 2048\nprompt = no\ndefault_md = sha256\ndistinguished_name = dn\n\n[dn]\nC=GB\nST=$1\nL=$1\nO=$1\nOU=$1\nemailAddress=$1@email.com\nCN = $1.local" >> server.csr.cnf

sudo echo -e "authorityKeyIdentifier=keyid,issuer\nbasicConstraints=CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectAltName = @alt_names\n\n[alt_names]\nDNS.1 = $1.local" >> v3.ext

openssl genrsa -des3 -out rootCA.key -passout pass:$1 2048

openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -passin pass:$1 -config <( cat server.csr.cnf ) -out rootCA.pem

openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout server.key -config <( cat server.csr.cnf )

openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -passin pass:$1 -days 500 -sha256 -extfile v3.ext

# CREATE DATABASE
# XDEBUG