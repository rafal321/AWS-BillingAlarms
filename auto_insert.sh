#!/bin/bash
# script generates inserts into a database
# good for testing galera cluster, master slave replication etc...

INSERTS_NO=10
INTERVAL=0.5
MESSAGE='your-message'
SERVER_IP='34.245.51.243'

C_NC='\e[0m' # No Color
C_BROWN='\e[0;33m'

echo
printf "${C_BROWN} Inserting ${INSERTS_NO} rows  Every ${INTERVAL} sec  Description: ${MESSAGE}\n"
x=0
for i in $(seq 1 ${INSERTS_NO});do
(( x++ ))
#mysql -e "insert into autodb.autotbl1 (description,${SERVER_IP}sequence) values('${MESSAGE}','${x}');"
mysql -u auto_user -pauto_paSs987* -h ${SERVER_IP} -e "insert into autodb.autotbl1 (description,sequence) values('${MESSAGE}','${x}');" >/dev/null 2>&1
printf '\r%8d %8s' ${x} "rows inserted"
sleep ${INTERVAL}
done

#mysql -e "insert into autodb.autotbl1 (description) values('-----------');"
mysql -u auto_user -pauto_paSs987* -h ${SERVER_IP} -e "insert into autodb.autotbl1 (description) values('-----------');" >/dev/null 2>&1
echo
echo
printf " --- Finished ---${C_NC}\n"
echo


### Create Db ####

#  CREATE DATABASE autodb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
#  CREATE TABLE IF NOT EXISTS autodb.autotbl1(id int AUTO_INCREMENT PRIMARY KEY, description varchar(30), sequence int, TimeStamp TIMESTAMP);
#  GRANT ALL ON autodb.* TO 'auto_user'@'%' IDENTIFIED BY 'auto_paSs987*';

#  END=5
# for ((i=1;i<=END;i++)); do
#     echo $i
# done

# need >/dev/null 2>&1  to suppress "Using a password on the command line interface can be insecure." for MySQL 5.7

#====Sample output============================
mysql> select * from autodb.autotbl1;
+-----+---------------+----------+---------------------+
| id  | description   | sequence | TimeStamp           |
+-----+---------------+----------+---------------------+
|   1 | your-message  |        1 | 2020-03-29 13:29:13 |
|   2 | your-message  |        2 | 2020-03-29 13:29:21 |
|   3 | your-message  |        3 | 2020-03-29 13:29:29 |
|   4 | your-message  |        4 | 2020-03-29 13:29:37 |
|   5 | your-message  |        5 | 2020-03-29 13:29:46 |
