#!/bin/bash
order_id=2
while :
do
   order_id=`echo $order_id+1| bc`
   sql="insert into order_detail(order_id,add_time,order_amount,user_name,user_tel) values(${order_id},now(),100,'wyjs','123456')";
   echo $sql | mysql -utest -p123456 -P3307 -h10.103.9.101

   sql2="insert into order_product(order_id,product_id) values(${order_id},${order_id})"
   echo $sql2 | mysql -utest -p123456 -P3307 -h10.103.9.101

   sql3="insert into category(id,name) values(${order_id},'wyjs')"
   echo $sql3 | mysql -utest -p123456 -P3307 -h10.103.9.101
   

done
