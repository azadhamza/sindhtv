/*
SQLyog Enterprise - MySQL GUI v7.15 
MySQL - 5.6.17 : Database - sindh_tv_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `channels` */

DROP TABLE IF EXISTS `channels`;

CREATE TABLE `channels` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `channels` */

insert  into `channels`(`id`,`title`,`description`,`image`) values (1,'Daily Jeejal','Daily Jeejal ePaper','/assets/images/dailyjeelal.png');
insert  into `channels`(`id`,`title`,`description`,`image`) values (2,'Sindh TV Network','Sindh TV LIVE','/assets/images/sindhtv.png');
insert  into `channels`(`id`,`title`,`description`,`image`) values (3,'Sindh Tv News','Sindh Tv News LIVE','/assets/images/sindhtvnews.png');

/*Table structure for table `content` */

DROP TABLE IF EXISTS `content`;

CREATE TABLE `content` (
  `content_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content_type_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `detail_description` text,
  `end_date` datetime DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `data` text,
  `is_active` tinyint(1) DEFAULT '1' COMMENT '0=inactive, 1=active',
  `modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_approved` tinyint(1) DEFAULT '1',
  `channel_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=latin1;

/*Data for the table `content` */

insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (91,17,'Test News','This is Desc',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',1,'2017-09-30 17:41:04',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (92,17,'Test','Test Desc',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',1,'2017-09-30 17:41:22',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (93,17,'Test 2','Test Desc',NULL,NULL,NULL,'N;',1,'2017-09-30 17:41:19',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (94,17,'Test 2','Test Desc',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',0,'2017-09-29 22:37:24',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (95,17,'Test 2','Test Desc',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',1,'2017-09-28 01:24:53',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (96,17,'Test 2','Test Desc',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',1,'2017-09-28 01:25:08',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (97,17,'Test','saaasda',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',1,'2017-09-28 01:25:30',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (98,17,'Test','saaasda',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',1,'2017-09-28 01:25:58',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (99,17,'Test','saaasda',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','s:0:\"\";',1,'2017-09-28 01:26:37',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (100,18,'Title','<p>Thisistgest</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:2:{s:4:\"type\";s:6:\"upload\";s:4:\"link\";s:4:\"ffff\";}',1,'2017-09-30 17:47:28',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (101,18,'Title','<p>Thisistgest</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:1:{s:4:\"link\";s:4:\"ffff\";}',1,'2017-09-30 17:47:19',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (102,18,'Title Test','<p>This is test?????</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:2:{s:4:\"type\";s:6:\"upload\";s:4:\"link\";s:10:\"thisistest\";}',1,'2017-09-30 17:47:24',1,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (103,17,'Test Channel  News','<p>THis is channel news</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:1:{s:8:\"category\";s:1:\"2\";}',1,'2017-10-01 16:16:46',1,1);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (104,18,'Channel Video Titielq','<p>This is Tesst desc</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:2:{s:4:\"type\";s:4:\"link\";s:4:\"link\";s:12:\"this is test\";}',1,'2017-09-30 18:34:32',1,2);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (105,17,'Tets','<p>This is Test?</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:1:{s:8:\"category\";s:1:\"3\";}',1,'2017-09-30 19:34:47',1,2);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (106,18,'Video1','<p>Thisisstets</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:3:{s:8:\"category\";s:1:\"3\";s:4:\"type\";s:6:\"upload\";s:4:\"link\";s:4:\"test\";}',1,'2017-10-01 14:12:13',1,1);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`) values (107,18,'Title','<p>Test</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:3:{s:8:\"category\";s:1:\"1\";s:4:\"type\";s:6:\"upload\";s:4:\"link\";s:0:\"\";}',1,'2017-10-01 14:39:28',1,1);

/*Table structure for table `content_type` */

DROP TABLE IF EXISTS `content_type`;

CREATE TABLE `content_type` (
  `content_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`content_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

/*Data for the table `content_type` */

insert  into `content_type`(`content_type_id`,`content`) values (17,'news');
insert  into `content_type`(`content_type_id`,`content`) values (18,'videos');

/*Table structure for table `image` */

DROP TABLE IF EXISTS `image`;

CREATE TABLE `image` (
  `image_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT '0=inactive, 1=active',
  `page_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Data for the table `image` */

insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (1,'2.png','http://local.sindhtv/assets/uploads/news/99/',99,1,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (2,'1.png','http://local.sindhtv/assets/uploads/news/99/',99,1,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (3,'1.png','http://local.sindhtv/assets/uploads/news/91/',91,0,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (4,'11.png','http://local.sindhtv/assets/uploads/news/91/',91,1,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (5,'dailyjeelal.png','http://local.sindhtv/assets/uploads/news/103/',103,1,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (6,'sindhtv.png','http://local.sindhtv/assets/uploads/news/105/',105,1,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (7,'sindhtvnews.png','http://local.sindhtv/assets/uploads/videos/106/',106,0,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (8,'1.png','http://local.sindhtv/assets/uploads/videos/106/',106,0,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (9,'19275084_2043240182369141_6995611065707111316_n.jpg','http://local.sindhtv/assets/uploads/videos/106/',106,0,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (10,'11.png','http://local.sindhtv/assets/uploads/videos/106/',106,0,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (11,'2.png','http://local.sindhtv/assets/uploads/videos/107/',107,1,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (12,'Confirmation.pdf','http://local.sindhtv/assets/uploads/videos/106/',106,0,NULL);
insert  into `image`(`image_id`,`name`,`path`,`content_id`,`is_active`,`page_id`) values (13,'IMG_5268.mp4','http://local.sindhtv/assets/uploads/videos/106/',106,1,NULL);

/*Table structure for table `news_category` */

DROP TABLE IF EXISTS `news_category`;

CREATE TABLE `news_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

/*Data for the table `news_category` */

insert  into `news_category`(`id`,`category`) values (1,'Agriculture');
insert  into `news_category`(`id`,`category`) values (2,'Cooking Shows');
insert  into `news_category`(`id`,`category`) values (3,'Dramas');
insert  into `news_category`(`id`,`category`) values (4,'Education');
insert  into `news_category`(`id`,`category`) values (5,'Entertainment');
insert  into `news_category`(`id`,`category`) values (6,'Health');
insert  into `news_category`(`id`,`category`) values (7,'Kids');
insert  into `news_category`(`id`,`category`) values (8,'Lecture');
insert  into `news_category`(`id`,`category`) values (9,'Life Style');
insert  into `news_category`(`id`,`category`) values (10,'Literature');
insert  into `news_category`(`id`,`category`) values (11,'Morning Shows');
insert  into `news_category`(`id`,`category`) values (12,'Music Shows');
insert  into `news_category`(`id`,`category`) values (13,'Mysticism');
insert  into `news_category`(`id`,`category`) values (14,'Pakistan');
insert  into `news_category`(`id`,`category`) values (15,'Promos');
insert  into `news_category`(`id`,`category`) values (16,'Reports');
insert  into `news_category`(`id`,`category`) values (17,'Songs');
insert  into `news_category`(`id`,`category`) values (18,'Special Events');
insert  into `news_category`(`id`,`category`) values (19,'Sports');
insert  into `news_category`(`id`,`category`) values (20,'Talk Shows');
insert  into `news_category`(`id`,`category`) values (21,'Top Stories');
insert  into `news_category`(`id`,`category`) values (22,'User Videos');
insert  into `news_category`(`id`,`category`) values (23,'Women affairs');
insert  into `news_category`(`id`,`category`) values (24,'World, Business');
insert  into `news_category`(`id`,`category`) values (25,'Youth Affairs');
insert  into `news_category`(`id`,`category`) values (26,'بين الاقوامي');
insert  into `news_category`(`id`,`category`) values (27,'پاڪستان');
insert  into `news_category`(`id`,`category`) values (28,'تعليم');
insert  into `news_category`(`id`,`category`) values (29,'ٽيڪنالوجي');
insert  into `news_category`(`id`,`category`) values (30,'جرم');
insert  into `news_category`(`id`,`category`) values (31,'دلچسپ ۽ عجيب');
insert  into `news_category`(`id`,`category`) values (32,'رانديون');
insert  into `news_category`(`id`,`category`) values (33,'سنڌ');
insert  into `news_category`(`id`,`category`) values (34,'شوبز');
insert  into `news_category`(`id`,`category`) values (35,'صحت');
insert  into `news_category`(`id`,`category`) values (36,'ڪاروبار');
insert  into `news_category`(`id`,`category`) values (37,'ڪرڪيٽ');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `user_id` double NOT NULL AUTO_INCREMENT,
  `username` varchar(765) DEFAULT NULL,
  `password` varchar(765) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `users` */

insert  into `users`(`user_id`,`username`,`password`,`is_active`,`verified`,`is_admin`) values (1,'admin@sindhtv.com','click123',1,1,1);

/*Table structure for table `video_category` */

DROP TABLE IF EXISTS `video_category`;

CREATE TABLE `video_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

/*Data for the table `video_category` */

insert  into `video_category`(`id`,`category`) values (1,'Live');
insert  into `video_category`(`id`,`category`) values (2,'News');
insert  into `video_category`(`id`,`category`) values (3,'Education/Health');
insert  into `video_category`(`id`,`category`) values (4,'Music');
insert  into `video_category`(`id`,`category`) values (5,'Gaming');
insert  into `video_category`(`id`,`category`) values (6,'Sports');
insert  into `video_category`(`id`,`category`) values (7,'CCTV Camera');
insert  into `video_category`(`id`,`category`) values (8,'Drama');
insert  into `video_category`(`id`,`category`) values (9,'Islamic');
insert  into `video_category`(`id`,`category`) values (10,'Cooking');
insert  into `video_category`(`id`,`category`) values (11,'Regional');
insert  into `video_category`(`id`,`category`) values (12,'Sports');
insert  into `video_category`(`id`,`category`) values (13,'Videos');
insert  into `video_category`(`id`,`category`) values (14,'News');
insert  into `video_category`(`id`,`category`) values (15,'Education');
insert  into `video_category`(`id`,`category`) values (16,'Music');
insert  into `video_category`(`id`,`category`) values (17,'Cooking');
insert  into `video_category`(`id`,`category`) values (18,'Automotive');
insert  into `video_category`(`id`,`category`) values (19,'Funny');
insert  into `video_category`(`id`,`category`) values (20,'Gaming');
insert  into `video_category`(`id`,`category`) values (21,'Sports');
insert  into `video_category`(`id`,`category`) values (22,'Technology');
insert  into `video_category`(`id`,`category`) values (23,'Animals');
insert  into `video_category`(`id`,`category`) values (24,'Talk Shows');
insert  into `video_category`(`id`,`category`) values (25,'Morning Shows');
insert  into `video_category`(`id`,`category`) values (26,'Kids');
insert  into `video_category`(`id`,`category`) values (27,'Youth &amp; Women Affairs');
insert  into `video_category`(`id`,`category`) values (28,'Mysticism &amp; Literature');
insert  into `video_category`(`id`,`category`) values (29,'Reports');
insert  into `video_category`(`id`,`category`) values (30,'Promos');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;