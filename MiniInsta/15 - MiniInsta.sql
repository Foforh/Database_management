-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema MiniInsta
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema MiniInsta
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `MiniInsta` DEFAULT CHARACTER SET utf8 ;
USE `MiniInsta` ;

-- -----------------------------------------------------
-- Table `MiniInsta`.`Gender`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`Gender` (
  `ID` INT NOT NULL,
  `Name` VARCHAR(50) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniInsta`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`User` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(100) NOT NULL,
  `Name` VARCHAR(250) NOT NULL,
  `Website` VARCHAR(250) NULL,
  `GenderID` INT NOT NULL DEFAULT 1,
  `Bio` MEDIUMTEXT NOT NULL,
  `Email` VARCHAR(250) NULL,
  `CreationTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `Password` VARCHAR(250) NULL,
  `ProfileImageUrl` VARCHAR(250) NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_User_GenderID`
    FOREIGN KEY (`GenderID`)
    REFERENCES `MiniInsta`.`Gender` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_User_GenderID_idx` ON `MiniInsta`.`User` (`GenderID` ASC);

CREATE UNIQUE INDEX `Username_UNIQUE` ON `MiniInsta`.`User` (`Username` ASC);


-- -----------------------------------------------------
-- Table `MiniInsta`.`Post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`Post` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Location` GEOMETRY NULL,
  `LocationName` VARCHAR(250) NULL,
  `CreationTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
  `UserID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_Post_User`
    FOREIGN KEY (`UserID`)
    REFERENCES `MiniInsta`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_Post_User_idx` ON `MiniInsta`.`Post` (`UserID` ASC);


-- -----------------------------------------------------
-- Table `MiniInsta`.`Following`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`Following` (
  `FollowerUserID` INT NOT NULL,
  `FolloweeUserID` INT NOT NULL,
  `CreationTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FolloweeUserID`, `FollowerUserID`),
  CONSTRAINT `FK_Following_FollowerUser`
    FOREIGN KEY (`FollowerUserID`)
    REFERENCES `MiniInsta`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Following_FolloweeUser`
    FOREIGN KEY (`FolloweeUserID`)
    REFERENCES `MiniInsta`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_Following_FolloweeUser_idx` ON `MiniInsta`.`Following` (`FolloweeUserID` ASC);


-- -----------------------------------------------------
-- Table `MiniInsta`.`MediaType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`MediaType` (
  `ID` INT NOT NULL,
  `Name` VARCHAR(50) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniInsta`.`PostMedia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`PostMedia` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `PostID` INT NOT NULL,
  `MediaFileUrl` VARCHAR(250) NULL,
  `MediaTypeID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_PostMedia_MediaType`
    FOREIGN KEY (`MediaTypeID`)
    REFERENCES `MiniInsta`.`MediaType` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PostMedia_Post`
    FOREIGN KEY (`PostID`)
    REFERENCES `MiniInsta`.`Post` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_PostMedia_MediaType_idx` ON `MiniInsta`.`PostMedia` (`MediaTypeID` ASC);

CREATE INDEX `FK_PostMedia_Post_idx` ON `MiniInsta`.`PostMedia` (`PostID` ASC);


-- -----------------------------------------------------
-- Table `MiniInsta`.`Like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`Liking` (
  `PostID` INT NOT NULL,
  `UserID` INT NOT NULL,
  `CreationTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PostID`, `UserID`),
  CONSTRAINT `FK_Liking_Post`
    FOREIGN KEY (`PostID`)
    REFERENCES `MiniInsta`.`Post` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Liking_User`
    FOREIGN KEY (`UserID`)
    REFERENCES `MiniInsta`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_Liking_User_idx` ON `MiniInsta`.`Liking` (`UserID` ASC);


-- -----------------------------------------------------
-- Table `MiniInsta`.`Comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniInsta`.`Comment` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `PostID` INT NULL,
  `UserID` INT NULL,
  `Comment` MEDIUMTEXT NULL,
  `CreationTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  CONSTRAINT `FK_Comment_Post`
    FOREIGN KEY (`PostID`)
    REFERENCES `MiniInsta`.`Post` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Comment_User`
    FOREIGN KEY (`UserID`)
    REFERENCES `MiniInsta`.`User` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_Comment_Post_idx` ON `MiniInsta`.`Comment` (`PostID` ASC);

CREATE INDEX `FK_Comment_User_idx` ON `MiniInsta`.`Comment` (`UserID` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
