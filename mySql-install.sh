# need for AmazonLinux2: sudo yum install ncurses-compat-libs

sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm 
sudo yum install mysql-community-server
systemctl start mysqld.service

grep "temporary password" /var/log/mysqld.log	
sudo mysql -u root -p***

### mariadb-server ###
see separate file

### FROM LA ###############################################################
Installation:

Download the MySQL RPM bundle tar file from the MySQL Community Server downloads page:

 # wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.15-1.el7.x86_64.rpm-bundle.tar
Extract the RPM files from the MySQL bundle tar file:

 # tar -xvf mysql-8.0.15-1.el7.x86_64.rpm-bundle.tar
Install the MySQL server and dependencies using the rpm command:

 # sudo rpm -Uvh mysql-community-{server,client,common,libs}-*
Start up the MySQL server:

 # sudo systemctl start mysqld
Log into the MySQL server as the root user, using the temporary password located in /var/log/mysqld.log:

 # sudo grep 'temporary password' /var/log/mysqld.log
 # mysql -u root -p
Update the password for the root user:

 mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'PASSWORD';
 mysql> exit
