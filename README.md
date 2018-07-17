# 电商数据库设计及架构优化实战

- 注册会员(用户模块) - 展示商品 - 加入购物车(购物车模块)-生成订单(订单模块)
- 商户入住(商户模块) - 发送货物(物流模块)

## 环境

- MySQL 5.7
- SQLyog: MySQL图形客户端程序

## 购物流程

- 用户登录->选购商品->加购物车->检车库存->提交订单
- 货到付款
  - Y
  - N => 订单付款
- 发货

## 用户模块

> 用户注册/登录验证/查找密码

## 商品模块

> 前后台商品管理和浏览

## 订单模块

> 订单/购物车的生成和管理 

## 仓配管理

> 仓库库存和物理的管理

## 数据结构设计

- 逻辑设计 -> 逻辑设计
- 实际工作：逻辑设计+物理设计

## 数据库设计规范

- 数据库命名规范
- 数据库基本设计规范
- 数据库索引设计规范
- 数据库字段设计规范
- 数据库 SQL 开发规范
- 数据库操作行为规范(运维)

### 数据库命名规范

- 所有数据库对象名称是`小写字母并用下划线`分割（Linux OS 区分大小写）
- 所有数据库对象名称禁止使用 [MySQL保留关键字](https://dev.mysql.com/doc/refman/5.7/en/keywords.html)
- 所有数据库对象名称必须要`见名识义`，并且最好不超过32个字符
- 临时表：以 `tmp` 为前缀并以日期为后缀
- 备份表：以 `bak` 为前缀并以日期为后缀
- 所有存储`相同数据的列名和列类型必须一致`（不同列名影响性能）


- lym_userdb(零壹码网的用户数据库)
- user_account(用户账号表)

### 数据库基本设计规范

- MySQL 5.5 使用之前 MyISAM(默认存储引擎)

- 所有表必须使用 `InnoDB` 存储引擎
  - 5.6 + 默认引擎
  - 支持事务，行级锁，更好恢复性，高并发下性能更好
- 数据库表和字符集统一使用 `UTF8`
  - 避免字符集转换乱码
  - `UTF—8 字符集汉字占用3个字节`
- 所有表和字段必须添加注释
  - 便于以后数据字典的维护
- 尽量控制单表数据量大小，建议控制在`500万以内`
  - 500万并不是 MySQL 数据库限制
  - 存储多少万数据？取决于存储设置和文件系统
  - 历史数据归档、分库分表(业务)等手段来控制数据量大小
- 谨慎使用 MySQL分区表
  - 分区表在物理上表现为多个文件，在逻辑上表现为一个表
  - 分区键，跨分区查询效率可能更低
  - 建议才用物理分表的方式管理大数据

- 冷热数据分离，减少表的字段
  - MySQL 限制做多存储 4096列
  - MySQL 每行不能超过 65535字节
  - 减少磁盘 IO，保证热数据缓存命中率
  - 利用更有效的利用缓存，避免读取无用的冷数据
  - 经常一起使用的列放在一起

- 禁止在表中预留字段
  - 见名识义
  - 预留字段无法确认存储的数据类型，所有无法选择合适的类型
  - 对预留字段类型的修改，会对表进行锁定
- 禁止存储图片/文件等二进制数据
- 禁止在线上做数据库压力测试（可以在开发环境测试）
- 禁止从开发环境，测试环境直连生产环境

### 索引设计规范

> 对查询性能非常重要

- 不要滥用索引
- 限制每张表的索引数量，建议单表索引不超过5个
  - 与列数量成正比
  - 索引提高效率同时可以降低效率
- `InnoDB` 表必须有一个主键
  - 不适用更新频繁的列作为主键，不使用多列主键
  - 不使用 uuid,md5,hash,字符串列作为主键
- 使用自增 ID 值

- 常见索引列建议：
  - select,update,delete 语句的 where 从句中的列
  - 包含在 order by, group by, distinct 中的字段
  - 多表 join 的关联列

- 如何选择索引列的顺序
  - 从左到右的顺序来使用
    - 区分度最高的列放在联合索引的最左侧
    - 尽量字段长度小的列放在联合索引的最左侧
    - 使用最频繁的列放到联合做引的左侧
	
- 避免建立冗余索引和重复索引
  - index(a,b,c), index(a,b), index(a)

- 频繁查询有限考虑使用覆盖索引
  - 覆盖索引：包含了素有查询字段的索引(where,order by, group by)
  - 好处：
    - 避免innodb表进行索引的二次查找
    - 随机IO变为顺序IO加快查询效率

- 尽量避免使用外键
  - 不建议使用外键约束
  - 在业务端实现
  - 外键影响父表和子表的写操作从而降低性能


### 数据库字段设计规范

- 优先选择符合存储需要的**最小的数据类型**
  - inet_aton('255.255.255.255') = 4294967295
  - inet_ntoa(4294967295) = '255.255.255.255'

	4 byte vs 15 byte	

- 选择非负整型数据选择无符号整型数据进行存储unsigned 类型
- varchar(n) n代表**字符数**，而不是字节数
  - utf8汉字varchar(255) = 占用765 byte

- 过大的长度会消耗更多的内存

- 避免使用text(max 64k), blob数据类型
  - tinytext
  - text
  - midumtext
  - longtext
  - 内存不支持text,blog 排序
  - 需要二次查询
  - 建议单独放到的扩展表中
  - text/blog只能有前缀索引，没有默认值

- 避免使用enum数据类型
  - 65535 中
  - 字符串类型
  - 修改enum值需要使用alter语句
  - enum类型的order by 操作率低，需要额外的操作
  - 禁止使用数值作为enum的枚举类型

- 尽可能吧所有列定义为NOT NULL
  - 索引null列需要额外的空间来保存，所以要占用更多的空间
  - 进行比较和计算时要对null值做特别的处理

- 使用timestamp(4 byte)或datetime(8 byte)类型存储时间
  - timestamp 1970-01-01 00:00:01 ~ 2038-03-03 03:14:07
  - timestamp 占用 4 byte 和 int 相同，但比 int 可读性高

- 超出时间范围使用 `datetime`

- 财务数据必须使用 decimal
  - 精准浮点数，在计算时不会丢失精度
  - 占用空间由定义的宽度决定
    - 每4字节存储9位数据
  - 存储比 bigint 更多的数据


### 数据库 SQL 开发规范

- **预编译语句**进行数据库操作
```
> prepare stmt1
> from 'select SQRT(POW(?,2) + POW(?,2)) AS hypotenuse';
> set @a=3;
> set @b=4;
> execute stmt1 USING @a, @b;
> deallocate prepare stmt1;
```

- 只传参数，比传递SQL语句更高效
- 相同语句可以一次解析，多次使用，提高处理效率

- 避免数据类型的隐式转换
  - 隐式转换导致索引失效
  - where id='1'

- 利用表上的已经存在的索引
  - 避免使用双%好的查询条件：'%123%'
  - 一个SQL只能利用到复合索引中的一列进行范围查询
  - 使用 left join 和 not exists 来优化 not in 操作

- 不同的数据库使用不同的账号，禁止跨库查询
  - 为数据库迁移和分库分表留出余地
  - 降低业务耦合度
  - 避免权限过大而产生的安全风险
- 禁止使用select*
  - 消耗更多的CPU和IO以及网络带宽资源
  - 无法使用覆盖索引
  - 可以减少表结构变更带来的影响

- 禁止是不含字段列表的insert 语句
  - insert int t value('a','b')
  - insert into t(c1,c2) values('a','b')
  - 可以减少结构变更带来的影响

- 禁止子查询，子查询优化位join操作
  - 在查询结果集无法使用索引
  - 产生临时表操作，如果子查询数据量大则严重影响效率
  - 消耗过多的CPU和IO资源

- 避免使用join关联太多的表
  - 每join一个表会多占用一部分内存(join_buffer_size)
  - 会产生临时表操作，应影响查询效率
  - MySQL 最多允许关联61个表，建议不超过5个

- 减少同数据库的交互次数
  - 分页显示：不要提取 第一页结果
  - 数据库更合适处理批量操作
  - 合并多个相同的操作到一起，可以提高处理效果
  - alter table t1 add column c1int, add. ...

- 使用 in 代替 or
  - in 的值不要超过 500个
  - in 操作可以有效的利用索引

- 禁止使用 order by rand() 进行随机排序
  - 会把所有符合条件的数据装载到内存中进行排序
  - 消耗大量的CPU和IO及内存资源
  - 在程序中获取一个随机值，然后从数据库中获取数据

- where 从句中禁止对列进行函数转换和计算
  - 导致无法使用索引
  - where date(createtime) = '20160901'
  - where createtime >= '20160901' and createtime < '20161010'

- 不会有重复值的使用union all ，而不是union
  - union 把所有数据放到临时表中后再进行去重操作
  - union all 不会再对结果集进行去重操作

- 拆分复杂的大 SQL 为多个小 SQL
  - MySQL 一个 SQL 只能使用一个CPU进行计算
  - 通过并行执行来提高处理效率

### 数据库操作行为规范(运维)

- 超 100万行的批量写操作，要分批多次进行操作
  - 大批量操作可能造成严重的主从延迟
  - binlog 日志为row格式时会产生大量的日志
  - 避免产生大事务操作


- 对大表数据结构修改一定要谨慎，会造成严重的锁表操作。尤其是生产环境，是不能忍受的。 10分钟表锁，会出现在线延迟

- 对大表使用pt-online-schema-change修改表结构
  - percona开发的工具
  - 1. 新建表与原来表一样，并修改表结构
  - 2. 复制数据到新表中，并在源表中增加触发器，把新增的数据也增加在新表中。在行的数据完成之后，在源表上加上事件锁

  - 避免大表修改产生的主从延迟
  - 避免在对表字段进行修改时进行锁表

- 禁止为程序程序使用的账号赋予super权限
  - 当达到最大连接数限制时，还允许1个有super权限的用户连接
  - super权限只能留给DBA 处理问题的账号使用

- 程序连接数据库账号，遵循权限最小原则
  - 不准夸库
  - 程序使用账号原则上不准有drop权限

## 数据库设计

### 用户模型设计

- 用户实体(下面是实体属性)
  - 用户姓名
  - 登录名
  - 密码
  - 手机号
  - 证件类型
  - 证件类型号码
  - 邮箱
  - 性别
  - 邮政编码
  - 省
  - 市
  - 区
  - 地址
  - 积分
  - 注册时间
  - 生日
  - 用户状态（冻结[不能登陆和购物]|正常）
  - 用户级别（优惠政策）
  - 用户余额

- 用户表(customer)

### 所有数据字段保存在一个表上带来问题

- 数据插入异常
  - PK：用户登录名
  - 用户级别存储（会员级别/级别积分上限/级别积分下限，不需要插入主键）
	
- 数据更新异常
  - 修改某一行的值时，不得不修改多行数据
    - 用户等级(青铜级)修改成其他名称(皇冠级)
    - 修改所有会员的用户级别数据时，表锁

- 数据删除异常	
  - 删除某一数据时不得不同时删除另一数据
    - 删除用户等级名为皇冠级等级
    - delete from customer where level='皇冠';
	
- 数据存在冗余
  - 每个用户的用户等级上限和下限
  - 数据表过宽，会影响修改表结构的效率

### Solution

#### 满足数据库设计第三范式(3NF)

> 一个表中的**列**和**其他列**之间既不包含部分**函数依赖关系**也不包含传递函数依赖关系，那么这个表的设计就符合第三范式


- 级别积分上限/下限 依赖用户级别
- 用户级别依赖于登录名

- 拆分原用户表以符合第三范式
  - 用户登陆表（登录名/密码/用户状态）
  - 用户地址表（省名/市/区/地址/邮编）
  - 用户信息表（用户姓名/证件类型/证件号码/手机号/邮箱/性别/积分/注册时间/生日/会员级别/用户余额）
  - 用户级别信息（customer_level_info）
    - 会员级别
    - 级别积分下限
    - 级别积分上限

#### 数据表设计

- 用户登陆表：customer_login

```
create table customer_login(
	customer_id int unsigned auto_increment not null '用户ID',
	login_name varchar(28) not null comment '用户登录名',
	password char(32) not null comment 'md5加密的密码',
	user_status tinyint not null default 1 comment '用户状态(1:正常,0:冻结)',
	modified_time timestamp not null default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
primary key pk_customerid(customer_id)
) engine=innodb comment='用户登陆表';
```

- 用户信息表：customer_info
```
create table customer_info{
	customer_info_id int unsigned auto_increment not null comment '自增主键ID',
	customer_id int unsigned not null comment 'customer_login表的自增ID',
	customer_name varchar(20) not null comment '用户真实姓名',
	identity_card_type tinyint not null default 1 comment '证件类型(1:身份证，2:军官证，3:护照)'，
	identity_card_no varchar(20) comment '证件号码',
	mobile_phone int unsigned comment '手机号',
	customer_email varchar(50) comment '邮箱',
	gender char(1) comment '性别',
	user_point int not null default 0 comment '用户积分',
	register_time timestamp not null comment '注册时间',
	birthday datetime comment '会员生日',
	customer_level tinyint not null default 1 '会员级别（1：普通会员，2：青铜会员，3：白银会员，4：黄金会员，5：钻石会员）',
	user_money decimal(8,2) not null default 0.00 comment '用户余额',
	modified_time timestamp not null default current_timestamp on update current_timestamp comment '最后修改时间',
	primary key pk_customerinfoid(customer_info_id)
} engine=innodb comment '用户信息表'
```

- 用户级别表(customer_level_info)
```
create table customer_level_info(
	customer_level tinyint not null auto_increment comemnt '会员级别ID',
	level_name varchar(10) not null comment '会员级别名称',
	min_point int unsigned not null default 0 comment '级别最低积分',
	max_point int unsigned not null default 0 comment '级别最高积分',
	modified_time timestamp not null default current_timestamp 0 on update current_timestamp comment '最后修改时间',
	primary key pk_levelid(customer_level)
) engine=innodb comment '用户级别信息表'
```


- 用户地址表(customer_addr)
```
create table customer_addr(
	customer_addr_id int unsigned auto_increment not null comment '自增主键ID',
	customer_id int unsigned not null comment 'customer_login表的自增ID',
	zip smallint not null comment '邮编',
	province smallint not null comment '地区表中省份的ID',
	city smallint not null comment '地区表中城市的ID',
	district smallint not null comment '地区表中区的ID',
	address varchar(200) not null comment '具体的地址门牌号',
	is_default tinyint not null comment '是否默认',
	modified_time timestamp not null default current_timestamp on update current_timestamp comment '最后修改时间',
	primary key pk_customeraddid(customer_addr_id)
) engine=innodb comment '用户地址表'
```

- 用户积分日志表(customer_point_log)
```
create table customer_point_log(
	point_id int unsigned not null auto_increment comment '积分日志ID',
	customer_id int unsigned not null comment '用户ID',
	source tinyint unsigned not null comment '积分来源(0：订单，1：登录，2：活动)',
	refer_number int unsigned not null default 0 comment '积分来源相关编号',
	change_point smallint not null default 0 comment '变更积分数',
	create_time timestamp not null comment '积分日志生成时间',
	primary key pk_pointid(point_id)
) engine=innodb comment '用户积分日志表'
```

- 用户余额变动表(customer_balance_log)
```
create table customer_balance_log(
	balance_id int unsigned not null auto_inrement comment '余额日志ID',
	customer_id int unsigned not null comment '用户ID',
	source tinyint unsigned not null default 1 comment '记录来源（1：订单，2：退货单）',
	source_sn int unsigned not null comment '相关单据ID',
	create_time timestamp not null default current_timestamp comment '记录生成时间',
	amount decimal(8,2) not null default 0.00 comment '变动金额',
	primary key pk_balanceid (balance_id)
) engine=innodb comment '用户余额变动表'
```

- 用户登录日志表（customer_login_log）
```
create table customer_login_log(
	login_id int unsigned not null auto_increment comment '登录日志ID',
	customer_id int unsigned not null comment '登录用户ID',
	login_time timestamp not null comment '用户登录时间',
	login_ip int unsigned not null comment '登录IP',
	login_type tinyint not null comment '登录类型（0：未成功，1：成功）',
	primary key pk_loginid(login_id)
) engine=innodb comment '用户登录日志表'
```

- 业务场景
  - 用户每次登录都会记录 customer_login_log 日志
  - 用户登录日志保存一年，一年后可以删除

- 登录日志表的分区类型及分区键
  - 使用 range 分区
  - login_time 作为分区键

```
create table customer_login_log(
	login_id int unsigned not null auto_increment comment '登录日志ID',
	customer_id int unsigned not null comment '登录用户ID',
	login_time timestamp not null comment '用户登录时间',
	login_ip int unsigned not null comment '登录IP',
	login_type tinyint not null comment '登录类型（0：未成功，1：成功）',
	primary key pk_loginid(login_id)
) engine=innodb comment '用户登录日志表'
partitoin by range(year(lgin_time)) (
	partition p0 values less than(2015),
	partition p1 values less than(2016),
	partition p2 values less than(2017)
);
```

- insert 插入数据
```
select * from customer_login_log;
select table_name, partition_name, partition_description, table_rows from infomation_shema.PARTITIONS where table_name='customer_login_log'
```

```
alter table customer_login_log add partition (partition p4 values less than(2018))
```


- 删除分区表
```alter table customer_login_log drop partition p0;```

- 建立归档表
```
create table arch_customer_login_log(
	login_id int unsigned not null auto_increment comment '登录日志ID',
	customer_id int unsigned not null comment '登录用户ID',
	login_time timestamp not null comment '用户登录时间',
	login_ip int unsigned not null comment '登录IP',
	login_type tinyint not null comment '登录类型（0：未成功，1：成功）',
	primary key pk_loginid(login_id)
) engine=innodb comment '用户登录日志归档表'
```

- 分区迁移
```
alter table customer_login_log exchange partition p2 with table arch_customer_login_log;
```

- 分区迁移之后删除分区p2
```
alter table customer_login_log drop partition p2;
```

- 查看归档
```
select * from customer_login_log;
```

- 修改归档引擎(只能查找操作，不能写操作)
```
alter table arch_customer_login_log engine=ARCHIVE
```

## 分区表的注意事项
- 结合业务场景选择分区键，避免跨分区查询
- 对分区表进行查询最好在where从句中包含分区键
- 具有主键或唯一索引的表，主键或唯一索引必须是分区键的一部分

## 商品实体
- 商品名称
- 国条码
- 分类
- 供应商
- 品牌名称
- 销售价格
- 成本
- 上下架状态
- 颜色
- 重量
- 长度
- 宽度
- 高度

- 有效期
- 生产时间
- 描述
- 图片信息


- 品牌信息表(brand_info)
```
create table brand_info(
	brand_id small int unsigned auto_increment not null comment ''品牌ID,
	brand_name varchar(50) not null comment '品牌名称',
	telephone varchar(50) not null comment '联系电话',
	brand_web varchar(100)  comment '品牌网站',
	brand_logo varchar(100) comment '品牌logo RUL',
	brand_desc varchar(150) comment '品牌描述', 
	brand_status tinyint not null default 0 comment '品牌状态（0：禁用，1：启用）',
	brand_order tinyint not null default comment '排序',
	modified_time timestamp not null default current_timestmap on update current_timestamp comment '最后修改时间',
	primary key pk_brandid(brand_id)
) engine=innodb comment="品牌信息表"
```

- 分类信息表(product_category)
```
create table product_category(
	category_id smallint unsigned auto_increment not null comment '分类ID',
	category_name varchar(10) not null comment '分类名称',
	category_code varchar(10) not null comment '分类编号',
	parent_id smallint unsigned not null default 0 comment '父分类ID',
	category_level tinyint not null default 1 comment '分类层级',
	category_status tinyint not null default 1 comment '分类状态',
	modified_time timestamp not null default current_timestmap on update current_timestamp comment '最后修改时间',
	primary key pk_categoryid(category_id)
) engine=innodb comment='商品分类表'
```

- 供应商信息表(supplier_info)
```
create table supplier_info(
	supplier_id int unsigned auto_increment not null comment '供应商ID',
	supplier_code char(8) not null comment '供应商编号',
	supplier_name char(50) not null comment '供应商名称',
	supplier_type tinyint not null comment '供应商类型（1：直营，2：平台）',
	link_man varchar(10) not null comment '供应商联系人',
	phone_number varchar(50) not null comment '联系电话',
	bank_name varchar(50) not null comment '供应商开户银行名称',
	bank_account varchar(50) not null comment '银行账号',
	address varchar(200) not null comment '供应商地址',
	supplier_status tinyint not null default 0 comment '状态（0：禁用，1：启用）',
	modified_time timestamp not null default current_timestmap on update current_timestamp comment '最后修改时间',
	primary key pk_supplierid(supplier_id)
) engine=innodb comment '供应商信息表';
```

- 商品信息表(product_info)
```
create table product_info(
	product_id int unsigned auto_increment not null comment '商品ID',
	product_code char(16) not null comment '商品编码',
	product_name varchar(20) not null comment '商品名称',
	bar_code varhcar(50) not null comment '国条码',
	brand_id int unsigned not null comment '品牌表的ID',
	one_category_id small int unsigned not null comment '一级分类ID',
	two_category_id  small int unsigned not null comment '二级分类ID',
	three_category_id  small int unsigned not null comment '三级分类ID',
	supplier_id int unsgined not null comment '商品的供应商ID',
	price decimal(8,2) not null comment '商品销售价格',
	average_cost decimal(8,2) not null comment '商品加权平均成本',
	publish_status tinyint not null default 0 comment '上下架状态（0:下架，1：上架）',
	audit_status tinyint not null default 0 comment '审核状态（0：未审核，1：已审核）',
	weight float comment '商品重量',
	length float comment '商品长度',
	height float comment '商品高度',
	width float comment '商品宽度',
	color_type enum('红','黄','蓝','黑'),
	production_date datetime not null comment '生产日期',
	shelf_life int not null comment '商品有效期',
	descript text not null comment '商品描述',
	indate timestamp not null default CURRENT_TIMESTAMP comment '商品录入时间',
	modified_time timestamp not null default current_timestmap on update current_timestamp comment '最后修改时间',
	primary key pk_productid(product_id)
) engine=innodb comment '商品信息表';
```

- 商品图片表(product_pic_info)

# MySQL分区表

- 确认MySQL 服务器是否支持分区表
```
mysql> show plugins;
partition active 
```

## 分区表的特点

- 在逻辑为一个表，在物理上存储多个文件中
```
create table customer_login_log(
	login_id int unsigned not null auto_increment comment '登录日志ID',
	customer_id int unsigned not null comment '登录用户ID',
	login_time timestamp not null comment '用户登录时间',
	login_ip int unsigned not null comment '登录IP',
	login_type tinyint not null comment '登录类型（0：未成功，1：成功）',
	primary key pk_loginid(login_id)
) engine=innodb comment '用户登录日志表'
partition by hash(customer_id)
partitions 4;
```

- 非分区表的物理文件
  - customer_login_log.frm
  - customer_login_log.idb

- 分区表的物理文件
  - customer_login_log.frm
  - customer_login_log#p0.ibd
  - customer_login_log#p1.ibd
  - customer_login_log#p2.ibd
  - customer_login_log#p3.ibd


## hash分区(hash)的特点

- 根据MOD（分区键，分区数）的值把数据行存储到表的不同分区内
- 数据可以平均的分布在各个分区中
- 分区的键值必须是一个int 类型的值，或是通过函数可转换为 int 类型



- 如何建立hash分区表
```
create table customer_login_log(
customer_id int(10) unsigned not null,
login_time timestamp not null,
login_ip int(10) unsigned not null,
login_type tinyint(4) not null
) engine=innodb
partition by hash(customer_id)
partitions 4 分区数量

partition by hash(unix_timestamp(login_time))
partitions 4
```

- 插入数据时跟正常插入数据方式一样的

## hash分区表可用的函数

- abs()
- dayofmonth()
- datediff()
- hour()
- mod()
- second()
- to_seconds()
- year()
- ceiling()
- dayofweek()
- extract()
- microsecond()
- month()
- time_to_sec()
- unix_timestamp()
- day()
- dayofyear()
- floor()
- minute()
- quarter()
- to_days()
- weekday()
- yearweek()

## 按范围分区(range)

- 根据分区键值的范围把数据行存储到表的不同分区中
- 多个分区的范围要连续，但不能重叠
- 默认情况下使用 values less than 属性，即每个分区不包括指定的那个值


- 如何范围分区
```
create table customer_login_log(
customer_id int(10) unsigned not null,
login_time timestamp not null,
login_ip int(10) unsigned not null,
login_type tinyint(4) not null
) engine=innodb
partition by range (customer_id) (
	partition p0 values less than (10000),
	partition p1 values less than (20000),
	partition p2 values less than (30000),
	partition p3 values less than MAXVALUE
)
```

- p0: 小于10000的customer_id，存储与p0， 0-9999
- p1: 小于20000的customer_id，存储与p0， 10000-19999
- p0: 大于30000的customer_id，存储与p3， > 30000 

- 使用场景
  - 分区间为日期或是时间类型
  - 所有查询中都包括分区键
  - 定期按分区范围清理历史数据



## List 分区

- 按分区键的列表进行分区
- 同范围分区一样，各分区的列表值不能重复
- 每一行数据必须能找到对应的分区列表，否则数据插入失败

- 如何建立 li分区
```
create table customer_login_log(
customer_id int(10) unsigned not null,
login_time timestamp not null,
login_ip int(10) unsigned not null,
login_type tinyint(4) not null
) engine=innodb
partition by list (login_type) (
	partition p0 values in (1,3,5,7,9),
	partition p1 values in (2,4,6,8)
)
```
- insert into 插入login_type 10 出现错误代码：1526


## 数据库解决方案

## 如何对评论进行分页展示

```
explain select customer_id, title, content from product_comment where audit_status=1 and product_id = 199727 limit 0,5;
```
- SQL如何使用索引
- 连接查询的执行顺序
- 查询扫描的数据行数

### 执行计划 explain

- ID: 表示执行select语句的顺序
  - ID 值相同时，执行顺序由上至下
  - ID 值越大优先级越高，越先被执行

- select_type:
  - simple : 不包含子查询或是union
  - primary: 按主键查询
  - subquery: select列表中的子查询
  - dependent subquery: 依赖外部结果的子查询
  - union：Union操作的第二个或是之后的值为union
  - dependento union： 当union作为子查询时，第二或是第二个后的查询的select_type值
  - union result: union产生的结果集
  - derived: 出现在from子句中的子查询

```
primary > simple > subquery > dependent subquery
```

- table列
  - 表的名称
  - unionM,N: unicon产生结果集
  - derivedN/subqueryN: 有id为N的查询产生结果

- partitions列
  - 分区表的ID
  - NULL：非分区表

- type:
  - system：表中只有一行
  - const: 表中有且只有**一个匹配的行**时使用，如对**主键或唯一索引的查询**，这是效率最高的连接方式
  - eq_ref：**唯一索或主键引查找**，对于每个索引键，表中只有**一条记录与之匹配**
  - ref：**非唯一索引查**找，返回匹配某个单独值得**所有行**
  - ref_of_null：雷士ref，附加了对**null**值列的查询
  - index_mer：索引**合并优化**方法
  - ge
  - range： **索引范围扫描**，between,<,>等查询条件
  - index: Full index Scan **全索引扫描**，同ALL的区别是，遍历的是**索引树**
  - all：**全表扫描**，效率最差

- possible_keys 可能索引优化查询
	 
- key 优化查询实际使用的索引
  - NULL： 没有可用的索引
  - 使用覆盖索引：则该索引金出现在key列中
- key_len 索引**字节数**
  - 索引字段的最大可能长度
  - 有字段定义计算而来，并非数据的实际长度

- ref: key索引查询时的来源
- rows 估算的读取的行数，统计抽样结果，并不准确
- filtered 返回结果的行数占需读取行数的百分比，值越大越好，依赖统计信息

- Extra
  - Distinct : 优化distince操作，在找到第一匹配的元祖后即停止找同样值的动作
  - Not exists: 使用not exists来优化查询。如 not in
  - Using filesort ： 额外操作进行排序，如order by, group by 查询中
  - Using index: 使用覆盖索引进行查询
  - Using temporary : 临时表来处理查询，常见于排序、子查询、和分组查询
  - Using where： where条件来过滤数据
  - select tables optimized away: 索引来获得数据，不用访问表

- 无法展示存储过程，触发器/UDF对查询的影响
- 早期版本仅支持select

```
select count(distinct audit_status)/count(*) as audit_rate, 
count(distince product_id)/count(*) as product_rate from product_comment;
```

- 越接近1使用该字段放左侧，创建索引
```
create index idx_productid_auditStat on product_comment(product_id,audit_status)
```

- 进一步优化
```
select t.customer_id, t.title, t.content
from (
select comment_id from product_comment
where produt_id=199727 and audit_status=1 limit 0,15
) a join product_comment t
on a.comment_id = t.comment_id;
```


## 删除重复数据

### 同一订单同一商品的重复评论

1. 查看是否存在对于订单同一商品的重复评论
2. 备份 product_comment 表
3. 删除同一订单的重复评论


1. 查看是否存在对于订单同一商品的重复评论
```
select order_id, product_id, count(*)
from product_comment
group by order_id, product_id having count(*)>1
```

```select * 
from product_comment
where order_id=4 and product_id=134509
```

2. 备份 product_comment 表
```
create table bak_product_comment_180312
like
product_comment
insert into back_product_comment_180312
select * from product_comment;
```

- 或 mysqldump

3. 删除同一订单的重复评论
```
delete a
from product_comment a
join (
	select order_id, product_id, min(comment_id) as comment_id
	from product_comment
	group by order_id, product_id
	having count(*)>=2
) b on a.order_id=b.order_id and a.product_id=b.product_id
and a.comment_id > b.comment_id
```


## 分区间统计

> 统计消费总金额大于1000元的，800到1000元的，500到800元的，以及500元以下的人数

```
select count(case when ifnull(total_money, 0) >=1000 then a.customer_id end) as '大于1000',count(case when ifnull(total_money,0) >=800 and ifnull(total_money,0)<100 then a.customer_id end) as '800-1000'
,count(case when ifnull(total_money,0) >=500 and ifnull(total_money,0) < 800
then a.customer_id end) as '500-800'
,count(case when ifnull(total_money, 0)<500 then a.customer_id end) '小于500'
from mc_userdb.customer_login a
left join
(select customer_id, sum(order_money) as total_money
from mc_orderdb.order_master group by customer_id) b
on a.customer_id = b.customer_id;
```

## 捕获有问题的 SQL

### 慢查询日志

- set global show_query_log_file = /sql_log/slow_log.log
- set global log_queries_not_using_indees = on; 未使用索引SQL抓取
- set global long_query_time =0.001; 抓取执行超过多少时间的SQL（秒）
- set global low_query_log = on; 启动慢查询

### 慢查询日志记录的内容

- Id: 线程ID
- Query_time Lock_time Rows_send(查询结果返回行数) Rows_examined: 10000(扫描行数)

### 如何分析慢查日志

```
mysqldumpslow slow-mysql.log
```

## 数据库备份

- 数据库复制不能取代备份的作用

### 数据库结果备份分类

- 逻辑备份（mysqldump）
  - 逻辑备份的结果为SQL语句，适合于所有存储引擎
- 物理备份
  - 对数据库的目录的空啊被，对于内存表只备份结果

- 离线备份
  - 数据库锁定
- 在线备份
  - 第三方工具： XtraBackup

### 数据库备份

- 全量备份：整个数据库的完整备份
- 增量备份：上次备份的基础上，对于更改数据进行的备份
  - mysqldump 不支持增量备份


### mysqldump 进行备份

- 备份表：mysqldump [OPTIONS] database [tables] [tables]
- 备份数据库：mysqldump [OPTIONS] --database [OPTIONS] db1 db2;
- 备份整个数据库：mysqldump [OPTIONS] --all-database [OPTIONS];

### 常用参数：

- -u， --user=name
- -p, --password=[=name]
- 必须有用户权限才能备份：select,reload,lock tables,replication client, show view, process

- --single-transaction: 启动一个事务
  - 数据备份时一致性
  - 仅对innodb存储引擎有效
  - 备份期间要保证没有其他DDL语句执行
  - innodb事务不能隔离DDL操作

- -l, --lock-tables
  - 非事务性存储引擎（锁定一个数据库的所有表）
  - 备份时，其他数据库只能进行读操作
  - 备份时，某一数据库的数据一致的，但不能保证mysql所有数据库一致的，因此规范中所有数据库引擎使用 InnoDB 原因

- --single-transaction与--lock-tables 互斥，不能同时使用

- 有innodb 和其他存储引擎时只能使用 --lock-tables

- -x, --lock-all-tables 
  - 整个数据库所有实例都进行枷锁，保证备份一致性
  - 备份过程中数据库只能变成只读的，而不能写数据

- --master-data=[1/2]
  - 时间恢复，新建新的slaver实例
  - 1: 备份是，change master语句也备份，默认值1
  - 2: change master 语句以注释形式备份

- -R, --routines 存储过程
- --triggers 触发器
- -E, --events 调度事件

- --hex-blob (binary类型十六进制格式备份)
- --tab=path 结构和数据分别存储

- -w, --where='过滤条件' 只能单表数据条件导出

### mysqldump 实例

```
mysql -uroot -p

mysql> create user 'backup'@'localhost' identified by '123456'

mysql> grant select,reload,lock tables, replication client, show view, event,process on *.* to 'backup'@'localhost';

cd /data/db_backup

mysqldump -ubackup -p --master-data=2 --single-transaction --routines --triggers --events dbname > dbname.sql

grep "CREATE TABLE" dbname.sql

mysqldump -ubackup -p --master-data=2 --single-transaction --routines --triggers --events dbname dbname tablename > tablename.sql

grep "CREATE TABLE" tablename.sql
```

### 全量备份

```
mysqldump -ubackup -p --master-data=2 --single-transaction --routines --triggers --events --all-databases > db.sql
grep 'Current Database' db.sql
mkdir -p /tmp/cg_orderdb && chown mysql:mysql /tmp/cg_orderdb
```

```
mysql -uroot -p
> grant file on *.* to 'backup'@'localhost';
```

```
# mysqldump -ubackup -p --master-data=2 --single-transaction --routines --triggers --events --tab="/tpm/cg_orderdb" cg_orderdb
```

- file.sql 结构
- file.txt 数据

### 脚本编写mysqldump备份

### 恢复mysqldump 备份的数据库

- 单线程
```
# mysql -u -p dbname < backup.sql
# mysql> source /tmp/backup.sql
```

```
# mysql -uroot -p -e "create database bak_orderdb"
# mysql -uroot -p back_orderdb < cg_orderdb.sql
```

- 恢复数据库之后检测数据是否完整回复：select count...

- 恢复删除的数据
```
insert into cg_orderdb.order_master (字段...) select a.* from bak_orderdb.order_master a left join cg_orderdb.order_master b on a.order_id=b.order_id where b.order_id is null
```

### 全备数据恢复

```
# mysql -uroot -p -e"create database bak_orderdb"
# mysql -uroot -p bak_orderdb < cg_orderdb.sql
```

- 误删除生产数据
```
delete cg_orderdb.order_master limit 10
```

- 备份数据库恢复数据
```
insert into cg_orderdb.order_master(...)
select a.* from bak_orderdb.order_master a 
left join cg_orderdb.order_master b
on a.order_id=b.order_id
where b.order_id is null
```

### -tab 备份数据恢复

```
# mysql -u root -p
mysql>use crn
mysql>show tables;
mysql>source /tmp/cg_orderdb/region_info.sql;
mysql>load data infile '/tmp/cg_orderdb/region_info.txt' into table region_info;
```

### mysqldummp全备总结

- 常用参数
- 全库及部分库表备份
- 利用备份文件进行数据恢复

## 如何进行时间点的恢复

- 进行某一时间点的数据恢复
  - 恢复到误操作的时间

- 先觉条件：
  - 具有指定时间点钱的一个全备
  - 具有自上次全备后指定时间点的所有二进制日志

### 模拟生产环境数据库操作

```
# mysqldump -ubackup -p --master-data=2 --single-transaction --routines --triggers --events mc_orderdb > mc_orderdb.sql
mysql> use mc_orderdb
mysql> create table t(
id int auto_increment not null,
uid int,
cnt decimal(8,2),
primary key (id));

mysql> insert into t(uid,cnt)
select customer_id, sum(order_money) from order_master
group by customer_id;

mysql> select count(*) from t

delete from t limit 100;
select count(*) from t
```

### 恢复步骤

```
# mysql -uroot -p mc_orderdb < mc_orderdb.sql
# more mc_orderdb.sql
# cd /home/mysql/sql_log
```

- 查看二进制日志删除数据
```
# mysqlbinlog --base64-output=decode-rows -vv --start-position=84882 --database=mc_orderdb mysql-bin.000011 | grep -B3 DELETE | more
```

```
# mysqlbinlog --start-position=84882 --stop-position=169348
--database=mc_orderdb mysql-bin.000011 > mc_order_diff.sql
```

```
# mysql -uroot -p mc_orderdb < mc_order_idff.sql
```

```
# mysql -uroot -p
mysql> use mc_orderdb
mysql> select count(*) from t;
```

### 基于时间点的恢复总结

- 具有指定时间点前的 mysqldump 的备份
- 具有备份到指定时间点的 mysql 二进制日志

### 实施二进制日志备份

- mysql 5.6版本之后，可以实时备份binlog

- 配置
```
# grant replication slave on *.* to 'repl'@'127.0.0.1' identified by '123456';
# hls -hl /home/mysql/sql_log
# mkdir -p binlog_backup
```

```
# mysqlbinlog --raw --read-from-remote-server \
--stop-never --host localhost --port 3306 \
-urepl -p123456 mysql-bin.000010
```

```
# cd binlog_back
# ls -hl
```


- 刷新日志
```
mysql> flush logs;
mysql> show binary logs;
```

```
# ls -hl binlog_back
```

## xtrabackup

> 开源的在线热备份工具
> 用于在线备份innodb存储引擎的表

- 备份的过程中，不会影响表的读写操作
- 只会备份数据文件，而不会备份表的结构

- innobackupex 是对 xtrabackup 的封装并提供 MyISAM 表的备份功能

- innobackupex 是 Xtrabackup 的插件 支持 MyISAM 备份，但会锁表


### 安装 xtrabackup

[xtrabackup下载地址](https://www.percona.com/downloads/XtraBackup/LATEST/) percona-xtrabackup-VERSION.el6.x86_64.rpm

- 安装支持库
```
# yum install -y perl-DBD-MySQL.x86_64 perl-DBI.x86 perl-Time-HiRes.x86_64 perl-IO-Socket-SSL.noarch perl-TermReadKey.x86_64


# yum search libnuma

# rpm -ivh percona-xtrabackup-VERSION.el6.x86_64.rpm
```

- 命令
```
/usr/bin/innobackupex -> xtrabackup
/usr/bin/xtrabackup
```

### xtrabackup进行全备

```
# innobackupex --user=root -H 127.0.0.1 --password=pwd --parallel=2 /data/db_backup/
```

- parallel: 线程数
- --no-timestamp 不按时间戳目录

### xtrabackup进行全备恢复

```
# innobackupex --apply-log /path/to/BACKUP-DIR
# mv /path/to/BACKUP-DIR /home/mysql/data
```

### 增量备份

> 先全备，后增量备份

```
mysql> create table t2(uid int(11))

# innobackupex --user=root --password=pwd \
--incremental /home/db_backup/ \
--incremental-basedir=/home/db_backup/back-dir`

--incremental 全量备份目录
--incremental-basedir: 上一次增量备份的目录
```

### 增量备份恢复

```
innobackupex --apply-log --redo-only 全备目录

innobackupex --apply-log --redo-only 全备目录 \
--incremental-dir=第一次增量目录

innobackupex --apply-log 全备目录

mv /path/to/backup-dir /home/mysql/data
```


- 恢复第一次增量备份
```
# innobackupex --apply-log --redo-only /data/db_backup/全备目录名
# innobackupex --apply-log --redo-only /data/db_backup
# innobackupex --apply-log --redo-only /data/db_backup/全备目录名 
--incremental-dir=/data/db_backup/第一次增量备份目录
# innobackupex --apply-log /data/db_backup/全备目录
# mv /data/db_backup/第一次增量备份目录 /home/mysql/
# /etc/init.d/mysqld stop
# cd /home/mysql && rm -rf data
# mv 增量备份目录 data
# chown -R mysql:mysql data
# /etc/init.d/mysqld start
```

## 备份计划

- 每天凌晨对数据库进行一次全备
- 实时对二进制日志进行远程备份
- crontab 定时任务

## 单点问题

- 无法满足增长的读写请求
- 高峰时数据库连接数经常上限

## 解决单点问题
- 组建数据库集群
- 同一集群中的数据库服务器需要具有相同的数据
- 集群中的任一服务器宕机后，其他服务器可以读取宕机服务器

## MySQL 主从复制架构

> Maser -> Slave

- 主库将变更写入到主库的 binlog 中
  - 一定要开启二进制日志（影响性能）
  - 增量备份需要二进制日志
- 从库IO进程读取主库 binlog 内哦让那个存储到 Relay Log(中继) 日志中
  - 二进制日志点
  - GTID(MySQL>=5.7推荐使用)
- 从库的SQL进程读取 Relay Log 日志中内存在从库中重放

### 主从配置步骤

- 配置主从数据库服务器参数

- 在Master服务器上创建用于复制的数据库账号

- 备份 Master 服务器上的数据并初始化 Slave 服务器数据

- 启动复制链路


### 配置主从数据库服务器参数

- Master 服务器
```
log_bin = /data/mysql/sql_log/mysql-bin 数据和日志分开存放
server_id = 100
```

- Slave 服务器
```
log_bin = /data/mysql/sql_log/mysql-bin 数据和日志分开存放
server_id = 101
relay_log = /data/mysql/sql_log/relay-bin
read_only=on
super_read_ony = on # v5.7
skip_slave_start=on 
master_info_repository=TABLE
relay_log_info_repository=TABLE
```

### MASTER 服务器上建立复制账号

- 用于IO进程连接 Master 服务器获取 binlog 日志
- 需要 `replication slave` 权限

```
create user 'repl'@'ip' identified by 'passwd'
grant replication slave on *.* to 'repl'@'ip';
```

### 初始化 Slave 数据

- 建议主从数据库服务器采用相同的 MySQL 版本
- 建议使用全备备份的方式初始化 slave 数据

```
# mysqldump --master-data=2 -uroot -p -A --single-transaction -R --triggers
```


### 启动基于日志点的复制链路

```
change master to
MASTER_HOST='mster_host_ip',
MASTER_USER='repl',
MASTER_PASSWORD='PassWord',
MASTER_LOG_FILE='mysql_log_file_name',
MASTER_LOG_POS=xxx;
```

### 主从复制演示

- 192.168.3.100 - 主
- 192.168.3.101 - 从

1. 主服务器配置
```
log_bin = /data/mysql/sql_log/mysql-bin
max_binlog_size = 1000M
binlog_format = row
expire_logs_days = 7
sync_binlog = 1
server-id=100
```

2. 从服务器配置
```
server-id=101
relay_log=/data/mysql/sql_log/mysqld-relay-bin
master_info_repository = TABLE
relay_log_info_repository = TABLE
read_only = on
```

3. 主服务器
```
mysql> show variables like '%server_id%'
```

- 动态改变 server_id = 100
```
mysql> set global serer_id = 100;
```

4. 重启slave服务器
```
# /etc/init.d/myql restart
```

5. master
- 5.7 版本镜像方式安装有uuid文件，要删除此文件
- 数据目录下 auto.cnf

- 创建账号
```
create user 'dba_repl'@'192.168.3.%' identified by '123456'
grant replication slave on *.* to 'dba_repl'@'192.168.3.%';
```

- 全备数据库
```
# cd /data/db_backup/
# mysqldump -uroot -p --single-transaction --master-data --triggers --routines --all-databases > all.sql
```

```
# scp all.sql root@192.168.3.101:/root
```

6. slave
```
# cd /root
# ls -lh
# more all.sql
# mysql -uroot -p < all.sql
```

- 复制链路配置
```
# mysql -uroot -p
mysql> show databases;
mysql> change master master_host='192.168.3.100',
master_user='dba_repl',
master_password='123456',
master_log_file='mysql-bin.000017',
maeter_log_pos=663;
```

- all.sql备份文件中有 CHANGE MASTER TO MASTER_LOG_FILE..

```
mysql> start slave; 启动复制链路
```

```
mysql> show slave status \G
Relay_Master_Log_File: mysql-bin.000017
Slave_IO_Running: Yes
Slave_SQL_Running: YES
```

7. master

```
`use mc_orderdb
```
> desc t1;
> insert into t1 values(1);
> select * from t1`

8. slave
```
use mc_orderdb
> select * from t1`
```


## 启动基于 GTID 的复制链路

- GTID: 全局事务ID

- master
```
gtid_mode = on
enforce-gtid-consistency
log-slave-updates = on` 5.6 必须加上 5.7 不用添加
```

- slave
```
change master to
	host
	user
	password`
	**`master_auto_position = 1`**
```

### GTID 复制的限制

- 无法使用 create table ... select 建立表
- 无法在事务中使用 create temporary table 建立临时表
- 无法使用关联更新同时更新事务表和非事务表


### 引入复制后的数据库架构

- 增加了一个数据库副本
- 根本上没有解决数据库单点问题
- 主服务器宕机，需要手动切换从服务器，业务中断不能忍受

- 解决：虚拟IP(vip) 
- 一个未分配给真实主机的IP，对外提供服务器的主机除了有一个真实IP外还有一个虚拟IP

### 引入 VIP 后的数据库架构

- 设置虚拟IP方法
  - 脚本
  - MHA
  - MMMM

## keepalived 高可用服务

- 实现主从主从数据库的健康监控
- 当主DB宕机时迁移VIP到主备
- 该主从复制为主主赋值，但只有一个提供服务
  - 另一个只能只读状态


### 主主赋值配置调整

- 保证只有一个主提供服务
- 另一个提供只读的服务

- master-master


### Master 数据库配置修改

```
auto_increment_increment = 2 
auto_increment_offset = 1
1,3,5,7,9...
```
### 主备数据库配置

```
auto_increment_increment = 2
auto_increment_offset = 2
2,4,6,8,10...
```

### Keeyalived 简介

> 给予 ARRP 网络协议

- 两个主机虚拟成一个设备，也就是一个虚拟IP（VIP）
- 拥有虚拟IP的设备位master设备
- 其他设备不能有虚拟IP，都是backup状态的设备，收到master 状态通告之外，不执行任何对外服务，当主机失效时将接管原先的master 的虚拟IP以及对外提供各项服务

- 安装(master-backup都安装)

`# yum -y install keepalived -y`

- 配置：`/etc/keepalived/keepalived.conf`
```
vrrp_script check_run {
	script "/etc/keepalived/check_mysql.sh"
	interval 5
}
```

### keepalived 演示

- 主主配置

1. master 配置
- master: my.cnf
```
auto_increment_increment = 2
auto_increment_offset = 1
```

- 修改global
```
# mysql -uroot -p
mysql> set global auto_increment_increment=2;
mysql> set global auto_increment_offset=1;
```

- 推出
```
# mysql -uroot -p
mysql> show variables like 'auto%'
```

2. backup 配置
- my.cnf
```
auto_increment_increment = 2
auto_increment_offset = 2
```

```
# mysql -uroot -p
mysql> set global auto_increment_increment=2;
mysql> set global auto_increment_offset=2;
```

- 推出
```
# mysql -uroot -p
mysql> show variables like 'auto%'
```

- 查看账号
```
mysql>user mysql
mysql>select user.host from user;
> show variables like '%read_only%'
mysql> show master status \G
```

3. master
```
mysql> change master to master host='192.168.3.101',
master_user='dba_repl',
master_password='123456',
master_log_file = 'mysql-bin.000003',
master_log_pos='xxxx'


master_log_file = 'mysql-bin.000003',
master_log_pos='xxxx'
上面两个值查看 backup 的show master status

> start slave;
> show slave status \G

```

4. keepalived 安装
- master
```
# yum -y install keepalived
```

- backup
```
# yum -y install keepalived
```

```
# cd /etc/keepalived/
# vim keepalived.conf
```

```
vrrp_script check_run {
	script "/etc/keepalived/check_mysql.sh"
	interval 5
}
virtual_ipaddress {
	192.168.3.99/24
}
```

- 两个服务器都有： check_mysql.sh 有执行权限
```
# chmod a+x check_mysql.sh
```

```
#!/bin/bash
MYSQL=which mysql
MYSQL_HOST=127.0.0.1
MYSQL_USER=root
MYSQL_PWD=123456
CHECK_TIME=3
MYSQL_OK=1
function check_mysql_helth() {
	$MYSQL -h$MYSQL_HOST -u$MYSQL_USER -p${MYSQL_PWD} -e "select @@version;" >/dev/null 2>&1
	if [ $? = 0 ]; then
		MYSQL_OK = 1
	else
		MYSQL_OK = 0
	fi
	return $MYSQL_OK
}
while [ $CHECK_TIME -ne 0 ]
do
	let "CHECK_TIME -= 1"
	check_mysql_helth

	echo $MYSQL_OK
if [ $MYSQL_OK = 1 ] ; then
	CHECK_TIME = 0
	exit 0
fi
if [ $MYSQL_OK -eq 0 ] && [ $CHECK_TIME -eq 0 ]
	pkill keepalived
exit 1
fi
```

5. 启动keepalived进程

- master: `# /etc/init.d/keepalived start	`

- slave : `# /etc/init.d/keepalived start	`


- master :`# ip addr show`

6. 模拟master 宕机 : `# /etc/init.d/mysql stop`

7. 查看 vip =>  master: `# ip addr show`

- backup : `# ipaddr show`


## 如何解决读压力大问题

- 读负载和写负载是两个不同的问题
1. 写操作只能在 Maser 数据库上执行
2. 读操作都可以在 Maser 和 Slave 运行

- 相对于写负载，解决读负载要更容易

- 进行读写分离，**主服务器**主要执行**写操作**
- **读**操作的压力平均分摊到不同过的 **Slave** 服务器上

- 增加**前段缓存服务器**如 Redis, Memcache 等

- Redis 可持久化/主从复制/集群

### 如何进行读写分离

1. SQL语句连接不同的服务器
- 优点：完全有开发人员控制，实现更加的灵活
- 由程序直接连接数据库，所以性能损耗比较少
- 缺点：实时性要求比较高的数据，就不适合在从库上查询
- 冯家开发的工作量，是程序代码更加复杂
- 人为控制，容易出现错误

**库存必须在主库上查询** 超卖情况

2. 由**数据库中间层**完成读写分离
- DB proxy => keepalived(M<->S)
- select -> Slave
- update/Insert/Delete/Create -> Master

- 优点
  - 由中间件根据查询语法分析，自动完成读写分离
  - 对程序透明，对于已有程序不同做任何调整

- 缺点：
  - 增加了中间层，查询效率有损耗
  - 对于延迟敏感业务无法自动在主库执行

- DB Proxy 产品
  - mysql proxy
  - maxscale
  - one proxy
  - proxySQL

### 常用的都服务器负载均衡方式

- 数据库中间层： 数据库中间层读写分离
- DNS 轮询
- LVS(四层代理) / Haproxy(七层代理)
- F5(硬件)

### LVS 读服务器负载均衡

- 四层代理，只进行分发，处理效率更高
- 工作稳定，可进行高可用配置
- 无流量，不会对主机的网络IO造成影响


- Master DB: 192.168.3.100
- Master Backup DB: 192.168.3.101
- Slave DB: 193.168.3.102

- keepalived vip: 192.168.3.99

- lvs manager: 192.168.3.100/101
- lvs vip: 192.168.3.98

#### 配置 LVS
- kernel 2.6 继承LVS 继承软件

- 安装 LVS 管理工具: lvs manager: 192.168.3.100/101
- `yum install -y ipvsadm`

- 192.168.3.100/101/102 三台主机都运行
`# modprobe ip_vs` ip_vs 模块的加载

- 101 LVS 脚本编写
`# vim /etc/inid.d/lvsrs`

``` bash
#!/bin/bash
VIP=192.168.3.98
. /etc/rc.d/init.d/functions
case "$1" in
start)
/sbin/ifconfig lo down
/sbin/ifconfig lo up
echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
/sbin/sysctl -p >/dev/null 2>&1
/sbin/ifconfig lo:0 $VIP netmask 255.255.255.255 up
/sbin/route add -host $VIP dev lo:0
echo "LVS-DR real server starts successfully.\n"
;;
stop)
/sbin/ifconfig lo:0 down
/sbin/route del $VIP >/dev/null 2>&1
echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "0" > /proc/sys/net/ipv4/conf/all/arp_ignore
echo "0" > /proc/sys/net/ipv4/conf/all/arp_announce
echo "LVS-DR read server stopped."
;;
status)
isLoOn=`/sbin/ifconfig lo:0 | grep "$VIP"`
isRoOn=`/bin/netstat -rn | grep "$VIP"`
if [ "$isLoOn" == "" -a "$isRoOn" == "" ]; then
echo "LVS-DR real server has to run yes."
else
echo "LVS-DR real server is running."
fi
exit 3
;;
`*)`
echo "Usage: $0 {start|stop|status}"
exit 1
esac
exit 0`
```

```
101]# /etc/init.d/lvsrs start
102]# /etc/init.d/lvsrs start
```