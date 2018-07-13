<?php 
  header( 'Content-Type: text/html; charset=UTF-8' );
  set_time_limit(300); //最大执行时间这里设置300秒
     
  //连接数据库
  $user = 'root';
  $pw = 'root';
  $link = new mysqli();
  $link->connect('localhost', 'test','root','root');
  $link->set_charset('utf8');
  if (mysqli_connect_error()) {
    printf("MySQL connection is error:%s\n", mysqli_connect_error());
    exit();
  }
  
  $bannerSql = "select * from banner_info";
  $result = $link->query($bannerSql);
  $bannerIds = [];
  while(!!$row = $result->fetch_object()) {
    array_push($bannerIds, $row->id);
  }

  $startDateTime = mktime(0,0,0, 1,1, 2017);

  // inet_ntoa()
  $hits_ip = '192.168.1.1';

  $browsers = ['chrome','safari','edge','opera','firefox'];

  $clients = ['web','mobile','ios','android','other'];

  for ($i = 1; $i <= 1000000 ; $i++) { 
    $banner_id = rand(0, count($bannerIds));
    $hits_time_i = $startDateTime + rand(0, 18144000);
    $hits_time_t = date('Y-m-d H:i:s', $hits_time_i);
    $hits_time_d = $hits_time_t;

    $user_agent = $browsers[rand(0, count($browsers)-1)];
    $client = rand(0, 5);
    
    $sql = "insert into banner_hits_inn_index(id, banner_id, hits_time_i, hits_time_t, hits_time_d, hits_ip, user_agent, client) 
      values($i, $banner_id, $hits_time_i, '$hits_time_t', '$hits_time_d', inet_aton('$hits_ip'), '$user_agent', '$client')";
   
    if ($link->query($sql) == true) { 
      echo $sql . "\n";
    }
  }

  //$link->free(); // 释放查询内存(销毁)
  $link->close(); // 关闭数据库资源
