#/bin/bash
# check_slave.sh
MYSQL=`which mysql`
VIP=10.103.9.221
VPORT=3306 
function usage()  
{  
  echo "usage:"  
  echo "example:# mysql -umonitor -pmonitor -P3306 -h10.103.9.201"  
  echo "-p, --password[=name]"  
  echo "-P, --port"  
  echo "-h, --host=name"  
  echo "-u, --user=name"  
}  
  
  
while getopts "u:p:h:P:" option  
do  
    case "$option" in  
        u)  
            dbuser="$OPTARG";;  
        p)  
            dbpwd="$OPTARG";;  
        h)  
            dbhost="$OPTARG";;  
        P)  
            dbport="$OPTARG";;  
        \?)  
            usage  
            exit 1;;  
    esac  
done  
  
if [ "-$dbuser" = "-" ]; then  
    usage  
    exit 1  
fi  
  
if [ "-$dbpwd" = "-" ]; then  
    usage  
    exit 1  
fi  
  
if [ "-$dbhost" = "-" ]; then  
    usage  
    exit 1  
fi  
  
if [ "-$dbport" = "-" ]; then  
    usage  
    exit 1  
fi  
  
$MYSQL -u$dbuser -p$dbpwd -P$dbport -h$dbhost -e "select @@version;" >/dev/null 2>&1
if [ $? = 0 ] ;then
  MySQL_ok=1
else
  /sbin/ipvsadm -d -t $VIP:$VPORT -r $dbhost:$VPORT
  exit 1
fi

slave_status=$(${MYSQL} -u$dbuser -p$dbpwd -P$dbport -h$dbhost -e 'show slave status \G' | awk ' \
  /Slave_IO_Running/{io=$2} \
  /Slave_SQL_Running/{sql=$2} \
  /Seconds_Behind_Master/{printf "%s %s %d\n",io,sql,$2}') >/dev/null 2>&1


arr=($slave_status)
io=${arr[0]}
sql=${arr[1]}
behind=${arr[2]}




if [ "$io" == "No" ]||[ "$sql" == "No" ]; then  
    /sbin/ipvsadm -d -t $VIP:$VPORT -r $dbhost:$VPORT
    exit 1  
elif [ $behind -gt 60 ]; then
    /sbin/ipvsadm -d -t $VIP:$VPORT -r $dbhost:$VPORT
    exit 1
else
    /sbin/ipvsadm -a -t $VIP:$VPORT -r $dbhost:$VPORT -g
    exit 0  
fi  