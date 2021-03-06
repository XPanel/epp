SET FOREIGN_KEY_CHECKS=0;

CREATE DATABASE IF NOT EXISTS `registry`;

CREATE TABLE IF NOT EXISTS `registry`.`domain_tld` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`tld` varchar(32) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `tld` (`tld`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='domain tld';

CREATE TABLE IF NOT EXISTS `registry`.`domain_price` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`tldid` int(10) unsigned NOT NULL,
	`command` enum('create','renew','transfer') NOT NULL default 'create',
	`m0` decimal(10,2) NOT NULL default '0.00',
	`m12` decimal(10,2) NOT NULL default '0.00',
	`m24` decimal(10,2) NOT NULL default '0.00',
	`m36` decimal(10,2) NOT NULL default '0.00',
	`m48` decimal(10,2) NOT NULL default '0.00',
	`m60` decimal(10,2) NOT NULL default '0.00',
	`m72` decimal(10,2) NOT NULL default '0.00',
	`m84` decimal(10,2) NOT NULL default '0.00',
	`m96` decimal(10,2) NOT NULL default '0.00',
	`m108` decimal(10,2) NOT NULL default '0.00',
	`m120` decimal(10,2) NOT NULL default '0.00',
	PRIMARY KEY  (`id`),
	UNIQUE KEY `unique_record` (`tldid`,`command`),
	CONSTRAINT `domain_price_ibfk_1` FOREIGN KEY (`tldid`) REFERENCES `domain_tld` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='domain price';

CREATE TABLE IF NOT EXISTS `registry`.`domain_restore_price` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`tldid` int(10) unsigned NOT NULL,
	`price` decimal(10,2) NOT NULL default '0.00',
	PRIMARY KEY  (`id`),
	UNIQUE KEY `tldid` (`tldid`),
	CONSTRAINT `domain_restore_price_ibfk_1` FOREIGN KEY (`tldid`) REFERENCES `domain_tld` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='domain restore price';


CREATE TABLE IF NOT EXISTS `registry`.`reserved_domain_names` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`name` varchar(68) NOT NULL,
	`type` enum('reserved','restricted') NOT NULL default 'reserved',
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='reserved domain names';


CREATE TABLE IF NOT EXISTS `registry`.`registrar` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL,
	`clid` varchar(16) NOT NULL,
	`pw` varchar(64) NOT NULL,
	`prefix` char(2) NOT NULL,
	`email` varchar(255) NOT NULL,
	`whois_server` varchar(255) NOT NULL,
	`url` varchar(255) NOT NULL,
	`abuse_email` varchar(255) NOT NULL,
	`abuse_phone` varchar(255) NOT NULL,
	`accountBalance` decimal(8,2) NOT NULL default '0.00',
	`creditLimit` decimal(8,2) NOT NULL default '0.00',
	`creditThreshold` decimal(8,2) NOT NULL default '0.00',
	`thresholdType` enum('fixed','percent') NOT NULL default 'fixed',
	`crdate` datetime NOT NULL,
	`update` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `clid` (`clid`),
	UNIQUE KEY `prefix` (`prefix`),
	UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='registrar';

CREATE TABLE IF NOT EXISTS `registry`.`registrar_whitelist` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`registrar_id` int(10) unsigned NOT NULL,
	`addr` varchar(45) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`registrar_id`,`addr`),
	CONSTRAINT `registrar_whitelist_ibfk_1` FOREIGN KEY (`registrar_id`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='registrar whitelist';

CREATE TABLE IF NOT EXISTS `registry`.`registrar_contact` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`registrar_id` int(10) unsigned NOT NULL,
	`type` enum('owner','admin','billing','tech') NOT NULL default 'admin',
	`title` varchar(255) NOT NULL,
	`first_name` varchar(255) NOT NULL,
	`middle_name` varchar(255) NOT NULL,
	`last_name` varchar(255) NOT NULL,
	`org` varchar(255) default NULL,
	`street1` varchar(255) default NULL,
	`street2` varchar(255) default NULL,
	`street3` varchar(255) default NULL,
	`city` varchar(255) NOT NULL,
	`sp` varchar(255) default NULL,
	`pc` varchar(16) default NULL,
	`cc` char(2) NOT NULL,
	`voice` varchar(17) default NULL,
	`fax` varchar(17) default NULL,
	`email` varchar(255) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`registrar_id`,`type`),
	CONSTRAINT `registrar_contact_ibfk_1` FOREIGN KEY (`registrar_id`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='registrar data';

CREATE TABLE IF NOT EXISTS `registry`.`poll` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`registrar_id` int(10) unsigned NOT NULL,
	`qdate` datetime NOT NULL,
	`msg` text default NULL,
	`msg_type` enum('lowBalance','domainTransfer','contactTransfer') default NULL,
	`obj_name_or_id` varchar(68),
	`obj_trStatus` enum('clientApproved','clientCancelled','clientRejected','pending','serverApproved','serverCancelled') default NULL,
	`obj_reID` varchar(255),
	`obj_reDate` datetime,
	`obj_acID` varchar(255),
	`obj_acDate` datetime,
	`obj_exDate` datetime default NULL,
	`registrarName` varchar(255),
	`creditLimit` decimal(8,2) default '0.00',
	`creditThreshold` decimal(8,2) default '0.00',
	`creditThresholdType` enum('FIXED','PERCENT'),
	`availableCredit` decimal(8,2) default '0.00',
	PRIMARY KEY (`id`),
	CONSTRAINT `poll_ibfk_1` FOREIGN KEY (`registrar_id`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='poll';

CREATE TABLE IF NOT EXISTS `registry`.`payment_history` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`registrar_id` int(10) unsigned NOT NULL,
	`date` datetime NOT NULL,
	`description` text NOT NULL,
	`amount` decimal(8,2) NOT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `payment_history_ibfk_1` FOREIGN KEY (`registrar_id`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='payment history';

CREATE TABLE IF NOT EXISTS `registry`.`statement` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`registrar_id` int(10) unsigned NOT NULL,
	`date` datetime NOT NULL,
	`command` enum('create','renew','transfer','restore','autoRenew') NOT NULL default 'create',
	`domain_name` varchar(68) NOT NULL,
	`length_in_months` tinyint(3) unsigned NOT NULL,
	`from` datetime NOT NULL,
	`to` datetime NOT NULL,
	`amount` decimal(8,2) NOT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `statement_ibfk_1` FOREIGN KEY (`registrar_id`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='financial statement';









CREATE TABLE IF NOT EXISTS `registry`.`contact` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`identifier` varchar(255) NOT NULL,
	`voice` varchar(17) default NULL,
	`voice_x` int(10) default NULL,
	`fax` varchar(17) default NULL,
	`fax_x` int(10) default NULL,
	`email` varchar(255) NOT NULL,
	`nin` varchar(255) default NULL,
	`nin_type` enum('personal','business') default NULL,
	`clid` int(10) unsigned NOT NULL,
	`crid` int(10) unsigned NOT NULL,
	`crdate` datetime NOT NULL,
	`upid` int(10) unsigned default NULL,
	`update` datetime default NULL,
	`trdate` datetime default NULL,
	`trstatus` enum('clientApproved','clientCancelled','clientRejected','pending','serverApproved','serverCancelled') default NULL,
	`reid` int(10) unsigned default NULL,
	`redate` datetime default NULL,
	`acid` int(10) unsigned default NULL,
	`acdate` datetime default NULL,
	`disclose_voice` enum('0','1') NOT NULL default '1',
	`disclose_fax` enum('0','1') NOT NULL default '1',
	`disclose_email` enum('0','1') NOT NULL default '1',
	PRIMARY KEY (`id`),
	UNIQUE KEY `identifier` (`identifier`),
	CONSTRAINT `contact_ibfk_1` FOREIGN KEY (`clid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `contact_ibfk_2` FOREIGN KEY (`crid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `contact_ibfk_3` FOREIGN KEY (`upid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contact';

CREATE TABLE IF NOT EXISTS `registry`.`contact_postalInfo` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`contact_id` int(10) unsigned NOT NULL,
	`type` enum('int','loc') NOT NULL default 'int',
	`name` varchar(255) NOT NULL,
	`org` varchar(255) default NULL,
	`street1` varchar(255) default NULL,
	`street2` varchar(255) default NULL,
	`street3` varchar(255) default NULL,
	`city` varchar(255) NOT NULL,
	`sp` varchar(255) default NULL,
	`pc` varchar(16) default NULL,
	`cc` char(2) NOT NULL,
	`disclose_name_int` enum('0','1') NOT NULL default '1',
	`disclose_name_loc` enum('0','1') NOT NULL default '1',
	`disclose_org_int` enum('0','1') NOT NULL default '1',
	`disclose_org_loc` enum('0','1') NOT NULL default '1',
	`disclose_addr_int` enum('0','1') NOT NULL default '1',
	`disclose_addr_loc` enum('0','1') NOT NULL default '1',
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`contact_id`,`type`),
	CONSTRAINT `contact_postalInfo_ibfk_1` FOREIGN KEY (`contact_id`) REFERENCES `contact` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contact:postalInfo';

CREATE TABLE IF NOT EXISTS `registry`.`contact_authInfo` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`contact_id` int(10) unsigned NOT NULL,
	`authtype` enum('pw','ext') NOT NULL default 'pw',
	`authinfo` varchar(64) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `contact_id` (`contact_id`),
	CONSTRAINT `contact_authInfo_ibfk_1` FOREIGN KEY (`contact_id`) REFERENCES `contact` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contact:authInfo';

CREATE TABLE IF NOT EXISTS `registry`.`contact_status` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`contact_id` int(10) unsigned NOT NULL,
	`status` enum('clientDeleteProhibited','clientTransferProhibited','clientUpdateProhibited','linked','ok','pendingCreate','pendingDelete','pendingTransfer','pendingUpdate','serverDeleteProhibited','serverTransferProhibited','serverUpdateProhibited') NOT NULL default 'ok',
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`contact_id`,`status`),
	CONSTRAINT `contact_status_ibfk_1` FOREIGN KEY (`contact_id`) REFERENCES `contact` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contact:status';










 CREATE TABLE IF NOT EXISTS `registry`.`domain` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`name` varchar(68) NOT NULL,
	`tldid` int(10) unsigned NOT NULL,
	`registrant` int(10) unsigned default NULL,
	`crdate` datetime NOT NULL,
	`exdate` datetime NOT NULL,
	`update` datetime default NULL,
	`clid` int(10) unsigned NOT NULL,
	`crid` int(10) unsigned NOT NULL,
	`upid` int(10) unsigned default NULL,
	`trdate` datetime default NULL,
	`trstatus` enum('clientApproved','clientCancelled','clientRejected','pending','serverApproved','serverCancelled') default NULL,
	`reid` int(10) unsigned default NULL,
	`redate` datetime default NULL,
	`acid` int(10) unsigned default NULL,
	`acdate` datetime default NULL,
	`transfer_exdate` datetime default NULL,
	`idnlang` varchar(16) default NULL,
	`delTime` datetime default NULL,
	`resTime` datetime default NULL,
	`rgpstatus` enum('addPeriod','autoRenewPeriod','renewPeriod','transferPeriod','pendingDelete','pendingRestore','redemptionPeriod') default NULL,
	`rgppostData` text default NULL,
	`rgpdelTime` datetime default NULL,
	`rgpresTime` datetime default NULL,
	`rgpresReason` text default NULL,
	`rgpstatement1` text default NULL,
	`rgpstatement2` text default NULL,
	`rgpother` text default NULL,
	`addPeriod` tinyint(3) unsigned default NULL,
	`autoRenewPeriod` tinyint(3) unsigned default NULL,
	`renewPeriod` tinyint(3) unsigned default NULL,
	`transferPeriod` tinyint(3) unsigned default NULL,
	`renewedDate` datetime default NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`),
	CONSTRAINT `domain_ibfk_1` FOREIGN KEY (`clid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_ibfk_2` FOREIGN KEY (`crid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_ibfk_3` FOREIGN KEY (`upid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_ibfk_4` FOREIGN KEY (`registrant`) REFERENCES `contact` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_ibfk_5` FOREIGN KEY (`reid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_ibfk_6` FOREIGN KEY (`acid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_ibfk_7` FOREIGN KEY (`tldid`) REFERENCES `domain_tld` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='domain';

CREATE TABLE IF NOT EXISTS `registry`.`domain_contact_map` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`domain_id` int(10) unsigned NOT NULL,
	`contact_id` int(10) unsigned NOT NULL,
	`type` enum('admin','billing','tech') NOT NULL default 'admin',
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`domain_id`,`contact_id`,`type`),
	CONSTRAINT `domain_contact_map_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_contact_map_ibfk_2` FOREIGN KEY (`contact_id`) REFERENCES `contact` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contact map';

CREATE TABLE IF NOT EXISTS `registry`.`domain_authInfo` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`domain_id` int(10) unsigned NOT NULL,
	`authtype` enum('pw','ext') NOT NULL default 'pw',
	`authinfo` varchar(64) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `domain_id` (`domain_id`),
	CONSTRAINT `domain_authInfo_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='domain:authInfo';

CREATE TABLE IF NOT EXISTS `registry`.`domain_status` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`domain_id` int(10) unsigned NOT NULL,
	`status` enum('clientDeleteProhibited','clientHold','clientRenewProhibited','clientTransferProhibited','clientUpdateProhibited','inactive','ok','pendingCreate','pendingDelete','pendingRenew','pendingTransfer','pendingUpdate','serverDeleteProhibited','serverHold','serverRenewProhibited','serverTransferProhibited','serverUpdateProhibited') NOT NULL default 'ok',
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`domain_id`,`status`),
	CONSTRAINT `domain_status_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='domain:status';

CREATE TABLE IF NOT EXISTS `registry`.`secdns` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`domain_id` int(10) unsigned NOT NULL,
	`maxsiglife` int(10) unsigned default '604800',
	`interface` enum('dsData','keyData') NOT NULL default 'dsData',
	`keytag` smallint(5) unsigned NOT NULL,
	`alg` tinyint(3) unsigned NOT NULL default '5',
	`digesttype` tinyint(3) unsigned NOT NULL default '1',
	`digest` varchar(64) NOT NULL,
	`flags` smallint(5) unsigned default NULL,
	`protocol` smallint(5) unsigned default NULL,
	`keydata_alg` tinyint(3) unsigned default NULL,
	`pubkey` varchar(255) default NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`domain_id`,`digest`),
	CONSTRAINT `secdns_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='secDNS';










CREATE TABLE IF NOT EXISTS `registry`.`host` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`name` varchar(255) NOT NULL,
	`domain_id` int(10) unsigned default NULL,
	`clid` int(10) unsigned NOT NULL,
	`crid` int(10) unsigned NOT NULL,
	`crdate` datetime NOT NULL,
	`upid` int(10) unsigned default NULL,
	`update` datetime default NULL,
	`trdate` datetime default NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`),
	CONSTRAINT `host_ibfk_1` FOREIGN KEY (`clid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `host_ibfk_2` FOREIGN KEY (`crid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `host_ibfk_3` FOREIGN KEY (`upid`) REFERENCES `registrar` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `host_ibfk_4` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='host';

CREATE TABLE IF NOT EXISTS `registry`.`domain_host_map` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`domain_id` int(10) unsigned NOT NULL,
	`host_id` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `domain_host_map_id` (`domain_id`,`host_id`),
	CONSTRAINT `domain_host_map_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`) ON DELETE RESTRICT,
	CONSTRAINT `domain_host_map_ibfk_2` FOREIGN KEY (`host_id`) REFERENCES `host` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contact map';

CREATE TABLE IF NOT EXISTS `registry`.`host_addr` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`host_id` int(10) unsigned NOT NULL,
	`addr` varchar(45) NOT NULL,
	`ip` enum('v4','v6') NOT NULL default 'v4',
	PRIMARY KEY (`id`),
	UNIQUE KEY `unique` (`host_id`,`addr`,`ip`),
	CONSTRAINT `host_addr_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `host` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='host_addr';

CREATE TABLE IF NOT EXISTS `registry`.`host_status` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`host_id` int(10) unsigned NOT NULL,
	`status` enum('clientDeleteProhibited','clientUpdateProhibited','linked','ok','pendingCreate','pendingDelete','pendingTransfer','pendingUpdate','serverDeleteProhibited','serverUpdateProhibited') NOT NULL default 'ok',
	PRIMARY KEY (`id`),
	UNIQUE KEY `uniquekey` (`host_id`,`status`),
	CONSTRAINT `host_status_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `host` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='host:status';


 CREATE TABLE IF NOT EXISTS `registry`.`domain_auto_approve_transfer` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`name` varchar(68) NOT NULL,
	`registrant` int(10) unsigned default NULL,
	`crdate` datetime NOT NULL,
	`exdate` datetime NOT NULL,
	`update` datetime default NULL,
	`clid` int(10) unsigned NOT NULL,
	`crid` int(10) unsigned NOT NULL,
	`upid` int(10) unsigned default NULL,
	`trdate` datetime default NULL,
	`trstatus` enum('clientApproved','clientCancelled','clientRejected','pending','serverApproved','serverCancelled') default NULL,
	`reid` int(10) unsigned default NULL,
	`redate` datetime default NULL,
	`acid` int(10) unsigned default NULL,
	`acdate` datetime default NULL,
	`transfer_exdate` datetime default NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='domain_auto_approve_transfer';


CREATE TABLE IF NOT EXISTS `registry`.`contact_auto_approve_transfer` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`identifier` varchar(255) NOT NULL,
	`voice` varchar(17) default NULL,
	`voice_x` int(10) default NULL,
	`fax` varchar(17) default NULL,
	`fax_x` int(10) default NULL,
	`email` varchar(255) NOT NULL,
	`nin` varchar(255) default NULL,
	`nin_type` enum('personal','business') default NULL,
	`clid` int(10) unsigned NOT NULL,
	`crid` int(10) unsigned NOT NULL,
	`crdate` datetime NOT NULL,
	`upid` int(10) unsigned default NULL,
	`update` datetime default NULL,
	`trdate` datetime default NULL,
	`trstatus` enum('clientApproved','clientCancelled','clientRejected','pending','serverApproved','serverCancelled') default NULL,
	`reid` int(10) unsigned default NULL,
	`redate` datetime default NULL,
	`acid` int(10) unsigned default NULL,
	`acdate` datetime default NULL,
	`disclose_voice` enum('0','1') NOT NULL default '1',
	`disclose_fax` enum('0','1') NOT NULL default '1',
	`disclose_email` enum('0','1') NOT NULL default '1',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='contact_auto_approve_transfer';


CREATE TABLE IF NOT EXISTS `registry`.`statistics` (
	`id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`date` date NOT NULL,
	`total_domains` int(10) unsigned NOT NULL DEFAULT '0',
	`created_domains` int(10) unsigned NOT NULL DEFAULT '0',
	`renewed_domains` int(10) unsigned NOT NULL DEFAULT '0',
	`transfered_domains` int(10) unsigned NOT NULL DEFAULT '0',
	`deleted_domains` int(10) unsigned NOT NULL DEFAULT '0',
	`restored_domains` int(10) unsigned NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Statistics';










INSERT INTO `registry`.`domain_tld` VALUES('1','.COM.XX');
INSERT INTO `registry`.`domain_tld` VALUES('2','.ORG.XX');
INSERT INTO `registry`.`domain_tld` VALUES('3','.INFO.XX');
INSERT INTO `registry`.`domain_tld` VALUES('4','.PRO.XX');
INSERT INTO `registry`.`domain_tld` VALUES('5','.XX');



INSERT INTO `registry`.`domain_price` VALUES('1','1','create','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('2','1','renew','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('3','1','transfer','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');

INSERT INTO `registry`.`domain_price` VALUES('4','2','create','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('5','2','renew','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('6','2','transfer','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');

INSERT INTO `registry`.`domain_price` VALUES('7','3','create','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('8','3','renew','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('9','3','transfer','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');

INSERT INTO `registry`.`domain_price` VALUES('10','4','create','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('11','4','renew','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('12','4','transfer','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');

INSERT INTO `registry`.`domain_price` VALUES('13','5','create','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('14','5','renew','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');
INSERT INTO `registry`.`domain_price` VALUES('15','5','transfer','0.00','5.00','10.00','15.00','20.00','25.00','30.00','35.00','40.00','45.00','50.00');


INSERT INTO `registry`.`domain_restore_price` VALUES('1','1','50.00');
INSERT INTO `registry`.`domain_restore_price` VALUES('2','2','50.00');
INSERT INTO `registry`.`domain_restore_price` VALUES('3','3','50.00');
INSERT INTO `registry`.`domain_restore_price` VALUES('4','4','50.00');
INSERT INTO `registry`.`domain_restore_price` VALUES('5','5','50.00');


INSERT INTO `registry`.`registrar` (`name`,`clid`,`pw`,`prefix`,`email`,`whois_server`,`url`,`abuse_email`,`abuse_phone`,`accountBalance`,`creditLimit`,`creditThreshold`,`thresholdType`,`crdate`,`update`) VALUES('XPanel Group','xpanel','{SHA}MyVYFDDrSjD546LIF11cMPu93ss=','XP','info@xpanel.com','whois.xpanel.com','http://www.xpanel.com/','abuse@xpanel.com','+321.123123123','100000.00','100000.00','500.00','fixed',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
INSERT INTO `registry`.`registrar` (`name`,`clid`,`pw`,`prefix`,`email`,`whois_server`,`url`,`abuse_email`,`abuse_phone`,`accountBalance`,`creditLimit`,`creditThreshold`,`thresholdType`,`crdate`,`update`) VALUES('Registrar 002','testregistrar1','{SHA}ELxnUq/+JQS9a7pCUIZQpUrA3bY=','AA','info@testregistrar1.com','whois.xpanel.com','http://www.xpanel.com/','abuse@xpanel.com','+321.123123123','100000.00','100000.00','500.00','fixed',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
INSERT INTO `registry`.`registrar` (`name`,`clid`,`pw`,`prefix`,`email`,`whois_server`,`url`,`abuse_email`,`abuse_phone`,`accountBalance`,`creditLimit`,`creditThreshold`,`thresholdType`,`crdate`,`update`) VALUES('Registrar 003','testregistrar2','{SHA}jkkAfdvdLH5vbkCeQLGJy77LEGM=','BB','info@testregistrar2.com','whois.xpanel.com','http://www.xpanel.com/','abuse@xpanel.com','+321.123123123','100000.00','100000.00','500.00','fixed',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);


CREATE USER 'registry'@'localhost' IDENTIFIED BY 'EPPRegistry';
CREATE USER 'registry-select'@'localhost' IDENTIFIED BY 'EPPRegistrySELECT';
CREATE USER 'registry-update'@'localhost' IDENTIFIED BY 'EPPRegistryUPDATE';

GRANT ALL ON `registry`.* TO 'registry'@'localhost';
GRANT SELECT ON `registry`.* TO 'registry-select'@'localhost';
GRANT UPDATE ON `registry`.`payment_history` TO 'registry-update'@'localhost';


CREATE DATABASE IF NOT EXISTS `registryTransaction`;

CREATE TABLE IF NOT EXISTS `registryTransaction`.`transaction_identifier` (
	`id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	`registrar_id` int(10) unsigned NOT NULL,
	`clTRID` varchar(64),
	`clTRIDframe` text,
	`cldate` datetime,
	`clmicrosecond` int(6),
	`cmd` enum('login','logout','check','info','poll','transfer','create','delete','renew','update') default NULL,
	`obj_type` enum('domain','host','contact') default NULL,
	`obj_id` text default NULL,
	`code` smallint(4) unsigned default NULL,
	`msg` varchar(255) default NULL,
	`svTRID` varchar(64),
	`svTRIDframe` text,
	`svdate` datetime,
	`svmicrosecond` int(6),
	PRIMARY KEY (`id`),
	UNIQUE KEY `clTRID` (`clTRID`),
	UNIQUE KEY `svTRID` (`svTRID`),
	CONSTRAINT `transaction_identifier_ibfk_1` FOREIGN KEY (`registrar_id`) REFERENCES `registry`.`registrar` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='transaction identifier';

GRANT ALL ON `registryTransaction`.* TO 'registry'@'localhost';
GRANT SELECT ON `registryTransaction`.* TO 'registry-select'@'localhost';

FLUSH PRIVILEGES;