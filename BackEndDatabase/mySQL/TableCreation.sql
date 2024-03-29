CREATE TABLE `Administers` (
  `administers_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `municipality_id` int(11) NOT NULL,
  PRIMARY KEY (`administers_id`),
  KEY `fk_admin_id1_idx` (`admin_id`),
  KEY `fk_municipality_id6_idx` (`municipality_id`),
  CONSTRAINT `fk_admin_id1` FOREIGN KEY (`admin_id`) REFERENCES `Administrator` (`admin_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_municipality_id6` FOREIGN KEY (`municipality_id`) REFERENCES `Municipality` (`municipality_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='bridging table connecting administrators to the municipalities they adminster';


CREATE TABLE `Administrator` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `UID` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `middle_name` varchar(45) NOT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='manages emerge database';


CREATE TABLE `EmergencyResponseAgency` (
  `agency_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_type` enum('Fire','Police','Hospital') NOT NULL,
  `name` varchar(45) NOT NULL,
  `municipality_id` int(11) NOT NULL,
  PRIMARY KEY (`agency_id`),
  KEY `fk_municipality_id1_idx` (`municipality_id`),
  CONSTRAINT `fk_municipality_id1` FOREIGN KEY (`municipality_id`) REFERENCES `Municipality` (`municipality_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='responds to reports, serves municipality';

CREATE TABLE `Municipality` (
  `municipality_id` int(11) NOT NULL AUTO_INCREMENT,
  `jurisdiction_radius` decimal(5,2) unsigned NOT NULL,
  `name` varchar(60) NOT NULL,
  `state` char(2) NOT NULL,
  `UID` varchar(45) NOT NULL,
  PRIMARY KEY (`municipality_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Manages/dispatches reports to responding agencies';


CREATE TABLE `Report` (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `required_responders` enum('F','P','H','FP','FH','PH','FPH') DEFAULT NULL,
  `status` enum('New','Dispatched','Closed') DEFAULT NULL,
  `urgency` enum('High','Medium','Low','False report') DEFAULT NULL,
  `GPS` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `phone` char(15) DEFAULT NULL,
  `photo` blob,
  `message` varchar(256) DEFAULT NULL,
  `municipality_id` int(11) NOT NULL,
  PRIMARY KEY (`report_id`),
  KEY `fk_municipality_id5_idx` (`municipality_id`),
  CONSTRAINT `fk_municipality_id5` FOREIGN KEY (`municipality_id`) REFERENCES `Municipality` (`municipality_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Crime/occurrence report generated by users';


CREATE TABLE `Responds` (
  `response_id` int(11) NOT NULL AUTO_INCREMENT,
  `agency_id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  PRIMARY KEY (`response_id`),
  KEY `fk_agency_id1_idx` (`agency_id`),
  KEY `fk_report_id1_idx` (`report_id`),
  CONSTRAINT `fk_agency_id1` FOREIGN KEY (`agency_id`) REFERENCES `EmergencyResponseAgency` (`agency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_report_id1` FOREIGN KEY (`report_id`) REFERENCES `Report` (`report_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='bridging table connecting responding agencies to reports';
