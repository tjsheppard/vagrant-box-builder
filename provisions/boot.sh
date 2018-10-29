sudo systemctl start firewalld
sudo systemctl start httpd
sudo systemctl start mariadb
sudo yum update -y
echo -e "\n$1 is ready for development! 🦖\nSITE $1.local\nIP ADDRESS: $(hostname -I)\n"