#!/bin/bash
# script generates inserts into a database (2021)
# good for testing galera cluster, master slave replication etc...

INSERTS_NO=3
INTERVAL=1
MESSAGE='your-message'
SERVER_IP='writer1swdevi.europe.com'

C_NC='\e[0m' # No Color
C_BROWN='\e[0;33m'

echo
printf "${C_BROWN} Inserting ${INSERTS_NO} rows  Every ${INTERVAL} sec  Description: ${MESSAGE}\n"
x=0
for i in $(seq 1 ${INSERTS_NO});do
(( x++ ))
mysql -u ver_user -pver_paSs987* -h ${SERVER_IP} -e "insert into ver_db.ver_t (description,sequence) values('${MESSAGE}','${x}');" # >/dev/null 2>&1
printf '\r%8d %8s' ${x} "rows inserted"
sleep ${INTERVAL}
done

#mysql -e "insert into autodb.autotbl1 (description) values('-----------');"
mysql -u ver_user -pver_paSs987* -h ${SERVER_IP} -e "insert into ver_db.ver_t (description) values('-----------');" # >/dev/null 2>&1
echo
echo
printf " --- Finished ---${C_NC}\n"
echo

### Create Db ####

# CREATE DATABASE IF NOT EXISTS ver_db;
# CREATE TABLE IF NOT EXISTS ver_db.ver_t (id int AUTO_INCREMENT PRIMARY KEY, description varchar(30), sequence int, TimeStamp DATETIME DEFAULT CURRENT_TIMESTAMP);
# CREATE USER IF NOT EXISTS 'ver_user'@'%' IDENTIFIED BY 'ver_paSs987*';
# GRANT ALL ON ver_db.* TO 'ver_user'@'%';
# SELECT * FROM ver_db.ver_t;
