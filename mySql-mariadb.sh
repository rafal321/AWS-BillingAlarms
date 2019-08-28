
# sudo yum install ncurses-compat-libs   For Amazon Linux2
sudo yum install mariadb-server 
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
#---
mysql_secure_installation
###  LOG FILE
less /var/log/mariadb/mariadb.log
### CONFIG
less /etc/my.cnf.d/server.cnf
### UNIT file - not to be messed with
# /lib/systemd/system/mariadb.service

### My usefull commands
ss -tulpn | grep mysql
