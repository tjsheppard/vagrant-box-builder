if [ "$3" = "ubuntu/bionic64" ]; then
    echo -e "Dependencies setup"
    sudo service apache2 restart
elif [ "$3" = "centos/7" ]; then
    sudo systemctl restart firewalld
    sudo systemctl restart httpd
    sudo systemctl restart mariadb
    sudo yum update -y
else
    echo -e "OS did not match the boot script"
fi