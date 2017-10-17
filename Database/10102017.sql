/*
SQLyog Enterprise - MySQL GUI v7.15 
MySQL - 5.6.17 : Database - sindh_tv_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `settings` */

DROP TABLE IF EXISTS `settings`;

CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(55) DEFAULT NULL,
  `value` text,
  `channel_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `settings` */

insert  into `settings`(`id`,`key`,`value`,`channel_id`) values (1,'live_stream_link','http://poovee.net/embedlive/369/sindh-tv-news-/?autoplay=1',3);
insert  into `settings`(`id`,`key`,`value`,`channel_id`) values (2,'live_stream_thumb','http://local.sindhtv/assets/uploads/settings/live_stream_link/thumb/1.png',3);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;