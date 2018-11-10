echo -e "\n####### DEPENDENCIES #######################\n"
if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "Dependencies setup"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install figlet -y
elif [ "$3" = "centos/7" ]; then
    sudo yum update -y
    sudo yum install nano -y
    sudo yum install nmap -y
    sudo yum install curl -y
    sudo yum install epel-release -y
    sudo yum install figlet -y
else
    echo -e "no dependencis"
fi



echo -e "\n####### GIT #######################\n"
if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "Git setup"
elif [ "$3" = "centos/7" ]; then
    sudo yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm -y
    sudo yum install git -y
    if [ "$5" != "" ] || [ "$6" != "" ]; then
        sudo git config --global user.name "$5"
        sudo git config --global user.email $6
    fi
else
    echo -e "no git"
fi



echo -e "\n####### SELINUX ############################\n"
if [ "$3" = "centos/7" ]; then
    sudo setenforce 0
    sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
else
    echo -e "------- SKIPPED"
fi



echo -e "\n####### FIREWALL ###########################\n"
if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "Firewall setup"
elif [ "$3" = "centos/7" ]; then
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    sudo firewall-cmd --remove-service=dhcpv6-client --permanent
    sudo firewall-cmd --add-service=http --permanent
    sudo firewall-cmd --add-service=https --permanent
    sudo firewall-cmd --add-service=mysql --permanent
    sudo firewall-cmd --reload
else
    echo -e "no git"
fi

echo -e "\n####### PHP ################################\n"
if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "php setup"
elif [ "$3" = "centos/7" ]; then
    sudo yum install epel-release -y
    sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
    sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
    sudo yum install yum-utils -y

    if [ $4 -eq 72 ]; then
        sudo yum-config-manager --enable remi-php72
    elif [ $4 -eq 71 ]; then
        sudo yum-config-manager --enable remi-php71
    elif [ $4 -eq 70 ] || [ $4 -eq 7 ]; then
        sudo yum-config-manager --enable remi-php70
    elif [ $4 -eq 56 ] || [ $4 -eq 5 ]; then
        sudo yum-config-manager --enable remi-php56
    else
        echo -e "PHP not installed"
    fi

    if [ $4 -eq 72 ] || [ $4 -eq 71 ] || [ $4 -eq 70 ] || [ $4 -eq 7 ] || [ $4 -eq 56 ] || [ $4 -eq 5 ]; then
        sudo yum install php -y
        sudo yum install php-mysqlnd -y
        sudo yum install php-mysql -y
        sudo yum install php-mcrypt -y
        sudo yum install php-fpm -y
        sudo yum install php-mbstring -y
        sudo yum install php-intl -y
        sudo yum install php-simplexml -y
        sudo yum install php-zip -y
        sudo yum install php-openssl -y
        sudo yum install php-pdo -y
        sudo yum install php-tokenizer -y
        sudo yum install php-xml -y
        sudo yum install php-ctype -y
        sudo yum install php-json -y
        sudo yum install curl -y
        sudo yum install php-devel -y
        sudo yum install php-pear -y
    fi
else
    echo -e "no php"
fi

echo -e "\n####### APACHE #############################\n"

VHOST="<VirtualHost *:80>
    ServerAdmin webmaster@$1$2
    ServerName $1$2
    ServerAlias www.$1$2
    DocumentRoot /var/www/$1$2
    ErrorLog /var/www/logs/error.log
    CustomLog /var/www/logs/access.log combined
    <Directory '/var/www/$1$2'>
        Options Indexes FollowSymLinks
        AllowOverride all
        Require all granted
    </Directory>
</VirtualHost>"

VHOSTSSL="<VirtualHost *:443>
    ServerAdmin webmaster@$1$2
    ServerName $1$2
    ServerAlias www.$1$2
    DocumentRoot /var/www/$1$2
    ErrorLog /var/www/logs/error-ssl.log
    CustomLog /var/www/logs/access-ssl.log combined
    <Directory '/var/www/$1$2'>
        Options Indexes FollowSymLinks
        AllowOverride all
        Require all granted
    </Directory>
    SSLEngine on
    SSLCertificateFile /var/www/ssl/server.crt
    SSLCertificateKeyFile /var/www/ssl/server.key
</VirtualHost>"

INDEX="$(hostname -I) $1$2 🚀 <?php phpinfo() ?>"

if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "apache setup"
elif [ "$3" = "centos/7" ]; then
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo yum install mod_ssl -y
    sudo mkdir /var/www/$1$2/
    sudo mkdir /var/www/logs/
    sudo chmod -R 777 /etc/httpd/conf.d
    echo "$VHOST" | sudo tee /etc/httpd/conf.d/000-$1$2.conf
    echo "$VHOSTSSL" | sudo tee /etc/httpd/conf.d/000-ssl-$1$2.conf
    echo "$INDEX" | sudo tee /var/www/$1$2/index.php
    echo "ServerName $1" | sudo tee /etc/httpd/conf.d/servername.conf
    sudo chmod -R 777 /etc/httpd/conf.d/
    sudo chown root:root /etc/httpd/conf.d/
    rm -rf /var/www/cgi-bin
else
    echo -e "no apache"
fi

echo -e "\n####### COMPOSER #############################\n"
if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "composer setup"
elif [ "$3" = "centos/7" ]; then
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    sudo php composer-setup.php
    sudo php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
else
    echo -e "no composer"
fi

echo -e "\n####### MYSQL ##############################\n"
if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "mysql setup"
elif [ "$3" = "centos/7" ]; then
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
else
    echo -e "no mysql"
fi

echo -e "\n####### NODE.JS ##############################\n"
if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "node setup"
elif [ "$3" = "centos/7" ]; then
    sudo curl -sL https://rpm.nodesource.com/setup_8.x | sudo bash -
    sudo yum install nodejs -y
else
    echo -e "no node"
fi


echo -e "\n####### SSL ##############################\n"
sudo mkdir /var/www/ssl
sudo chmod -R 777 /var/www/ssl
cd /var/www/ssl

SERVERCSRCNF="[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=GB
ST=$1
L=$1
O=$1
OU=$1
emailAddress=$1@email.com
CN = $1$2"

V3EXT="authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $1$2"

echo "$SERVERCSRCNF" | sudo tee server.csr.cnf
echo "$V3EXT" | sudo tee v3.ext

openssl genrsa -des3 -out rootCA.key -passout pass:$1 2048

openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -passin pass:$1 -config <( cat server.csr.cnf ) -out rootCA.pem

openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout server.key -config <( cat server.csr.cnf )

openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -passin pass:$1 -days 500 -sha256 -extfile v3.ext



echo -e "\n####### XDEBUG ##############################\n"

    if [ "$3" = "ubuntu/bionic64" ]; then
        echo -e "xdebug setup"
    elif [ "$3" = "centos/7" ]; then
        sudo yum install gcc gcc-c++ autoconf automake
        sudo pecl install Xdebug
        XDEBUG="[xdebug]
        zend_extension='/usr/lib64/php/modules/xdebug.so'
        xdebug.remote_enable = 1"
        echo "$XDEBUG" | sudo tee /etc/php.d/xdebug.ini
        sudo chmod -R 777 /etc/php.d/xdebug.ini
    else
        echo -e "no xdebug"
    fi

# sudo chmod -R 777 /etc/profile.d/

# MESSAGE="
# ===============================================
#  - Project/Hostname........: $(uname -n)
#  - Internet Protocol.......: $(hostname -I)
# ==============================================="

# echo "$MESSAGE" | sudo tee /etc/profile.d/message.sh

# sudo chmod -R 777 /etc/profile.d/message.sh