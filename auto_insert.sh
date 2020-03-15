#!/bin/bash
# script for generating inserts into a database
# for testing galera cluster master slave replication

INSERTS_NO=10
INTERVAL=0.5
MESSAGE='your-message'

C_NC='\e[0m' # No Color
C_BROWN='\e[0;33m'

echo
printf "${C_BROWN} Inserting ${INSERTS_NO} rows  Every ${INTERVAL} sec  Description: ${MESSAGE}\n"
x=0
for i in $(seq 1 ${INSERTS_NO});do
(( x++ ))
#mysql -e "insert into autodb.autotbl1 (description,sequence) values('${MESSAGE}','${x}');"
mysql -u auto_user -pauto_pass -h 52.211.68.84 -e "insert into autodb.autotbl1 (description,sequence) values('${MESSAGE}','${x}');" >/dev/null 2>&1
sleep ${INTERVAL}
done

#mysql -e "insert into autodb.autotbl1 (description) values('-----------');"
mysql -u auto_user -pauto_pass -h 52.211.68.84 -e "insert into autodb.autotbl1 (description) values('-----------');" >/dev/null 2>&1
echo
printf " --- Finished ---${C_NC}\n"
echo


### Create Db ####

#  CREATE DATABASE autodb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
#  CREATE TABLE IF NOT EXISTS autodb.autotbl1(id int AUTO_INCREMENT PRIMARY KEY, description varchar(30), sequence int, TimeStamp TIMESTAMP);
#  GRANT ALL ON autodb.* TO 'auto_user'@'%' IDENTIFIED BY 'auto_pass';

#  END=5
# for ((i=1;i<=END;i++)); do
#     echo $i
# done

# need >/dev/null 2>&  to suppress "Using a password on the command line interface can be insecure." for MySQL 5.7
