-- InnoDB 引擎无索引
use test;

DROP TABLE IF EXISTS `banner_hits_inn`;
CREATE TABLE `banner_hits_inn` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '广告位点击量自动编号',
  `banner_id` int(11) unsigned NOT NULL COMMENT 'banner表id',
  `hits_time_i` int(11) unsigned NOT NULL COMMENT '用户点击时间 int 类型',
  `hits_time_t` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '用户点击时间 timestamp 类型',
  `hits_time_d` datetime NOT NULL COMMENT '用户点击时间 datetime 类型',
  `hits_ip` int(11) unsigned NOT NULL COMMENT 'IP地址',
  `user_agent` varchar(255) NOT NULL COMMENT '用户代理',
  `client` tinyint(1) unsigned NOT NULL DEFAULT '5' COMMENT '1:ios 2:android 3:mobile 4:web 5:default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- InnoDB 引擎有索引
DROP TABLE IF EXISTS `banner_hits_inn_index`;
CREATE TABLE `banner_hits_inn_index` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '广告位点击量自动编号',
  `banner_id` int(11) unsigned NOT NULL COMMENT 'banner表id',
  `hits_time_i` int(11) unsigned NOT NULL COMMENT '用户点击时间 int 类型',
  `hits_time_t` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '用户点击时间 timestamp 类型',
  `hits_time_d` datetime NOT NULL COMMENT '用户点击时间 datetime 类型',
  `hits_ip` int(11) unsigned NOT NULL COMMENT 'IP地址',
  `user_agent` varchar(255) NOT NULL COMMENT '用户代理',
  `client` tinyint(1) unsigned NOT NULL DEFAULT '5' COMMENT '1:ios 2:android 3:mobile 4:web 5:default',
  PRIMARY KEY (`id`),
  KEY `i_index` (`hits_time_i`),
  KEY `t_index` (`hits_time_t`),
  KEY `d_index` (`hits_time_d`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- MyISAM 引擎无索引
DROP TABLE IF EXISTS `banner_hits_myi`;
CREATE TABLE `banner_hits_myi` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '广告位点击量自动编号',
  `banner_id` int(11) unsigned NOT NULL COMMENT 'banner表id',
  `hits_time_i` int(11) unsigned NOT NULL COMMENT '用户点击时间 int 类型',
  `hits_time_t` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '用户点击时间 timestamp 类型',
  `hits_time_d` datetime NOT NULL COMMENT '用户点击时间 datetime 类型',
  `hits_ip` int(11) unsigned NOT NULL COMMENT 'IP地址',
  `user_agent` varchar(255) NOT NULL COMMENT '用户代理',
  `client` tinyint(1) unsigned NOT NULL DEFAULT '5' COMMENT '1:ios 2:android 3:mobile 4:web 5:default',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- MyISAM 引擎有索引
DROP TABLE IF EXISTS `banner_hits_myi_index`;
CREATE TABLE `banner_hits_myi_index` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '广告位点击量自动编号',
  `banner_id` int(11) unsigned NOT NULL COMMENT 'banner表id',
  `hits_time_i` int(11) unsigned NOT NULL COMMENT '用户点击时间 int 类型',
  `hits_time_t` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '用户点击时间 timestamp 类型',
  `hits_time_d` datetime NOT NULL COMMENT '用户点击时间 datetime 类型',
  `hits_ip` int(11) unsigned NOT NULL COMMENT 'IP地址',
  `user_agent` varchar(255) NOT NULL COMMENT '用户代理',
  `client` tinyint(1) unsigned NOT NULL DEFAULT '5' COMMENT '1:ios 2:android 3:mobile 4:web 5:default',
  PRIMARY KEY (`id`),
  KEY `i_index` (`hits_time_i`) USING BTREE,
  KEY `t_index` (`hits_time_t`) USING BTREE,
  KEY `d_index` (`hits_time_d`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `banner_info`;
CREATE TABLE `banner_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cityId` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '城市Id',
  `position` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '横幅位置(bannerConfig.id)',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `img` varchar(200) NOT NULL DEFAULT '' COMMENT '图片路径',
  `previewPic` varchar(200) NOT NULL DEFAULT '' COMMENT '预览图路径',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '链接地址',
  `sort` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '排序(asc)',
  `target` enum('_blank','_self','_top') NOT NULL DEFAULT '_blank' COMMENT '链接打开方式(新窗口打开,引入页内跳转,顶级页面跳转)',
  `isShow` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '是否显示(1是, 0否)',
  `showTime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开放显示时间',
  `expireTime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=371 DEFAULT CHARSET=utf8 COMMENT='横幅列表';

-- ----------------------------
-- Records of banner_info
-- ----------------------------
INSERT INTO `banner_info` VALUES ('1', '981', '3', '每天看看省不少钱', '', '', '', '0', '_blank', '1', '1483200000', '1566272000');
INSERT INTO `banner_info` VALUES ('37', '282', '1', '世界', '', '', '', '0', '_blank', '1', '1487215689', '1518751689');
INSERT INTO `banner_info` VALUES ('38', '854', '1', '房屋出租', '', '', '', '0', '_blank', '1', '1487220309', '1518756309');
INSERT INTO `banner_info` VALUES ('45', '2063', '19', '新星驾校', '', '', '', '0', '_blank', '1', '1487380115', '1508288915');
INSERT INTO `banner_info` VALUES ('57', '2063', '1', '新星驾校', '', '', '', '0', '_blank', '1', '1487385386', '1489804586');
INSERT INTO `banner_info` VALUES ('58', '76', '1', '信息发布', '', '', '', '0', '_blank', '1', '1487385664', '1489804864');
INSERT INTO `banner_info` VALUES ('59', '1189', '14', '聘', '', '', '', '0', '_blank', '1', '1487386277', '1489805477');
INSERT INTO `banner_info` VALUES ('60', '1189', '1', '聘', '', '', '', '0', '_blank', '1', '1487386911', '1489806111');
INSERT INTO `banner_info` VALUES ('61', '1189', '2', '减肥', '', '', '', '0', '_blank', '1', '1487387049', '1489806249');
INSERT INTO `banner_info` VALUES ('62', '1189', '1', '减肥', '', '', '', '1', '_blank', '1', '1487387431', '1492485031');
INSERT INTO `banner_info` VALUES ('63', '1189', '1', '00', '', '', '', '2', '_blank', '1', '1487387560', '1489806760');
INSERT INTO `banner_info` VALUES ('64', '1189', '2', '聘', '', '', '', '1', '_blank', '1', '1487387663', '1518923663');
INSERT INTO `banner_info` VALUES ('65', '1189', '2', '大', '', '', '', '2', '_blank', '1', '1487387693', '1518923693');
INSERT INTO `banner_info` VALUES ('66', '1189', '1', '忆', '', '', '', '3', '_blank', '1', '1487397077', '1489816277');
INSERT INTO `banner_info` VALUES ('67', '1189', '1', '上', '', '', '', '4', '_blank', '1', '1487397175', '1489816375');
INSERT INTO `banner_info` VALUES ('68', '1189', '1', '一', '', '', '', '5', '_blank', '1', '1487397353', '1518933353');
INSERT INTO `banner_info` VALUES ('69', '1189', '1', '44', '', '', '', '6', '_blank', '1', '1487397642', '1492495242');
INSERT INTO `banner_info` VALUES ('70', '1189', '1', '44', '', '', '', '7', '_blank', '1', '1487397697', '1518933697');
INSERT INTO `banner_info` VALUES ('71', '1189', '15', '44', '', '', '', '0', '_blank', '1', '1487397914', '1518933914');
INSERT INTO `banner_info` VALUES ('72', '1189', '1', '44', '', '', '', '8', '_blank', '1', '1487398143', '1492495743');
INSERT INTO `banner_info` VALUES ('73', '1189', '1', '44', '', '', '', '9', '_blank', '1', '1487398168', '1497766168');
INSERT INTO `banner_info` VALUES ('74', '1189', '1', '44', '', '', '', '10', '_blank', '1', '1487398242', '1500358242');
INSERT INTO `banner_info` VALUES ('75', '1189', '1', '44', '', '', '', '11', '_blank', '1', '1487398340', '1500358340');
INSERT INTO `banner_info` VALUES ('76', '76', '1', '金誉金融', '', '', '', '1', '_blank', '1', '1487404690', '1489823890');
INSERT INTO `banner_info` VALUES ('77', '76', '1', '煮满幸福', '', '', '', '2', '_blank', '1', '1487405768', '1489824968');
INSERT INTO `banner_info` VALUES ('78', '1669', '1', '58招聘', '', '', '', '0', '_blank', '1', '1487487003', '1500447003');
INSERT INTO `banner_info` VALUES ('79', '1669', '1', '58广告公司', '', '', '', '1', '_blank', '1', '1487489020', '1489908220');
INSERT INTO `banner_info` VALUES ('80', '1669', '14', '房屋', '', '', '', '0', '_blank', '1', '1487489363', '1489908563');
INSERT INTO `banner_info` VALUES ('81', '1669', '15', '招聘', '', '', '', '0', '_blank', '1', '1487490553', '1489909753');
INSERT INTO `banner_info` VALUES ('82', '981', '15', '58招聘', '', '', '', '0', '_blank', '1', '1487556475', '1489975675');
INSERT INTO `banner_info` VALUES ('84', '885', '1', '招聘', '', '', '', '0', '_blank', '1', '1487560778', '1521515978');
INSERT INTO `banner_info` VALUES ('87', '1189', '16', '77', '', '', '', '0', '_blank', '1', '1487575802', '1519111802');
INSERT INTO `banner_info` VALUES ('88', '76', '1', '麻辣小龙虾', '', '', '', '3', '_blank', '1', '1487578607', '1489997807');
INSERT INTO `banner_info` VALUES ('89', '76', '1', '三毛烤羊腿', '', '', '', '4', '_blank', '1', '1487578656', '1489997856');
INSERT INTO `banner_info` VALUES ('90', '76', '1', '大厨河鱼', '', '', '', '5', '_blank', '1', '1487580369', '1489999569');
INSERT INTO `banner_info` VALUES ('91', '76', '1', '铁锅炖', '', '', '', '6', '_blank', '1', '1487582967', '1490002167');
INSERT INTO `banner_info` VALUES ('92', '76', '1', '313羊庄', '', '', '', '7', '_blank', '1', '1487582992', '1490002192');
INSERT INTO `banner_info` VALUES ('93', '76', '14', '梦想', '', '', '', '0', '_blank', '1', '1487583143', '1490002343');
INSERT INTO `banner_info` VALUES ('94', '1189', '18', '11', '', '', '', '0', '_blank', '1', '1487640258', '1519176258');
INSERT INTO `banner_info` VALUES ('95', '1189', '17', '00', '', '', '', '0', '_blank', '1', '1487640832', '1519176832');
INSERT INTO `banner_info` VALUES ('96', '1189', '19', '55', '', '', '', '0', '_blank', '1', '1487640870', '1519176870');
INSERT INTO `banner_info` VALUES ('97', '1189', '20', '22', '', '', '', '0', '_blank', '1', '1487641489', '1519177489');
INSERT INTO `banner_info` VALUES ('104', '1189', '5', '44', '', '', '', '0', '_blank', '1', '1487642308', '1490061508');
INSERT INTO `banner_info` VALUES ('106', '1669', '1', '瑶池水会', '', '', '', '6', '_blank', '1', '1487726318', '1490145518');
INSERT INTO `banner_info` VALUES ('107', '1669', '1', '大闸蟹', '', '', '', '7', '_blank', '1', '1487727163', '1490146363');
INSERT INTO `banner_info` VALUES ('108', '1669', '1', '福泰祥', '', '', '', '8', '_blank', '1', '1487728056', '1490147256');
INSERT INTO `banner_info` VALUES ('109', '1669', '1', '美味帝国', '', '', '', '3', '_blank', '1', '1487729533', '1490148733');
INSERT INTO `banner_info` VALUES ('110', '1669', '1', '广告位招租', '', '', '', '2', '_blank', '1', '1487732045', '1490151245');
INSERT INTO `banner_info` VALUES ('111', '1669', '1', '润鑫和', '', '', '', '9', '_blank', '1', '1487732254', '1490151454');
INSERT INTO `banner_info` VALUES ('112', '953', '2', '专业灭蟑螂', '', '', '', '0', '_blank', '1', '1487732601', '1490151801');
INSERT INTO `banner_info` VALUES ('113', '1669', '1', '广告位招租', '', '', '', '11', '_blank', '1', '1487733294', '1490152494');
INSERT INTO `banner_info` VALUES ('114', '1669', '1', '掌上宝', '', '', '', '4', '_blank', '1', '1487733981', '1490153181');
INSERT INTO `banner_info` VALUES ('115', '1669', '1', '掌上宝', '', '', '', '4', '_blank', '1', '1487734001', '1490153201');
INSERT INTO `banner_info` VALUES ('116', '1669', '1', '招租', '', '', '', '5', '_blank', '1', '1487734079', '1490153279');
INSERT INTO `banner_info` VALUES ('117', '1669', '1', '招租', '', '', '', '10', '_blank', '1', '1487734152', '1490153352');
INSERT INTO `banner_info` VALUES ('118', '953', '14', '房屋信息', '', '', '', '0', '_blank', '1', '1487737295', '1490156495');
INSERT INTO `banner_info` VALUES ('119', '953', '1', '专业灭蟑螂', '', '', '', '0', '_blank', '1', '1487737689', '1490156889');
INSERT INTO `banner_info` VALUES ('120', '953', '15', '专业灭蟑螂', '', '', '', '0', '_blank', '1', '1487743679', '1490162879');
INSERT INTO `banner_info` VALUES ('121', '953', '1', '专业灭蟑螂', '', '', '', '6', '_blank', '1', '1487746985', '1519282985');
INSERT INTO `banner_info` VALUES ('122', '76', '1', 'sanma', '', '', '', '8', '_blank', '1', '1487815741', '1506132541');
INSERT INTO `banner_info` VALUES ('123', '76', '1', '招租', '', '', '', '11', '_blank', '1', '1487815957', '1490235157');
INSERT INTO `banner_info` VALUES ('124', '76', '1', '招租', '', '', '', '10', '_blank', '1', '1487816058', '1490235258');
INSERT INTO `banner_info` VALUES ('125', '76', '1', '招租', '', '', '', '9', '_blank', '1', '1487816084', '1490235284');
INSERT INTO `banner_info` VALUES ('128', '86', '1', 'TST护肤品', '', '', '', '0', '_blank', '1', '1487817287', '1490236487');
INSERT INTO `banner_info` VALUES ('129', '887', '1', '微信公众平台开发搭建/托管', '', '', '', '0', '_blank', '1', '1487824597', '1519360597');
INSERT INTO `banner_info` VALUES ('130', '953', '5', '专业灭蟑螂', '', '', '', '0', '_blank', '1', '1487841416', '1490260616');
INSERT INTO `banner_info` VALUES ('132', '86', '1', '招商', '', '', '', '2', '_blank', '1', '1487901450', '1490320650');
INSERT INTO `banner_info` VALUES ('142', '86', '2', '#', '', '', '', '0', '_blank', '1', '1487901858', '1490321058');
INSERT INTO `banner_info` VALUES ('143', '86', '2', '#', '', '', '', '1', '_blank', '1', '1487901887', '1490321087');
INSERT INTO `banner_info` VALUES ('144', '86', '2', '#', '', '', '', '2', '_blank', '1', '1487901904', '1490321104');
INSERT INTO `banner_info` VALUES ('146', '981', '1', '韩国蒂优半永久学院', '', '', '', '4', '_blank', '1', '1487920922', '1519456922');
INSERT INTO `banner_info` VALUES ('147', '981', '2', '韩国蒂优半永久学院', '', '', '', '0', '_blank', '1', '1487921169', '1519457169');
INSERT INTO `banner_info` VALUES ('148', '981', '2', '多洛希医学美容', '', '', '', '1', '_blank', '1', '1487921256', '1519457256');
INSERT INTO `banner_info` VALUES ('149', '981', '2', '韩国蒂优半永久学院', '', '', '', '2', '_blank', '1', '1487921320', '1519457320');
INSERT INTO `banner_info` VALUES ('150', '76', '15', '2017', '', '', '', '0', '_blank', '1', '1487992120', '1490411320');
INSERT INTO `banner_info` VALUES ('151', '76', '16', '扬帆起航', '', '', '', '0', '_blank', '1', '1487993031', '1490412231');
INSERT INTO `banner_info` VALUES ('152', '1669', '2', '手机APP', '', '', '', '0', '_blank', '1', '1488245034', '1490664234');
INSERT INTO `banner_info` VALUES ('153', '979', '15', '新义家具招工', '', '', '', '0', '_blank', '1', '1488261370', '1490680570');
INSERT INTO `banner_info` VALUES ('154', '981', '1', '如家', '', '', '', '5', '_blank', '1', '1488273750', '1522228950');
INSERT INTO `banner_info` VALUES ('155', '93', '14', '微网站、电脑网站制作', '', '', '', '0', '_blank', '1', '1488330293', '1519866293');
INSERT INTO `banner_info` VALUES ('158', '2063', '1', '祛斑通辑令：全城寻找100名有斑的朋友', '', '', '', '1', '_blank', '1', '1488438114', '1519974114');
INSERT INTO `banner_info` VALUES ('159', '981', '1', '57跑腿', '', '', '', '6', '_blank', '1', '1488617986', '1491296386');
INSERT INTO `banner_info` VALUES ('160', '981', '1', '奥迪', '', '', '', '7', '_blank', '1', '1514878946', '1519976546');
INSERT INTO `banner_info` VALUES ('161', '981', '1', '韩利壁', '', '', '', '8', '_blank', '1', '1489048490', '1491726890');
INSERT INTO `banner_info` VALUES ('171', '885', '1', '教育', '', '', '', '6', '_blank', '1', '1489383481', '1523597881');
INSERT INTO `banner_info` VALUES ('172', '885', '1', '店铺', '', '', '', '7', '_blank', '1', '1489389926', '1552461926');
INSERT INTO `banner_info` VALUES ('173', '885', '1', '房屋', '', '', '', '8', '_blank', '1', '1489453155', '1520989155');
INSERT INTO `banner_info` VALUES ('174', '86', '1', '#', '', '', '', '1', '_blank', '1', '1489472255', '1492150655');
INSERT INTO `banner_info` VALUES ('175', '86', '1', '#', '', '', '', '3', '_blank', '1', '1489472280', '1492150680');
INSERT INTO `banner_info` VALUES ('176', '86', '1', '#', '', '', '', '4', '_blank', '1', '1489472310', '1492150710');
INSERT INTO `banner_info` VALUES ('177', '86', '1', '#', '', '', '', '5', '_blank', '1', '1489472337', '1492150737');
INSERT INTO `banner_info` VALUES ('178', '86', '1', '#', '', '', '', '6', '_blank', '1', '1489472362', '1492150762');
INSERT INTO `banner_info` VALUES ('179', '86', '1', '#', '', '', '', '7', '_blank', '1', '1489472383', '1492150783');
INSERT INTO `banner_info` VALUES ('180', '86', '1', '#', '', '', '', '8', '_blank', '1', '1489472415', '1492150815');
INSERT INTO `banner_info` VALUES ('181', '86', '1', '#', '', '', '', '9', '_blank', '1', '1489472433', '1492150833');
INSERT INTO `banner_info` VALUES ('182', '86', '1', '#', '', '', '', '10', '_blank', '1', '1489472458', '1492150858');
INSERT INTO `banner_info` VALUES ('183', '86', '1', '#', '', '', '', '11', '_blank', '1', '1489472567', '1492150967');
INSERT INTO `banner_info` VALUES ('184', '885', '1', '征婚交友', '', '', '', '1', '_blank', '1', '1489476532', '1552548532');
INSERT INTO `banner_info` VALUES ('185', '981', '1', '爱尔眼科', '', '', '', '9', '_blank', '1', '1489626753', '1552698753');
INSERT INTO `banner_info` VALUES ('188', '76', '1', '游戏', '', '', '', '0', '_blank', '1', '1489975812', '1492654212');
INSERT INTO `banner_info` VALUES ('189', '76', '1', '金誉金融', '', '', '', '1', '_blank', '1', '1489975905', '1505873505');
INSERT INTO `banner_info` VALUES ('190', '76', '1', '煮满幸福', '', '', '', '2', '_blank', '1', '1489975965', '1505873565');
INSERT INTO `banner_info` VALUES ('193', '76', '1', '313', '', '', '', '3', '_blank', '1', '1490073198', '1505970798');
INSERT INTO `banner_info` VALUES ('194', '76', '1', '麻辣', '', '', '', '4', '_blank', '1', '1490073254', '1505970854');
INSERT INTO `banner_info` VALUES ('195', '76', '1', '铁锅炖', '', '', '', '5', '_blank', '1', '1490073313', '1505970913');
INSERT INTO `banner_info` VALUES ('196', '76', '1', '发布', '', '', '', '6', '_blank', '1', '1490073376', '1505970976');
INSERT INTO `banner_info` VALUES ('197', '76', '1', '河鱼', '', '', '', '7', '_blank', '1', '1490073436', '1505971036');
INSERT INTO `banner_info` VALUES ('198', '2045', '1', '恒洁卫浴', '', '', '', '0', '_blank', '1', '1490177012', '1550829812');
INSERT INTO `banner_info` VALUES ('199', '2045', '1', '211', '', '', '', '3', '_blank', '1', '1490177273', '1506074873');
INSERT INTO `banner_info` VALUES ('200', '2045', '1', '113', '', '', '', '2', '_blank', '1', '1490177417', '1506075017');
INSERT INTO `banner_info` VALUES ('201', '2045', '1', '114', '', '', '', '1', '_blank', '1', '1490177501', '1506075101');
INSERT INTO `banner_info` VALUES ('202', '2045', '1', '115', '', '', '', '6', '_blank', '1', '1490177530', '1506075130');
INSERT INTO `banner_info` VALUES ('203', '2045', '1', '顾家家居', '', '', '', '4', '_blank', '1', '1490177605', '1537611205');
INSERT INTO `banner_info` VALUES ('204', '2045', '1', '116', '', '', '', '5', '_blank', '1', '1490177781', '1521713781');
INSERT INTO `banner_info` VALUES ('205', '2045', '1', '117', '', '', '', '7', '_blank', '1', '1490177932', '1506075532');
INSERT INTO `banner_info` VALUES ('206', '2045', '1', '118', '', '', '', '8', '_blank', '1', '1490178012', '1516075612');
INSERT INTO `banner_info` VALUES ('207', '2063', '1', '新星驾校', '', '', '', '0', '_blank', '1', '1490236822', '1500777622');
INSERT INTO `banner_info` VALUES ('208', '2063', '1', '勤上装饰', '', '', '', '6', '_blank', '1', '1490237314', '1495507714');
INSERT INTO `banner_info` VALUES ('209', '86', '1', '#', '', '', '', '0', '_blank', '1', '1490238720', '1492917120');
INSERT INTO `banner_info` VALUES ('211', '2063', '1', 'APP全新上线', '', '', '', '2', '_blank', '1', '1490402415', '1503621615');
INSERT INTO `banner_info` VALUES ('212', '1007', '2', '儒房', '', '', '', '0', '_blank', '1', '1490404275', '1498353075');
INSERT INTO `banner_info` VALUES ('213', '1007', '2', '整形', '', '', '', '1', '_blank', '1', '1490404328', '1498353128');
INSERT INTO `banner_info` VALUES ('215', '1007', '2', '保健品', '', '', '', '2', '_blank', '1', '1490407635', '1498356435');
INSERT INTO `banner_info` VALUES ('216', '1007', '1', '小雨', '', '', '', '0', '_blank', '1', '1490407780', '1498356580');
INSERT INTO `banner_info` VALUES ('217', '1007', '1', '钟表', '', '', '', '1', '_blank', '1', '1490407896', '1498356696');
INSERT INTO `banner_info` VALUES ('218', '1007', '1', '四季', '', '', '', '2', '_blank', '1', '1490407949', '1498356749');
INSERT INTO `banner_info` VALUES ('220', '1007', '1', '哈东祥', '', '', '', '6', '_blank', '1', '1490408084', '1498356884');
INSERT INTO `banner_info` VALUES ('221', '1007', '1', '德龙金店', '', '', '', '7', '_blank', '1', '1490408159', '1498356959');
INSERT INTO `banner_info` VALUES ('222', '981', '1', '俄罗斯旅游', '', '', '', '10', '_blank', '1', '1490410671', '1553482671');
INSERT INTO `banner_info` VALUES ('225', '981', '1', '紫名都', '', '', '', '11', '_blank', '1', '1490584728', '1522120728');
INSERT INTO `banner_info` VALUES ('226', '2063', '1', '中国电信', '', '', '', '4', '_blank', '1', '1490770963', '1522306963');
INSERT INTO `banner_info` VALUES ('227', '2063', '1', '黄金建材家居大市场 2017仙桃首届婚博会', '', '', '', '5', '_blank', '1', '1490771417', '1493449817');
INSERT INTO `banner_info` VALUES ('228', '2063', '1', '开瑞汽车', '', '', '', '7', '_blank', '1', '1490772160', '1522308160');
INSERT INTO `banner_info` VALUES ('229', '2063', '1', '仙桃银湖城', '', '', '', '8', '_blank', '1', '1490773039', '1522309039');
INSERT INTO `banner_info` VALUES ('230', '2063', '1', '城市e管家', '', '', '', '9', '_blank', '1', '1490773598', '1553845598');
INSERT INTO `banner_info` VALUES ('231', '2063', '1', '众鼎新能源汽车', '', '', '', '11', '_blank', '1', '1490774433', '1506672033');
INSERT INTO `banner_info` VALUES ('232', '2063', '2', '中国首家', '', '', '', '0', '_blank', '1', '1490775324', '1493453724');
INSERT INTO `banner_info` VALUES ('233', '76', '1', '招聘', '', '', '', '2', '_blank', '1', '1490837859', '1506735459');
INSERT INTO `banner_info` VALUES ('234', '76', '1', '招聘', '', '', '', '9', '_blank', '1', '1490837987', '1522373987');
INSERT INTO `banner_info` VALUES ('235', '76', '1', '招聘', '', '', '', '10', '_blank', '1', '1490838012', '1522374012');
INSERT INTO `banner_info` VALUES ('236', '76', '1', '招聘', '', '', '', '11', '_blank', '1', '1490838035', '1493516435');
INSERT INTO `banner_info` VALUES ('237', '76', '1', '招聘', '', '', '', '11', '_blank', '1', '1490838069', '1522374069');
INSERT INTO `banner_info` VALUES ('238', '76', '1', '天著温泉', '', '', '', '0', '_blank', '1', '1490838342', '1493516742');
INSERT INTO `banner_info` VALUES ('239', '76', '1', '招聘', '', '', '', '2', '_blank', '1', '1490838757', '1522374757');
INSERT INTO `banner_info` VALUES ('240', '86', '1', '#', '', '', '', '0', '_blank', '1', '1490853795', '1498802595');
INSERT INTO `banner_info` VALUES ('245', '981', '1', '57跑腿', '', '', '', '6', '_blank', '1', '1491353183', '1522889183');
INSERT INTO `banner_info` VALUES ('246', '76', '1', '麻匠', '', '', '', '9', '_blank', '1', '1491356645', '1493948645');
INSERT INTO `banner_info` VALUES ('247', '981', '1', '奥迪', '', '', '', '7', '_blank', '1', '1491784754', '1523320754');
INSERT INTO `banner_info` VALUES ('248', '981', '1', '韩利壁', '', '', '', '7', '_blank', '1', '1491784798', '1523320798');
INSERT INTO `banner_info` VALUES ('249', '981', '1', '奥迪', '', '', '', '8', '_blank', '1', '1491784901', '1523320901');
INSERT INTO `banner_info` VALUES ('250', '2045', '1', '东鹏洁具', '', '', '', '9', '_blank', '1', '1491893595', '1586587995');
INSERT INTO `banner_info` VALUES ('251', '76', '1', '麻将', '', '', '', '9', '_blank', '1', '1491902830', '1494494830');
INSERT INTO `banner_info` VALUES ('252', '1106', '1', '国美电器', '', '', '', '0', '_blank', '1', '1492304499', '1494896499');
INSERT INTO `banner_info` VALUES ('253', '1106', '1', '国美电器', '', '', '', '0', '_blank', '1', '1492304510', '1494896510');
INSERT INTO `banner_info` VALUES ('254', '1106', '1', '那些年烤肉', '', '', '', '1', '_blank', '1', '1492305345', '1494897345');
INSERT INTO `banner_info` VALUES ('255', '1106', '1', '济骨堂', '', '', '', '2', '_blank', '1', '1492305662', '1494897662');
INSERT INTO `banner_info` VALUES ('256', '1106', '1', '张二烧烤', '', '', '', '3', '_blank', '1', '1492305848', '1494897848');
INSERT INTO `banner_info` VALUES ('257', '1106', '1', '牛一鞭', '', '', '', '4', '_blank', '1', '1492306222', '1494898222');
INSERT INTO `banner_info` VALUES ('258', '1106', '1', '利水家园', '', '', '', '6', '_blank', '1', '1492306522', '1494898522');
INSERT INTO `banner_info` VALUES ('259', '1106', '1', '供求世界', '', '', '', '7', '_blank', '1', '1492307035', '1526435035');
INSERT INTO `banner_info` VALUES ('260', '1106', '1', '复合板厂', '', '', '', '8', '_blank', '1', '1492307237', '1494899237');
INSERT INTO `banner_info` VALUES ('261', '1106', '1', '缘味先', '', '', '', '9', '_blank', '1', '1492331507', '1494923507');
INSERT INTO `banner_info` VALUES ('262', '1106', '1', '木格造型', '', '', '', '5', '_blank', '1', '1492332268', '1494924268');
INSERT INTO `banner_info` VALUES ('263', '1106', '1', '优然家居', '', '', '', '10', '_blank', '1', '1492334734', '1494926734');
INSERT INTO `banner_info` VALUES ('264', '1106', '1', '天然海鲜', '', '', '', '11', '_blank', '1', '1492335012', '1494927012');
INSERT INTO `banner_info` VALUES ('265', '1106', '2', '58世界', '', '', '', '0', '_blank', '1', '1492391789', '1494983789');
INSERT INTO `banner_info` VALUES ('266', '1106', '2', '我的天', '', '', '', '1', '_blank', '1', '1492391802', '1494983802');
INSERT INTO `banner_info` VALUES ('267', '1106', '2', '阿萨德了放开手', '', '', '', '2', '_blank', '1', '1492391816', '1497662216');
INSERT INTO `banner_info` VALUES ('268', '86', '1', '#', '', '', '', '1', '_blank', '1', '1492648177', '1495240177');
INSERT INTO `banner_info` VALUES ('269', '86', '1', '#', '', '', '', '2', '_blank', '1', '1492648202', '1495240202');
INSERT INTO `banner_info` VALUES ('270', '86', '1', '#', '', '', '', '3', '_blank', '1', '1492648232', '1495240232');
INSERT INTO `banner_info` VALUES ('271', '86', '1', '#', '', '', '', '4', '_blank', '1', '1492648274', '1495240274');
INSERT INTO `banner_info` VALUES ('272', '86', '1', '#', '', '', '', '4', '_blank', '1', '1492648293', '1495240293');
INSERT INTO `banner_info` VALUES ('273', '86', '1', '#', '', '', '', '5', '_blank', '1', '1492648309', '1495240309');
INSERT INTO `banner_info` VALUES ('274', '86', '1', '#', '', '', '', '6', '_blank', '1', '1492648327', '1495240327');
INSERT INTO `banner_info` VALUES ('275', '86', '1', '#', '', '', '', '7', '_blank', '1', '1492648352', '1495240352');
INSERT INTO `banner_info` VALUES ('276', '86', '1', '#', '', '', '', '8', '_blank', '1', '1492648368', '1495240368');
INSERT INTO `banner_info` VALUES ('277', '86', '1', '#', '', '', '', '9', '_blank', '1', '1492648387', '1495240387');
INSERT INTO `banner_info` VALUES ('278', '86', '1', '#', '', '', '', '10', '_blank', '1', '1492648408', '1495240408');
INSERT INTO `banner_info` VALUES ('279', '86', '1', '#', '', '', '', '11', '_blank', '1', '1492648529', '1495240529');
INSERT INTO `banner_info` VALUES ('280', '86', '2', '#', '', '', '', '0', '_blank', '1', '1492648683', '1495240683');
INSERT INTO `banner_info` VALUES ('281', '86', '2', '#', '', '', '', '1', '_blank', '1', '1492648696', '1495240696');
INSERT INTO `banner_info` VALUES ('282', '86', '2', '#', '', '', '', '2', '_blank', '1', '1492648712', '1495240712');
INSERT INTO `banner_info` VALUES ('284', '3376', '14', '我和你咖啡西点', '', '', '', '0', '_blank', '1', '1492761739', '1495353739');
INSERT INTO `banner_info` VALUES ('285', '2045', '1', '法瑞集成灶', '', '', '', '10', '_blank', '1', '1492825318', '1524361318');
INSERT INTO `banner_info` VALUES ('303', '981', '5', '123123', '', '', '', '0', '_blank', '1', '1529740002', '1535010402');
INSERT INTO `banner_info` VALUES ('304', '981', '22', '123123', '', '', '', '0', '_blank', '1', '1507788385', '1510466785');
INSERT INTO `banner_info` VALUES ('306', '981', '22', 'sdfsdf', '', '', '', '2', '_blank', '1', '1507788417', '1510466817');
INSERT INTO `banner_info` VALUES ('307', '981', '23', 'sdfsdfsdf', '', '', '', '0', '_blank', '1', '1522650638', '1533191438');
INSERT INTO `banner_info` VALUES ('311', '981', '3', '你妹啊', '', '', '', '1', '_blank', '1', '1529738842', '1592897242');
INSERT INTO `banner_info` VALUES ('312', '981', '3', '你妹妹呀', '', '', '', '2', '_blank', '1', '1529738861', '1592897261');
INSERT INTO `banner_info` VALUES ('314', '981', '35', '百事帮', '', '', '', '0', '_blank', '1', '1529740406', '1571817206');
INSERT INTO `banner_info` VALUES ('317', '981', '37', '发大财', '', '', '', '0', '_blank', '1', '1529740517', '1582444517');
INSERT INTO `banner_info` VALUES ('318', '981', '35', 'gqsj', '', '', '', '1', '_blank', '1', '1529740413', '1577087613');
INSERT INTO `banner_info` VALUES ('319', '981', '37', 'nn', '', '', '', '1', '_blank', '1', '1529740624', '1566547024');
INSERT INTO `banner_info` VALUES ('320', '981', '36', 'c', '', '', '', '0', '_blank', '1', '1522030715', '1532571515');
INSERT INTO `banner_info` VALUES ('321', '981', '17', '1', '', '', '', '0', '_blank', '1', '1522651305', '1525243305');
INSERT INTO `banner_info` VALUES ('322', '981', '8', '2', '', '', '', '0', '_blank', '1', '1529740337', '1577087537');
INSERT INTO `banner_info` VALUES ('323', '981', '39', '1', '', '', '', '0', '_blank', '1', '1529740540', '1561276540');
INSERT INTO `banner_info` VALUES ('326', '981', '12', 'cs', '', '', '', '0', '_blank', '1', '1523518576', '1526110576');
INSERT INTO `banner_info` VALUES ('327', '981', '44', '123123', '', '', '', '0', '_blank', '1', '1529740615', '1577087815');
INSERT INTO `banner_info` VALUES ('329', '981', '29', '#', '', '', '', '0', '_blank', '1', '1529740385', '1577087585');
INSERT INTO `banner_info` VALUES ('330', '981', '3', '111', '', '', '', '3', '_blank', '1', '1529738905', '1542958105');
INSERT INTO `banner_info` VALUES ('331', '981', '3', '#', '', '', '', '4', '_blank', '1', '1529739009', '1532331009');
INSERT INTO `banner_info` VALUES ('332', '981', '3', '1', '', '', '', '5', '_blank', '1', '1529739112', '1561275112');
INSERT INTO `banner_info` VALUES ('333', '981', '3', '#', '', '', '', '6', '_blank', '1', '1529739125', '1532331125');
INSERT INTO `banner_info` VALUES ('334', '981', '3', '#', '', '', '', '7', '_blank', '1', '1529739141', '1532331141');
INSERT INTO `banner_info` VALUES ('335', '981', '6', '#', '', '', '', '0', '_blank', '1', '1529740300', '1537689100');
INSERT INTO `banner_info` VALUES ('336', '981', '7', '#', '', '', '', '0', '_blank', '1', '1529740329', '1540281129');
INSERT INTO `banner_info` VALUES ('337', '981', '9', '#', '', '', '', '0', '_blank', '1', '1529740348', '1545551548');
INSERT INTO `banner_info` VALUES ('338', '981', '10', '#', '', '', '', '0', '_blank', '1', '1529740361', '1545551561');
INSERT INTO `banner_info` VALUES ('339', '981', '11', '#', '', '', '', '0', '_blank', '1', '1529740375', '1542959575');
INSERT INTO `banner_info` VALUES ('340', '981', '32', '#', '', '', '', '0', '_blank', '1', '1529740399', '1537689199');
INSERT INTO `banner_info` VALUES ('341', '981', '35', '#', '', '', '', '2', '_blank', '1', '1529740424', '1532332424');
INSERT INTO `banner_info` VALUES ('342', '981', '35', '#', '', '', '', '3', '_blank', '1', '1529740437', '1537689237');
INSERT INTO `banner_info` VALUES ('343', '981', '35', '#', '', '', '', '4', '_blank', '1', '1529740451', '1532332451');
INSERT INTO `banner_info` VALUES ('344', '981', '35', '#', '', '', '', '5', '_blank', '1', '1529740464', '1532332464');
INSERT INTO `banner_info` VALUES ('345', '981', '35', '#', '', '', '', '6', '_blank', '1', '1529740480', '1532332480');
INSERT INTO `banner_info` VALUES ('346', '981', '35', '#', '', '', '', '7', '_blank', '1', '1529740492', '1532332492');
INSERT INTO `banner_info` VALUES ('347', '981', '36', '#', '', '', '', '1', '_blank', '1', '1529740508', '1532332508');
INSERT INTO `banner_info` VALUES ('348', '981', '38', '#', '', '', '', '0', '_blank', '1', '1529740531', '1532332531');
INSERT INTO `banner_info` VALUES ('349', '981', '40', '#', '', '', '', '0', '_blank', '1', '1529740556', '1532332556');
INSERT INTO `banner_info` VALUES ('350', '981', '41', '#', '', '', '', '0', '_blank', '1', '1529740575', '1532332575');
INSERT INTO `banner_info` VALUES ('351', '981', '42', '#', '', '', '', '0', '_blank', '1', '1529740592', '1532332592');
INSERT INTO `banner_info` VALUES ('352', '981', '43', '#', '', '', '', '0', '_blank', '1', '1529740606', '1532332606');
INSERT INTO `banner_info` VALUES ('353', '981', '38', '#', '', '', '', '1', '_blank', '1', '1529740638', '1532332638');
INSERT INTO `banner_info` VALUES ('354', '981', '39', '#', '', '', '', '1', '_blank', '1', '1529740653', '1532332653');
INSERT INTO `banner_info` VALUES ('355', '981', '40', '#', '', '', '', '1', '_blank', '1', '1529740666', '1532332666');
INSERT INTO `banner_info` VALUES ('356', '981', '41', '#', '', '', '', '1', '_blank', '1', '1529740688', '1532332688');
INSERT INTO `banner_info` VALUES ('357', '981', '42', '#', '', '', '', '1', '_blank', '1', '1529740706', '1532332706');
INSERT INTO `banner_info` VALUES ('358', '981', '43', '#', '', '', '', '1', '_blank', '1', '1529740720', '1532332720');
INSERT INTO `banner_info` VALUES ('359', '981', '44', '#', '', '', '', '1', '_blank', '1', '1529740735', '1532332735');
INSERT INTO `banner_info` VALUES ('361', '0', '1', '#', '', '', '', '0', '_blank', '1', '0', '0');
INSERT INTO `banner_info` VALUES ('364', '0', '1', '###', '', '', '', '2', '_blank', '1', '0', '0');
INSERT INTO `banner_info` VALUES ('365', '0', '1', '##', '', '', '', '1', '_blank', '1', '0', '0');
INSERT INTO `banner_info` VALUES ('366', '0', '1', '##', '', '', '', '4', '_blank', '1', '0', '0');
INSERT INTO `banner_info` VALUES ('367', '0', '3', '#', '', '', '', '0', '_blank', '1', '0', '0');
INSERT INTO `banner_info` VALUES ('368', '0', '1', '###', '', '', '', '11', '_blank', '1', '0', '0');
INSERT INTO `banner_info` VALUES ('369', '0', '12', '#$$', '', '', '', '0', '_blank', '1', '0', '0');
INSERT INTO `banner_info` VALUES ('370', '0', '12', '34234234', '', '', '', '7', '_blank', '1', '0', '0');