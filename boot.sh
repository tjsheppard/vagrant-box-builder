# sudo systemctl start firewalld
# sudo systemctl start httpd
# sudo systemctl start mariadb
# sudo yum update -y

RED="\e[31m"
ORANGE="\e[33m"
BLUE="\e[94m"
GREEN="\e[92m"
STOP="\e[0m"
LINE="##########################################################################################"

printf "${GREEN}"
echo "$LINE"
printf "${STOP}"
printf "${BLUE}"
figlet -f slant "$1"
printf "${STOP}"
printf "${GREEN}"
echo "$LINE"
printf "${STOP}"

echo -e "$2"

echo -e "$3"

echo -e "$4"

echo -e "$5"

echo -e "$6"