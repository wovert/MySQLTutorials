#!/bin/bash
MYSQL=/home/mysql/bin/mysql
MYSQL_HOST=127.0.0.1
MYSQL_USER=root
MYSQL_PASSWORD=123456
CHECK_TIME=3
#mysql is working MYSQL_OK is 1 , mysql down MYSQL_OK is 0
MYSQL_OK=1
function check_mysql_helth (){
$MYSQL -h $MYSQL_HOST -u $MYSQL_USER -e "select @@version;" >/dev/null 2>&1
if [ $? = 0 ] ;then
     MYSQL_OK=1
else
     MYSQL_OK=0
fi
     return $MYSQL_OK
}
while [ $CHECK_TIME -ne 0 ]
do
     let "CHECK_TIME -= 1"
     check_mysql_helth

     echo $MYSQL_OK
if [ $MYSQL_OK = 1 ] ; then
     CHECK_TIME=0
     exit 0
fi
if [ $MYSQL_OK -eq 0 ] && [ $CHECK_TIME -eq 0 ]
then
     pkill keepalived
exit 1
fi
sleep 1
done
