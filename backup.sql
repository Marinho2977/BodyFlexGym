-- MySQL dump 10.13  Distrib 9.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: railway
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `tipo` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `actor_id` bigint unsigned DEFAULT NULL,
  `actor_nombre` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `actor_rol` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `afectado_id` bigint unsigned DEFAULT NULL,
  `afectado_nombre` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `detalle` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=313 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria`
--

LOCK TABLES `auditoria` WRITE;
/*!40000 ALTER TABLE `auditoria` DISABLE KEYS */;
INSERT INTO `auditoria` VALUES (1,'2026-03-08 20:19:16','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(2,'2026-03-08 20:19:31','rol',15,'Mariño','admin',17,'manuel lopezx','Asignó como Empleado'),(3,'2026-03-08 20:19:36','desactivar',15,'Mariño','admin',17,'manuel lopezx','Desactivó la cuenta'),(4,'2026-03-08 20:19:47','rol',15,'Mariño','admin',17,'manuel lopezx','Quitó rol Empleado → Usuario'),(5,'2026-03-08 20:19:48','activacion',15,'Mariño','admin',17,'manuel lopezx','Reactivó la cuenta'),(6,'2026-03-08 20:19:50','rol',15,'Mariño','admin',16,'santii pérez','Asignó como Empleado'),(7,'2026-03-08 20:20:36','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(8,'2026-03-08 20:25:04','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(9,'2026-03-08 20:25:35','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(10,'2026-03-09 10:05:23','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(11,'2026-03-09 10:06:12','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(12,'2026-03-09 10:27:34','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(13,'2026-03-09 11:58:38','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(14,'2026-03-09 12:01:26','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(18,'2026-03-09 12:08:58','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(19,'2026-03-09 12:09:09','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(23,'2026-03-09 12:11:14','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(24,'2026-03-09 12:11:17','rol',15,'Mariño','admin',19,'jesus fuentes','Asignó como Empleado'),(25,'2026-03-09 12:11:20','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(26,'2026-03-09 12:11:42','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(27,'2026-03-09 16:32:53','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(28,'2026-03-09 16:34:10','desactivar',15,'Mariño','admin',18,'Clinton Pineda','Desactivó la cuenta'),(29,'2026-03-09 16:34:48','activacion',15,'Mariño','admin',18,'Clinton Pineda','Reactivó la cuenta'),(30,'2026-03-09 16:34:55','desactivar',15,'Mariño','admin',18,'Clinton Pineda','Desactivó la cuenta'),(31,'2026-03-09 16:35:55','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(35,'2026-03-09 16:37:50','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(36,'2026-03-09 16:37:56','desactivar',15,'Mariño','admin',20,'Cristina Sente','Desactivó la cuenta'),(37,'2026-03-09 16:37:58','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(38,'2026-03-09 16:39:09','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(39,'2026-03-09 16:39:11','activacion',15,'Mariño','admin',20,'Cristina Sente','Reactivó la cuenta'),(40,'2026-03-09 16:39:18','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(44,'2026-03-09 16:42:06','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(45,'2026-03-09 16:42:47','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(46,'2026-03-09 16:43:13','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(47,'2026-03-09 16:43:27','rol',15,'Mariño','admin',20,'Cristina Sente','Asignó como Empleado'),(48,'2026-03-09 16:43:54','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(49,'2026-03-09 16:44:07','login',20,'Cristina','empleado',NULL,NULL,'Inició sesión'),(50,'2026-03-09 16:44:45','pago',20,'Cristina','empleado',17,'manuel lopezx','Registró pago de 1 mes(es) — Q225.00'),(51,'2026-03-09 16:45:07','pago',20,'Cristina','empleado',17,'manuel lopezx','Registró pago de 3 mes(es) — Q675.00'),(52,'2026-03-09 19:03:23','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(53,'2026-03-09 19:03:48','activacion',15,'Mariño','admin',18,'Clinton Pineda','Reactivó la cuenta'),(54,'2026-03-09 19:34:08','login',16,'santii','empleado',NULL,NULL,'Inició sesión'),(55,'2026-03-09 19:34:16','login',16,'santii','empleado',NULL,NULL,'Cerró sesión'),(56,'2026-03-09 20:07:21','login',16,'santii','empleado',NULL,NULL,'Inició sesión'),(57,'2026-03-09 20:07:32','login',16,'santii','empleado',NULL,NULL,'Cerró sesión'),(58,'2026-03-09 20:07:52','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(59,'2026-03-09 20:07:59','rol',15,'Mariño','admin',16,'santii pérez','Quitó rol Empleado → Usuario'),(60,'2026-03-09 20:08:02','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(64,'2026-03-09 20:08:48','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(65,'2026-03-09 20:09:17','pago',15,'Mariño','admin',18,'Clinton Pineda','Registró pago de 1 mes(es) — Q225.00'),(66,'2026-03-09 20:28:59','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(67,'2026-03-09 20:46:55','pago',15,'Mariño','admin',16,'santii pérez','Registró pago de 2 mes(es) — Q450.00'),(68,'2026-03-09 20:47:17','pago',15,'Mariño','admin',18,'Clinton Pineda','Registró pago de 2 mes(es) — Q450.00'),(69,'2026-04-03 17:25:21','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(70,'2026-04-03 17:29:37','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(71,'2026-04-13 16:16:09','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(72,'2026-04-13 16:18:16','pago',15,'Mariño','admin',16,'santii pérez','Registró pago de 3 mes(es) — Q675.00'),(73,'2026-04-13 22:04:30','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(74,'2026-04-13 22:06:31','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(75,'2026-04-13 22:06:34','login',NULL,'Sistema','—',NULL,NULL,'Cerró sesión'),(76,'2026-04-13 22:07:09','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(77,'2026-04-13 22:09:37','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(78,'2026-04-13 22:10:17','pago',15,'Mariño','admin',16,'santii pérez','Registró pago de 3 mes(es) — Q675.00'),(79,'2026-04-13 22:12:26','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(80,'2026-04-13 22:12:30','login',NULL,'Sistema','—',NULL,NULL,'Cerró sesión'),(81,'2026-04-13 22:12:31','login',NULL,'Sistema','—',NULL,NULL,'Cerró sesión'),(83,'2026-04-13 22:16:34','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(84,'2026-04-13 22:16:45','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(85,'2026-04-13 22:29:31','login',NULL,'Sistema','—',NULL,NULL,'Cerró sesión'),(86,'2026-04-14 21:36:13','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(87,'2026-04-14 21:36:34','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(92,'2026-04-14 22:23:53','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(93,'2026-04-14 22:24:46','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(94,'2026-04-18 21:31:46','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(95,'2026-04-18 21:33:48','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(96,'2026-04-20 13:36:05','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(97,'2026-04-20 14:00:56','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(98,'2026-04-20 14:02:18','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(99,'2026-04-20 17:05:53','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(102,'2026-04-20 18:21:44','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(103,'2026-04-20 18:22:14','pago',15,'Mariño','admin',5877878775648,'martinico diaznho','Registró pago de 1 mes(es) — Q225.00'),(105,'2026-04-20 21:48:36','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(107,'2026-04-20 21:48:41','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(108,'2026-04-20 21:48:41','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(109,'2026-04-20 21:49:15','desactivar',15,'Mariño','admin',5877878775648,'martinico diaznho','Desactivó la cuenta'),(110,'2026-04-20 21:50:40','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(111,'2026-04-20 21:50:45','login',NULL,'Sistema','—',NULL,NULL,'Cerró sesión'),(113,'2026-04-20 21:51:41','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(114,'2026-04-20 21:52:04','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(116,'2026-04-20 21:53:20','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(117,'2026-04-21 00:44:49','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(118,'2026-04-22 00:25:49','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(119,'2026-04-22 00:43:36','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(120,'2026-04-22 00:45:58','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(121,'2026-04-22 00:46:09','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(122,'2026-04-22 00:46:10','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(123,'2026-04-22 00:46:10','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(124,'2026-04-22 00:52:23','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(125,'2026-04-22 00:56:00','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(128,'2026-04-27 21:36:23','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(129,'2026-04-27 21:36:36','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(130,'2026-04-27 21:37:52','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(131,'2026-04-27 21:37:58','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(135,'2026-04-27 21:56:12','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(136,'2026-04-27 21:56:34','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(137,'2026-04-27 21:57:04','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(138,'2026-04-27 21:57:58','pago',19,'jesus','empleado',18,'Clinton Pineda','Registró pago de 3 mes(es) — Q675.00'),(139,'2026-04-27 21:59:53','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(140,'2026-04-27 22:00:24','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(141,'2026-04-27 22:00:25','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(142,'2026-04-27 22:05:44','perfil',15,'Mariño','admin',4574124784512,'kevin Mariño','Admin restableció contraseña temporalmente'),(143,'2026-04-27 22:06:00','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(148,'2026-04-27 22:08:07','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(149,'2026-04-27 22:08:34','pago',15,'Mariño','admin',4574124784512,'kevin Mariño','Registró pago de 3 mes(es) — Q675.00'),(150,'2026-04-27 22:08:50','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(153,'2026-04-27 22:12:31','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(154,'2026-04-27 22:15:53','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(155,'2026-05-03 22:03:02','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(156,'2026-05-03 22:03:23','pago',15,'Mariño','admin',21,'jose perez','Registró pago de 3 mes(es) — Q675.00'),(157,'2026-05-03 22:03:35','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(158,'2026-05-03 22:03:50','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(159,'2026-05-03 22:04:09','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(160,'2026-05-03 22:04:17','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(161,'2026-05-03 22:36:28','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(162,'2026-05-03 22:36:40','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(163,'2026-05-03 22:47:20','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(164,'2026-05-06 00:57:42','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(165,'2026-05-06 00:58:23','pago',15,'Mariño','admin',16,'santii pérez','Registró pago de 2 mes(es) — Q450.00'),(166,'2026-05-06 01:01:28','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(167,'2026-05-06 01:01:47','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(168,'2026-05-06 01:02:04','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(169,'2026-05-06 01:02:21','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(170,'2026-05-06 01:22:35','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(173,'2026-05-06 01:38:27','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(174,'2026-05-06 01:39:10','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(175,'2026-05-06 01:39:19','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(176,'2026-05-06 01:39:28','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(177,'2026-05-06 01:41:46','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(178,'2026-05-06 01:45:00','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(179,'2026-05-06 03:10:09','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(180,'2026-05-07 00:58:11','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(181,'2026-05-07 01:06:03','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(182,'2026-05-07 01:09:08','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(183,'2026-05-07 01:10:19','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(184,'2026-05-07 01:10:46','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(185,'2026-05-07 01:11:18','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(186,'2026-05-07 01:11:25','activacion',15,'Mariño','admin',5877878775648,'martinico diaznho','Reactivó la cuenta'),(187,'2026-05-07 01:11:52','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(188,'2026-05-07 01:12:28','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(189,'2026-05-07 01:13:07','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(190,'2026-05-07 01:13:29','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(199,'2026-05-12 03:13:57','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(200,'2026-05-12 03:16:59','pago',19,'jesus','empleado',7878457487415,'Jonathan Cano','Registró pago de 3 mes(es) — Q675.00'),(201,'2026-05-12 03:17:16','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(202,'2026-05-12 03:17:28','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(203,'2026-05-12 03:24:25','rol',15,'Mariño','admin',7878457487415,'Jonathan Cano','Asignó como Empleado'),(204,'2026-05-12 03:24:43','rol',15,'Mariño','admin',7878457487415,'Jonathan Cano','Quitó rol Empleado → Usuario'),(205,'2026-05-18 00:59:58','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(206,'2026-06-09 00:03:20','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(207,'2026-06-09 13:41:32','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(208,'2026-06-09 13:42:48','pago',15,'Mariño','admin',2468653421101,'Kenny Pérez','Registró pago de 1 mes(es) — Q225.00'),(209,'2026-06-09 13:43:57','pago',15,'Mariño','admin',5877878775648,'martinico diaznho','Registró pago de 1 mes(es) — Q225.00'),(211,'2026-06-19 20:41:21','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(212,'2026-06-23 03:04:15','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(213,'2026-06-23 03:50:10','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(214,'2026-06-23 04:33:45','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(215,'2026-06-23 04:35:52','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(216,'2026-06-23 04:51:55','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(219,'2026-06-24 00:00:33','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(220,'2026-06-24 00:01:36','pago',15,'Mariño','admin',1555656555666,'tarawata molongo','Registró pago de 1 mes(es) — Q225.00'),(221,'2026-06-24 00:02:02','pago',15,'Mariño','admin',21,'jose perez','Registró pago de 1 mes(es) — Q225.00'),(224,'2026-06-24 00:12:21','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(225,'2026-06-24 00:13:05','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(226,'2026-06-24 00:13:40','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(227,'2026-06-24 00:15:24','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(228,'2026-07-06 14:06:57','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(229,'2026-07-06 14:06:58','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(230,'2026-07-06 20:28:06','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(231,'2026-07-06 20:28:31','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(234,'2026-07-06 20:29:24','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(235,'2026-07-06 20:29:37','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(236,'2026-07-06 20:41:16','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(237,'2026-07-06 20:41:43','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(239,'2026-07-06 20:42:30','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(240,'2026-07-06 20:42:41','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(243,'2026-07-06 20:52:50','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(244,'2026-07-06 20:53:15','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(247,'2026-07-06 21:04:05','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(248,'2026-07-06 21:04:34','pago',19,'jesus','empleado',21,'jose perez','Registró pago de 3 mes(es) — Q675.00'),(249,'2026-07-06 21:05:20','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(250,'2026-07-06 21:05:31','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(251,'2026-07-06 21:06:20','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(252,'2026-07-06 21:06:31','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(253,'2026-07-06 21:08:36','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(254,'2026-07-06 21:09:45','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(255,'2026-07-06 21:10:21','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(258,'2026-07-06 21:14:02','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(259,'2026-07-06 21:14:44','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(260,'2026-07-06 21:15:02','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(261,'2026-07-06 21:16:20','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(262,'2026-07-07 05:30:03','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(263,'2026-07-07 05:31:58','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(264,'2026-07-07 05:32:06','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(265,'2026-07-07 05:32:34','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(271,'2026-07-09 16:27:03','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(272,'2026-07-09 16:29:45','pago',19,'jesus','empleado',2186198820101,'Juan Perez','Registró pago de 1 mes(es) — Q225.00'),(273,'2026-07-09 16:32:12','login',19,'jesus','empleado',NULL,NULL,'Cerró sesión'),(274,'2026-07-09 16:32:29','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(275,'2026-07-09 16:32:32','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(276,'2026-07-09 16:32:38','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(277,'2026-07-13 01:39:42','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(278,'2026-07-13 02:44:41','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(279,'2026-07-13 02:48:25','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(280,'2026-07-13 03:02:31','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(281,'2026-07-13 03:06:45','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(282,'2026-07-13 03:06:55','login',19,'jesus','empleado',NULL,NULL,'Inició sesión'),(283,'2026-07-13 16:36:11','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(284,'2026-07-14 00:33:10','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(285,'2026-07-14 00:42:12','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(286,'2026-07-14 00:42:16','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(287,'2026-07-15 23:28:14','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(288,'2026-07-16 00:00:15','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(289,'2026-07-18 00:01:00','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(290,'2026-07-18 19:29:52','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(291,'2026-07-18 19:29:56','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(292,'2026-07-19 17:46:36','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(293,'2026-07-19 17:47:06','cargo',15,'Mariño','admin',16,'santii pérez','Creó cargo manual: \'Inscripcion\' (Q65)'),(294,'2026-07-19 17:48:05','pago',15,'Mariño','admin',16,'santii pérez','Pagó cargo manual \'Inscripcion\' (Q65)'),(295,'2026-07-19 18:43:10','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(296,'2026-07-20 19:32:19','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(297,'2026-07-22 01:09:37','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(298,'2026-07-22 17:17:17','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(299,'2026-07-22 17:27:54','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(300,'2026-07-22 17:33:31','INVENTARIO_AGREGAR',15,'Mariño','admin',NULL,NULL,'Producto \'Caminadora\' agregado (Stock: 10, Precio Venta: Q0.00)'),(301,'2026-07-23 02:12:46','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(302,'2026-07-23 03:16:21','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(303,'2026-07-23 03:16:35','INVENTARIO_ELIMINAR',15,'Mariño','admin',NULL,NULL,'Producto ID 1 (\'Caminadora\') eliminado.'),(304,'2026-07-23 03:20:33','cargo',15,'Mariño','admin',5877878775648,'martinico diaznho','Creó cargo manual: \'Botella de agua\' (Q15)'),(305,'2026-07-24 20:37:19','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(306,'2026-07-24 20:43:29','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(307,'2026-07-24 20:46:54','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(308,'2026-07-24 20:47:30','perfil',15,'Mariño','admin',NULL,NULL,'Actualizó su información personal'),(309,'2026-07-24 20:48:07','login',15,'Mariño','admin',NULL,NULL,'Cerró sesión'),(310,'2026-07-24 20:52:01','login',15,'Mariño','admin',NULL,NULL,'Inició sesión'),(311,'2026-07-24 21:49:00','whatsapp_manual',15,'Mariño','admin',15,'Mariño ke','Aviso manual enviado para Mariño ke (vence 29/08/2026)'),(312,'2026-07-24 21:49:02','whatsapp_manual',15,'Mariño','admin',5877878775648,'martinico diaznho','Aviso manual enviado para martinico diaznho (vence 09/07/2026)');
/*!40000 ALTER TABLE `auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cargos`
--

DROP TABLE IF EXISTS `cargos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cargos` (
  `id_cargo` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cui_usuario` bigint NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `monto` decimal(10,0) NOT NULL,
  `fecha_emision` date NOT NULL,
  `estado` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendiente',
  `id_producto` int DEFAULT NULL,
  PRIMARY KEY (`id_cargo`),
  UNIQUE KEY `id_cargo` (`id_cargo`),
  KEY `fk_cargo_producto` (`id_producto`),
  CONSTRAINT `fk_cargo_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cargos`
