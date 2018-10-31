sudo systemctl start firewalld
sudo systemctl start httpd
sudo systemctl start mariadb
sudo yum update -y
echo -e "\n\n$1 was built! If this is your first time do 'vagrant reload' to restart the box and get ready to develop 🦕"
echo -e "\nSITE $1.local\nIP ADDRESS: $(hostname -I) 🦖\n"