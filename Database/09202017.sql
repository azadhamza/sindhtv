/*
SQLyog Enterprise - MySQL GUI v7.15 
MySQL - 5.6.17 : Database - sindh_tv_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

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

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;