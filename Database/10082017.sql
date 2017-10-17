/*
SQLyog Enterprise - MySQL GUI v7.15 
MySQL - 5.6.17 : Database - sindh_tv_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

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
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `content` */

insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`,`category_id`) values (1,17,'Test','<p>This is Test</p>',NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00','a:1:{s:8:\"category\";s:1:\"8\";}',1,'2017-10-05 01:23:09',1,3,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`,`category_id`) values (2,17,'Test 2','<p>This is test&nbsp;</p>',NULL,'0000-00-00 00:00:00','2017-10-04 00:25:08','a:1:{s:8:\"category\";s:1:\"4\";}',1,'2017-10-05 00:37:38',1,3,NULL);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`,`category_id`) values (3,18,'Video A','<p>???????This is test</p>','Episode 1','0000-00-00 00:00:00','0000-00-00 00:00:00','a:3:{s:12:\"sub_category\";s:7:\"episode\";s:4:\"type\";s:4:\"link\";s:4:\"link\";s:0:\"\";}',1,'2017-10-08 13:55:24',1,3,14);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`,`category_id`) values (4,18,'Video C','<p>dsff</p>','09/22/2017','0000-00-00 00:00:00','0000-00-00 00:00:00','a:4:{s:12:\"sub_category\";s:4:\"date\";s:8:\"category\";s:1:\"7\";s:4:\"type\";s:4:\"link\";s:4:\"link\";s:0:\"\";}',1,'2017-10-08 13:56:49',1,3,14);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`,`category_id`) values (6,18,'Video C','<p>THis is test</p>','09/21/2017','0000-00-00 00:00:00','0000-00-00 00:00:00','a:3:{s:12:\"sub_category\";s:4:\"date\";s:4:\"type\";s:4:\"link\";s:4:\"link\";s:15:\"www.youtube.com\";}',1,'2017-10-08 13:55:58',1,3,14);
insert  into `content`(`content_id`,`content_type_id`,`title`,`description`,`detail_description`,`end_date`,`start_date`,`data`,`is_active`,`modified_time`,`is_approved`,`channel_id`,`category_id`) values (7,18,'Video A','<p>THis&nbsp; is test</p>','Episode 2','0000-00-00 00:00:00','0000-00-00 00:00:00','a:3:{s:12:\"sub_category\";s:7:\"episode\";s:4:\"type\";s:4:\"link\";s:4:\"link\";s:0:\"\";}',1,'2017-10-08 13:56:43',1,3,14);

/*Table structure for table `video_category` */

DROP TABLE IF EXISTS `video_category`;

CREATE TABLE `video_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `channel_id` int(11) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

/*Data for the table `video_category` */

insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (1,'Morning Show',2,NULL);
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (2,'Drama',2,NULL);
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (3,'Music',2,NULL);
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (4,'Kids & Cooking Show',2,NULL);
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (5,'User Videos',2,NULL);
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (11,'Talk Show',3,'assets/images/menu/talkshow_menu.png');
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (12,'Reports',3,'assets/images/menu/morning_menu.png');
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (13,'Education, Health, Youth & Women Affairs',3,'assets/images/menu/editorvideo_menu.png');
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (14,'Mysticism & Literature',3,'assets/images/menu/drama_menu.png');
insert  into `video_category`(`id`,`category`,`channel_id`,`icon`) values (15,'User Videos',3,'assets/images/menu/user_video.png');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;