-- MySQL dump 10.13  Distrib 8.1.0, for Win64 (x86_64)
--
-- Host: localhost    Database: music
-- ------------------------------------------------------
-- Server version	8.1.0

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
-- Table structure for table `artists`
--

DROP TABLE IF EXISTS `artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artists` (
  `ArtistID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `monthly_listeners` int DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ArtistID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists`
--

LOCK TABLES `artists` WRITE;
/*!40000 ALTER TABLE `artists` DISABLE KEYS */;
INSERT INTO `artists` VALUES (1,'The Marias',9795978,'United States'),(2,'The Beatles',36104369,'United Kingdom'),(3,'PinkPantheress',16230623,'United Kingdom'),(4,'Drake',80779779,'Canada'),(5,'Young Nudy',8073279,'United States'),(6,'Saint Etienne',388026,'United Kingdom'),(7,'Radiohead',26171549,'United Kingdom'),(8,'NewJeans',16608569,'South Korea'),(9,'Mariya Takeuchi',1333189,'Japan'),(10,'Crumb',2307748,'United States'),(11,'Gorillaz',22995125,'United Kingdom'),(12,'Playboi Carti',581556586,'United States'),(13,'Pink Floyd',18534691,'United Kingdom'),(14,'David Bowie',16824282,'United Kingdom');
/*!40000 ALTER TABLE `artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_songs`
--

DROP TABLE IF EXISTS `playlist_songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_songs` (
  `PlaylistID` int NOT NULL,
  `songID` int NOT NULL,
  PRIMARY KEY (`PlaylistID`,`songID`),
  KEY `songID` (`songID`),
  CONSTRAINT `playlist_songs_ibfk_1` FOREIGN KEY (`PlaylistID`) REFERENCES `playlists` (`PlaylistID`) ON DELETE CASCADE,
  CONSTRAINT `playlist_songs_ibfk_2` FOREIGN KEY (`songID`) REFERENCES `songs` (`songID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_songs`
--

LOCK TABLES `playlist_songs` WRITE;
/*!40000 ALTER TABLE `playlist_songs` DISABLE KEYS */;
INSERT INTO `playlist_songs` VALUES (22,1),(22,2),(22,3),(22,4),(22,5),(22,6),(22,7),(22,8),(22,9),(22,10),(22,11),(22,13),(22,14),(22,15),(22,16),(22,17),(22,18),(22,28),(22,29),(22,30);
/*!40000 ALTER TABLE `playlist_songs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlists` (
  `PlaylistID` int NOT NULL AUTO_INCREMENT,
  `owner_UserID` int DEFAULT NULL,
  `playlist_name` varchar(255) NOT NULL,
  PRIMARY KEY (`PlaylistID`),
  KEY `owner_UserID` (`owner_UserID`),
  KEY `idx_playlistID` (`PlaylistID`),
  CONSTRAINT `playlists_ibfk_1` FOREIGN KEY (`owner_UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
INSERT INTO `playlists` VALUES (22,8,'rich');
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `songs`
--

DROP TABLE IF EXISTS `songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `songs` (
  `songID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `song_artistID` int DEFAULT NULL,
  `genre` varchar(255) DEFAULT NULL,
  `decade` int DEFAULT NULL,
  PRIMARY KEY (`songID`),
  KEY `song_artistID` (`song_artistID`),
  CONSTRAINT `songs_ibfk_1` FOREIGN KEY (`song_artistID`) REFERENCES `artists` (`ArtistID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songs`
--

LOCK TABLES `songs` WRITE;
/*!40000 ALTER TABLE `songs` DISABLE KEYS */;
INSERT INTO `songs` VALUES (1,'Hush',1,'R&B',2020),(2,'Nowhere Man',2,'Rock',1960),(3,'Dear Prudence',2,'Rock',1960),(4,'Wood Cabin',6,'Trip-hop',1990),(5,'EA',5,'Rap',2010),(6,'I Must Apologize',3,'Pop',2020),(7,'OMG',8,'Pop',2020),(8,'Super Shy',8,'Pop',2020),(9,'Break It Off',3,'Pop',2020),(10,'Bodysnatchers',7,'Rock',2000),(11,'Karma Police',7,'Rock',1990),(12,'Tomorrow Comes Today',11,'Alternative',2000),(13,'Stylo',11,'Synth Pop',2010),(14,'All I Really Want is You',1,'Bedroom Pop',2020),(15,'Spring',6,'Acid House',1990),(16,'Wants and Needs',4,'Rap',2020),(17,'Take Care',4,'Pop',2010),(18,'At the Traphouse',5,'Rap',2010),(28,'Plastic Love',9,'City Pop',1980),(29,'September',9,'City Pop',1970),(30,'Ice Melt',10,'Psychadelic',2020),(31,'M.R',10,'Psychadelic',2010),(32,'Lean 4 Real',12,'Rap',2010),(33,'New Tank',12,'Rap',2020),(34,'Breathe(In the Air)',13,'Progressive Rock',1970),(35,'Dogs',13,'Progressive Rock',1970),(36,'Modern Love',14,'Pop',1980),(37,'The Man Who Sold the World',14,'Rock',1970);
/*!40000 ALTER TABLE `songs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `password` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (8,'dog','carte341','carte341@purdue.edu');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-26 17:54:07
