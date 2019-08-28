
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
# ctrl+d   to exit
ss -tulpn | grep mysql

### backups + passwd file



### if you want to run  on non standard port
vim /etc/my.cnf
 # add port=3360 e.g.
firewall-cmd --permanent --add-port=3360/tcp
firewall-cmd --reload
semanage port -a -t mysqld_port -p tcp 3360
semanage port -l
