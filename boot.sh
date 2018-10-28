sudo systemctl start firewalld
sudo systemctl start httpd
sudo systemctl start mariadb
echo -e "\n$1 is ready for development! 🦖\nSITE $1.test\nIP ADDRESS: $(hostname -I)\n"