#!/bin/bash
###############Basic parameters##########################
DAY=`date +%Y%m%d`
Environment=$(/sbin/ifconfig | grep "inet addr" | head -1 |grep -v "127.0.0.1" | awk '{print $2;}' | awk -F':' '{print $2;}')
USER="backup"
PASSWD="123456"
HostPort="3306"
MYSQLBASE="/home/mysql/"
DATADIR="/home/db_backup/${DAY}"
MYSQL=`/usr/bin/which mysql`
MYSQLDUMP=`/usr/bin/which mysqldump`
mkdir -p ${DATADIR}

Dump(){
 ${MYSQLDUMP} --master-data=2 --single-transaction  --routines --triggers --events -u${USER} -p${PASSWD} -P${HostPort} ${database}  > ${DATADIR}/${Environment}-${database}.sql
 cd ${DATADIR}
 gzip ${Environment}-${database}.sql
}

for db in `echo "SELECT schema_name FROM information_schema.schemata where schema_name not in ('information_schema','sys','performance_schema')" | ${MYSQL} -u${USER} -p${PASSWD} --skip-column-names`
do
   database=${db}
   Dump
done