--

LOCK TABLES `cargos` WRITE;
/*!40000 ALTER TABLE `cargos` DISABLE KEYS */;
INSERT INTO `cargos` VALUES (1,16,'Inscripcion',65,'2026-07-19','pagado',NULL),(2,5877878775648,'Botella de agua',15,'2026-07-23','pendiente',NULL);
/*!40000 ALTER TABLE `cargos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maquinaria`
--

DROP TABLE IF EXISTS `maquinaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquinaria` (
  `id_equipo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cantidad` int NOT NULL DEFAULT '1',
  `zona` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Cardio',
  `estado` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Excelente',
  `foto_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_equipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maquinaria`
--

LOCK TABLES `maquinaria` WRITE;
/*!40000 ALTER TABLE `maquinaria` DISABLE KEYS */;
/*!40000 ALTER TABLE `maquinaria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagos`
--

DROP TABLE IF EXISTS `pagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos` (
  `id_pago` int NOT NULL AUTO_INCREMENT,
  `cui_usuario` bigint unsigned NOT NULL DEFAULT '0',
  `fecha_pago` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `descripcion` varchar(60) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_cargo` int DEFAULT NULL,
  `metodo_pago` enum('efectivo','tarjeta','transferencia') COLLATE utf8mb4_general_ci DEFAULT 'efectivo',
  `referencia` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `pagos_ibfk_1` (`cui_usuario`),
  CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos`
--

LOCK TABLES `pagos` WRITE;
/*!40000 ALTER TABLE `pagos` DISABLE KEYS */;
INSERT INTO `pagos` VALUES (3,16,'2026-03-01','2026-03-31',225.00,NULL,NULL,'efectivo',NULL),(11,16,'2026-03-01','2027-07-24',2250.00,NULL,NULL,'efectivo',NULL),(12,17,'2026-03-01','2026-03-31',225.00,NULL,NULL,'efectivo',NULL),(13,15,'2026-03-02','2026-08-29',1350.00,NULL,NULL,'efectivo',NULL),(14,17,'2026-03-02','2026-08-28',1125.00,NULL,NULL,'efectivo',NULL),(15,16,'2026-03-02','2027-12-21',1125.00,NULL,NULL,'efectivo',NULL),(16,17,'2026-03-03','2026-11-26',675.00,NULL,NULL,'efectivo',NULL),(17,17,'2026-03-03','2027-02-24',675.00,NULL,NULL,'efectivo',NULL),(18,17,'2026-03-03','2027-04-25',450.00,NULL,NULL,'efectivo',NULL),(19,17,'2026-03-03','2027-05-25',225.00,NULL,NULL,'efectivo',NULL),(20,16,'2026-03-07','2028-03-20',675.00,NULL,NULL,'efectivo',NULL),(21,16,'2026-03-07','2028-04-19',225.00,NULL,NULL,'efectivo',NULL),(22,17,'2026-03-09','2027-06-24',225.00,NULL,NULL,'efectivo',NULL),(23,17,'2026-03-09','2027-09-22',675.00,NULL,NULL,'efectivo',NULL),(24,18,'2026-03-09','2026-04-08',225.00,'Marzo 2026',NULL,'efectivo',NULL),(25,16,'2026-03-09','2028-06-18',450.00,'Octubre y Noviembre 2026',NULL,'efectivo',NULL),(26,18,'2026-03-09','2026-06-07',450.00,'Febrero y Marzo 2026',NULL,'efectivo',NULL),(27,16,'2026-04-13','2028-09-16',675.00,'Enero, Febrero y Diciembre 2026',NULL,'efectivo',NULL),(28,16,'2026-04-13','2028-12-15',675.00,'Enero, Febrero y Marzo 2026',NULL,'efectivo',NULL),(29,5877878775648,'2026-04-20','2026-05-20',225.00,'Enero 2026',NULL,'efectivo',NULL),(30,18,'2026-04-27','2026-09-05',675.00,'Enero, Febrero y Marzo 2026',NULL,'efectivo',NULL),(31,4574124784512,'2026-04-27','2026-07-26',675.00,'Enero, Febrero y Marzo 2026',NULL,'efectivo',NULL),(32,21,'2026-05-03','2026-08-01',675.00,'Enero, Febrero y Marzo 2026',NULL,'efectivo',NULL),(33,16,'2026-05-06','2029-02-13',450.00,'Abril y Mayo 2026',NULL,'efectivo',NULL),(34,7878457487415,'2026-05-12','2026-08-10',675.00,'Enero, Febrero y Marzo 2026',NULL,'efectivo',NULL),(35,2468653421101,'2026-06-09','2026-07-09',225.00,'Agosto 2026',NULL,'efectivo',NULL),(36,5877878775648,'2026-06-09','2026-07-09',225.00,'Febrero 2026',NULL,'efectivo',NULL),(37,1555656555666,'2026-06-24','2026-07-24',225.00,'Enero 2026',NULL,'efectivo',NULL),(38,21,'2026-06-24','2026-08-31',225.00,'Abril 2026',NULL,'efectivo',NULL),(39,21,'2026-07-06','2026-11-29',675.00,'Mayo, Junio y Julio 2026',NULL,'efectivo',NULL),(40,2186198820101,'2026-07-09','2026-08-08',225.00,'Julio 2026',NULL,'efectivo',NULL),(41,16,'2026-07-19','2029-02-13',65.00,'Cargo: Inscripcion',1,'efectivo',NULL);
/*!40000 ALTER TABLE `pagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfiles`
--

DROP TABLE IF EXISTS `perfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfiles` (
  `id_perfil` int NOT NULL AUTO_INCREMENT,
  `cui_usuario` bigint unsigned NOT NULL,
  `edad` int DEFAULT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  `altura` decimal(5,2) DEFAULT NULL,
  `objetivo` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_perfil`),
  KEY `cui_usuario` (`cui_usuario`),
  CONSTRAINT `perfiles_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfiles`
--

LOCK TABLES `perfiles` WRITE;
/*!40000 ALTER TABLE `perfiles` DISABLE KEYS */;
INSERT INTO `perfiles` VALUES (1,15,14,14.00,12.50,'aa','2026-07-19 22:51:44'),(2,16,17,15.00,1.27,'Pponerse fuertisimo','2026-07-19 22:51:44'),(3,17,14,12.00,1.24,'volear como fratta','2026-07-19 22:51:44'),(4,18,75,220.00,1.80,'Bajar de peso','2026-07-19 22:51:44'),(5,19,20,130.00,1.85,'Ganar músculo','2026-07-19 22:51:44'),(6,20,30,160.00,1.60,'Mantenimiento','2026-07-19 22:51:44'),(7,21,NULL,NULL,NULL,NULL,'2026-07-19 22:51:44'),(8,1245789359870,NULL,NULL,NULL,NULL,'2026-07-19 22:51:44'),(9,1555656555666,20,200.00,1.95,'Ganar músculo','2026-07-19 22:51:44'),(10,2186198820101,35,180.00,1.60,'Bajar de peso','2026-07-19 22:51:44'),(11,2468653421101,40,160.00,1.70,'Bajar de peso','2026-07-19 22:51:44'),(12,4547454784123,45,47.00,7.41,'Otro','2026-07-19 22:51:44'),(13,4564547274321,21,180.00,1.78,'Mejorar resistencia','2026-07-19 22:51:44'),(14,4574124784512,20,120.00,1.70,'Bajar de peso','2026-07-19 22:51:44'),(15,5877878775648,17,150.00,1.94,'Ganar músculo','2026-07-19 22:51:44'),(16,7878457487415,17,200.00,1.75,'Mejorar resistencia','2026-07-19 22:51:44');
/*!40000 ALTER TABLE `perfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planes_membresia`
--

DROP TABLE IF EXISTS `planes_membresia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planes_membresia` (
  `id_plan` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `duracion_meses` int NOT NULL DEFAULT '1',
  `estado` enum('activo','inactivo') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  PRIMARY KEY (`id_plan`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planes_membresia`
--

LOCK TABLES `planes_membresia` WRITE;
/*!40000 ALTER TABLE `planes_membresia` DISABLE KEYS */;
INSERT INTO `planes_membresia` VALUES (1,'Mensualidad',225.00,1,'activo'),(2,'Promoción Trimestral',600.00,3,'activo'),(3,'Promoción Semestral',1100.00,6,'activo');
/*!40000 ALTER TABLE `planes_membresia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cantidad` int NOT NULL DEFAULT '0',
  `precio_costo` decimal(10,2) DEFAULT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `categoria` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'General',
  `foto_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fecha_agregado` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recuperar_contra`
--

DROP TABLE IF EXISTS `recuperar_contra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recuperar_contra` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `expira` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT '0',
  `cui_usuario` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `recuperar_contra_ibfk_1` (`cui_usuario`),
  CONSTRAINT `recuperar_contra_ibfk_1` FOREIGN KEY (`cui_usuario`) REFERENCES `usuarios` (`cui`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recuperar_contra`
--

LOCK TABLES `recuperar_contra` WRITE;
/*!40000 ALTER TABLE `recuperar_contra` DISABLE KEYS */;
INSERT INTO `recuperar_contra` VALUES (1,'U66hH7zzvvIBko0NsVYTZUdiT3OtMI-zhY4GQryQlKKsXqUl-y6UaXCbBIRDsx_a','2026-03-08 21:20:42',1,15),(2,'0sDMAYshFLD0iflK2xeXIZadmQHovPOwkVL8sTdTX_9G_GKMIDJIsRRKHAbW3esz','2026-03-08 21:20:51',1,16),(3,'IrWaMoXS00cshwRD4vq-Z0qddSdM4gZ9joGllbEzVFNajWUUvNxmx6U7rUmfmT6D','2026-03-08 21:25:40',1,15),(4,'ncySWTu2AZjz_3DWMO7bDIh-meZzPrmMfOpW93I3a4D5vlZszrHjeKdo7Swwl7ZJ','2026-03-08 21:28:01',1,15),(5,'PpOD_8Zyz98LmFkoOkQU9CrmhNKoh67muO_ZnShQTIyY-cJMNgxRzPIZixRtNimv','2026-03-08 21:28:39',1,15),(6,'8N3-kVsZsJC5sm4_dud6t0Bjk3v_H4fi_PW4ErYfpSadGdvVT5FX-7AyiBuiPPmY','2026-03-08 21:33:23',1,15),(7,'-h1iunFyKum1ipy_xWfjqLAfkn52eYSyeEh8U555jtz7Sz5-BK5SseraViqlIs7Y','2026-03-08 22:02:58',1,15),(8,'qEXjy4eyjhIbZma86IRh8JvdN04LYAeQqSOsmIrElNbRpXbIr9u7uq9sXSkfuGxJ','2026-03-08 22:03:05',0,16),(9,'-El4wHmII4ckOIfGDRqq91Q5RgVQkbB4RFzNoNUyPOxaN70qUzISZqdQ-xQk-0I2','2026-03-09 11:06:20',1,15),(10,'9XfJ30ZCjbr2WUdLb7NUDng6Nkzrrlj1_6WdX25CCRI0gCHQaK1wuTYUe0rQIhvl','2026-03-09 11:22:49',1,15),(11,'7u76NdqMmdExmbaYzW6Nq7W7BpGaG1Ts7v5SROvtv_34DVw0_Uh5U-AV5NjSHLL9','2026-03-09 11:26:56',1,15),(12,'JockTkScGtlJty8tZ_geACt3ikFd1DcbzylfEMx3_3_xNBpsWWK6MpqhPCoYBkwd','2026-04-13 23:12:45',1,15),(13,'bl59iHftc1-0ha4fLQxBrU1NP4jH6x4yyhCY6f9-Rd7bKHvQFkGPwu4vweOQa0lO','2026-04-14 22:57:44',0,4547454784123),(14,'b19Cs4cQac8TmaLAzuXdGX1RTslCPNaXGpXr4x7vuvVDdB9_AIAOo9aJhIP4ohoE','2026-04-14 23:25:03',1,15),(15,'f6a-GsYDzxjRp1D4S5qi2_-vdGjjQNdjFYLrwBFBhBJGP3yaYEv_Jxzb6INfZP0U','2026-04-14 23:30:53',1,15),(16,'Lae0x8hbTXtoYtt7LD8BKa7XCOHEaOABKHGRAQ0xXbBMHIraJ6CAkyPn-mcgWJYU','2026-04-14 23:34:34',1,15),(17,'HMiDmS5brU4CvZtlEI8Lwq0GIg2Xwky_Sg3fkxyqd5Aro1-GUiqT03yrh8HsZIFo','2026-04-15 00:09:15',1,15),(18,'Atn1gdMXqF0KtPUF6ER0IxGl5wVhJ-Wzbmz7-ZC2UEiYvnZJEcx5tl1piYqD7Szk','2026-04-16 01:49:55',1,15),(19,'mr0P2FqGYSKxkWtZJ7lxgGYKvkcxXMVS5-fmz3bDblk51S_yxr4DE_GDdjNWtpYg','2026-04-16 02:16:55',1,15),(20,'NAPn8F2Wxud8LxLEP8gedpYuM0NTjt_S_FTljysVj8_WGlh2nNCJ8KhX2dLsoCnj','2026-04-16 03:37:03',1,15),(21,'y-hEuLu9g4kBt-U0wM_X3igl1EiE2YJ2CCx8WtExG2_iTzgaDMx-xYqcFmuvLZ9w','2026-04-20 15:02:35',1,15),(22,'Zx6kPN0Jh3uq7-Q3cTDnEayuMvvDySruF2IpKsE2Ajh3iRg0BC_O87C3N1oUnN8P','2026-04-20 15:03:06',0,15);
/*!40000 ALTER TABLE `recuperar_contra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id_rol` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES ('01','admin'),('02','empleado'),('03','socio');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `cui` bigint unsigned NOT NULL DEFAULT '0',
  `tipo_doc` enum('CUI','DPI') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DPI',
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `apellido` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('activo','inactivo') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_rol` varchar(2) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '03',
  PRIMARY KEY (`cui`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (15,'CUI','Mariño','ke','2026-02-26 18:09:11','activo','kevinmperez29@gmail.com','scrypt:32768:8:1$D84jTLIrRvJioGSf$e9c685d847642b42acdf8ef1302f7ebfcdba2790885cd65ca7ace826b7ee1a16438c2a97cbf8e88b667fef5571dac874da11fe5ff0c456cff1211613841580d2','40786154','01'),(16,'CUI','santii','pérez','2026-02-28 11:55:18','activo','santiagoandreperez08@gmail.com','scrypt:32768:8:1$l1avAaor7Xq4tiMN$4fd21d8923022bcf87b9ddf18992976bdba9685e6deb238cd66c72d09ac381968a8dc099eeda89f11425de12741c854c9943ca9392ec637ef4b0c09721fad5a6',NULL,'03'),(17,'CUI','manuel','lopezx','2026-03-01 16:14:50','activo','asasa@gmail.com','scrypt:32768:8:1$cC73iuSqp9d48MV7$f37ec9673eeac84be16e272dacea17294ae69cdb198baacca7f876e42dace60238199096cd14af06d6334bd74fe68161ed290c37470fa0b9f2e155939f625686',NULL,'03'),(18,'CUI','Clinton','Pineda','2026-03-09 12:02:27','activo','clintonpineda@itc.edu.gt','scrypt:32768:8:1$jfAtPwABKaojNjSq$80beadbad3de1ef295bab6c77ff3be235f5eeee855ff6b80f82820e558fe8fe4e45b1761e7833891b3ce2696624df82c79ecc32dbf8461677d976d2cf2fdb4c1',NULL,'03'),(19,'CUI','jesus','fuentes','2026-03-09 12:09:44','activo','fue2025051@itc.edu.gt','scrypt:32768:8:1$ypqTke3hqxOkguM0$18e6547b163543352b8db17315491c297aa3bd9062053ff212a82eeaedbcbb416c23466efbfcb90367a9d839f82158b2d79d03a2319d1ee02a86e49a825910a4',NULL,'02'),(20,'CUI','Cristina','Sente','2026-03-09 16:36:34','activo','cristina@gmail.com','scrypt:32768:8:1$8fgGIXAHs8ZKfu1l$dd86ae6f9a04ea74c4f9039a8fd34276fb31bfd43d2c16e7161eac7496d445ed76affed4521fed90d938e3a11e109af22733b7e91adf990a8ac24ca491944226',NULL,'02'),(21,'CUI','jose','perez','2026-04-13 22:14:36','activo','jioseperez@gmail.com','scrypt:32768:8:1$izlKQ1U3rx4kr5WS$664ddb2ea172bc7f2de86a99705d15961fd969336925c14e867c7410e6daa6d266cc5cdfd04e7175b765bfc0618296e0299b00547691e2a8137473431437d73f',NULL,'03'),(1245789359870,'CUI','jonathan','Cano','2026-07-06 21:13:43','activo','can2025105@gmail.com','scrypt:32768:8:1$xKi27FzkRMSULj26$f62166e46609ea1557ffcde04300249ee1db5acf1164ab0155563b9a8c0894f6f8494f43856039df4f4b269f58082b1953040149441232bd44f139ea65d2e5bc',NULL,'03'),(1555656555666,'CUI','tarawata','molongo','2026-06-23 04:52:59','activo',NULL,'scrypt:32768:8:1$SphPjNPd5SIa9Elr$fdb906ea7bd7a608434b44d03b45ad4ea069f6129997ef50d12f59b8153f0542007a328299dc71f32564733f532e270a836aa000134665e399d1e4149c3872b2',NULL,'03'),(2186198820101,'CUI','Juan','Perez','2026-07-09 16:22:43','activo','juanpe@gmail.com','scrypt:32768:8:1$MFHUfgRLa5R4xd97$c4e78805286f5ba32924cd35d4427529a51f915f694b14c87493b61118f3867f7e6278f108dc283863b01a3f04d16e47ae78d9bd47143648d5f21bd81695096b',NULL,'03'),(2468653421101,'DPI','Kenny','Pérez','2026-05-06 01:23:39','activo','mperezmal@gmail.com','scrypt:32768:8:1$6JYNxqKJf4vyH4fU$7eade7c965a7987c7863e932128ffb3d15c8607d83514d0342962ef141702a0a33205f2da6fab7b1e9cb833fa5ee6dfb66881c119f028974044e933989bc1e5f',NULL,'03'),(4547454784123,'DPI','juanito','probando','2026-04-14 21:55:24','activo','juanito@gmail.com','scrypt:32768:8:1$xRiWNdeUmqaL1lxf$b7a7ed1d6ee6cfd0c0299ee4bde6100750a51a47d5d1c376f9992719293f87bf6e45b54fd8cc483f4c618d9cad762af98750fdc6ab26fa54e214f5cc55bed344',NULL,'03'),(4564547274321,'CUI','Osmarlin','Blanco','2026-05-11 22:41:10','activo','cottot148@gmail.com','scrypt:32768:8:1$uup6Tkfd9abYCj42$f6a5ab6e775253fed9681a7e77b5b470b3d51674390c8cdefa3acaa9a093e518d65ed7b0810b1e8e95ce9ab83159aed8f1738b0f8c6c7ca84bc8507e27960e6d',NULL,'03'),(4574124784512,'DPI','kevin','Mariño','2026-04-27 21:52:45','activo','kevin@gmail.com','scrypt:32768:8:1$ZS4fOkFWTzKZtS7t$3342d2d666324e6bfa10aa25f2312bad854d9c75fa72f624116ee041bcf75f18c2f0da9a6095e6e796c4c3b32256ba3c198092e8dd378b77c98142a2f14149d4',NULL,'03'),(5877878775648,'CUI','martinico','diaznho','2026-04-20 18:18:36','activo','martinico@gmail.com','scrypt:32768:8:1$uqRLcghe2iiL4fkQ$f70a53837ea641a95124e0fdb1be08028fa24d89cd6110725a6a167ac6ff6b9ec7ad418c15523627255872ce4f0a47ea92cce5b8b442e2179873c1e20c1fe218','47679125','03'),(7878457487415,'CUI','Jonathan','Cano','2026-04-20 21:47:31','activo','Jonathankno1158@gmail.com','scrypt:32768:8:1$tnnWyrLs5aQEYaAF$0a0948dd9d5423942b027eceaa45b51b5f675b661b22c51f8f1f1f7bea45ce52f0fec3c43319a61893302a28c09da251d470bed19c1a55a8c035e01d4a3ecd38',NULL,'03');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-27  3:08:16
