# ************************************************************
# Sequel Ace SQL dump
# Version 20095
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: 127.0.01 (MySQL 12.1.2-MariaDB)
# Database: food_app
# Generation Time: 2026-05-05 12:50:53 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table foods
# ------------------------------------------------------------

DROP TABLE IF EXISTS `foods`;

CREATE TABLE `foods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `protein` float DEFAULT 0,
  `carb` float DEFAULT 0,
  `fat` float DEFAULT 0,
  `calories` float DEFAULT 0,
  `image_url` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `foods` WRITE;
/*!40000 ALTER TABLE `foods` DISABLE KEYS */;

INSERT INTO `foods` (`id`, `name`, `description`, `protein`, `carb`, `fat`, `calories`, `image_url`)
VALUES
	(1,'อกไก่นึ่ง','อกไก่นึ่งนุ่มๆ ไขมันต่ำ โปรตีนสูง เหมาะสำหรับคนรักสุขภาพ',31,0,3.6,165,'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d'),
	(2,'ข้าวผัดกะเพราไข่ดาว','เมนูยอดฮิตรสชาติเผ็ดร้อน เสิร์ฟพร้อมไข่ดาวกรอบๆ',18,45,15,387,'https://images.unsplash.com/photo-1562967914-608f82629710'),
	(3,'แซลมอนย่างเกลือ','แซลมอนนอร์เวย์ย่างพอดีคำ อุดมไปด้วย Omega-3',25,0,13,217,'https://images.unsplash.com/photo-1467003909585-2f8a72700288'),
	(4,'สลัดผักรวม','ผักออร์แกนิคสดใหม่ ทานคู่กับน้ำสลัดงาญี่ปุ่น',2,10,5,93,'https://images.unsplash.com/photo-1512621776951-a57141f2eefd'),
	(5,'กรีกโยเกิร์ตผลไม้รวม','โยเกิร์ตเนื้อเข้มข้น ท็อปปิ้งด้วยสตรอว์เบอร์รี่และบลูเบอร์รี่',10,15,4,136,'https://images.unsplash.com/photo-1488477181946-6428a0291777'),
	(6,'พาสต้าคาโบนาร่า','เส้นพาสต้าคลุกเคล้าซอสครีมเข้มข้น เบคอนกรอบ และชีสพาร์เมซาน',15,65,22,518,'https://images.unsplash.com/photo-1612874742237-6526221588e3'),
	(7,'สเต็กเนื้อทีโบน','เนื้อทีโบนย่างระดับ Medium Rare เสิร์ฟพร้อมผักย่าง',48,0,32,480,'https://images.unsplash.com/photo-1546241072-48010ad28c2c'),
	(8,'อะโวคาโดโทสต์','ขนมปังโฮลวีทปิ้ง ท็อปด้วยอะโวคาโดบดและไข่ดาวน้ำ',12,28,18,322,'https://images.unsplash.com/photo-1525351484163-7529414344d8'),
	(9,'แพนเค้กผลไม้สด','แพนเค้กนุ่มฟู ราดน้ำผึ้งและผลไม้ตระกูลเบอร์รี่',6,55,8,316,'https://images.unsplash.com/photo-1528207772081-41717dad514f'),
	(12,'มาม่า','เทส222',50,30,20,500,'https://www.sahapat.co.th/product/assets/uploads/img/product/image_th/20230411032520_90826C7B-0C9E-4DD6-B9F0-F102D765A788.jpg');

/*!40000 ALTER TABLE `foods` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nickname` varchar(50) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `username`, `password`, `nickname`, `role`)
VALUES
	(1,'admin','1234','Admin Master','admin');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
