
# sudo yum install ncurses-compat-libs   For Amazon Linux2
sudo yum install mariadb-server 
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
#---
mysql_secure_installation

###  LOG FILE
less /var/log/mariadb/mariadb.log

### MAIN CONFIG FILE - tarik
less /etc/my.cnf.d/server.cnf

### UNIT file - not to be messed with
# /lib/systemd/system/mariadb.service

### My usefull commands
# ctrl+d   to exit mysql
ss -tulpn | grep mysql
scp test_db-master.zip cloud_user@34.252.109.158:/tmp/
scp -i testKey.pem /mnt/c/test_db-master.zip ec2-user@34.247.38.252:/tmp/

### backups + passwd file
vi /root/.my.cnf
# [client] 
# user=root 
# password=*****
# auto-rehash

chmod 600 /root/.my.cnf
mkdir -p /home/tutorialinux/backups/db
mysqldump --add-drop-table --databases employees > /home/tutorialinux/backups/db/$(/bin/date +\%Y-\%m-\%d).sql.ba
/etc/crontab
# 2 2 * * * root mysqldump --add-drop-table --databases employees > /home/tutorialinux/backups/db/$(/bin/date +\%Y-\%m-\%d).sql.bak
mysql -u root employees < 2016-04-08.sql.bak
mysql -t < employees.sql

### if you want to run  on non standard port
vim /etc/my.cnf
 # add port=3360 e.g.
firewall-cmd --permanent --add-port=3360/tcp
firewall-cmd --reload
semanage port -a -t mysqld_port -p tcp 3360
semanage port -l


# --LINKS------------------
https://dev.mysql.com/doc/employee/en/employees-installation.html
# https://stackoverflow.com/questions/10378693/how-does-mysql-store-data
