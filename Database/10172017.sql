/*
SQLyog Enterprise - MySQL GUI v7.15 
MySQL - 5.6.17 : Database - sindh_tv_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `user_upload` */

CREATE TABLE `user_upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `description` text,
  `email` varchar(100) DEFAULT NULL,
  `file` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `user_upload` */

insert  into `user_upload`(`id`,`name`,`phone_number`,`description`,`email`,`file`) values (1,'Talha Uddin','03132155273','This is description','talha.udin@gmail.com','assets/uploads/user_upload/IMG_52681.mp4');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;