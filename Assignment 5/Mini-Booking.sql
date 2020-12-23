-- MySQL Script generated by MySQL Workbench
-- Sat Dec 12 14:32:07 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema MiniBooking
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema MiniBooking
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `MiniBooking` DEFAULT CHARACTER SET utf8 ;
USE `MiniBooking` ;

-- -----------------------------------------------------
-- Table `MiniBooking`.`USER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`USER` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(50) NOT NULL,
  `Name` VARCHAR(250) NOT NULL,
  `EmailID` VARCHAR(100) NOT NULL,
  `Password` VARCHAR(50) NOT NULL,
  `PhoneNumber` VARCHAR(20) NOT NULL,
  `Gender` ENUM('MALE', 'FEMALE') NULL,
  `AccountStatus` ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`UserID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`CUSTOMER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`CUSTOMER` (
  `CustomerID` INT NOT NULL,
  `PaymentType` VARCHAR(200) NOT NULL,
  `CardNumber` VARCHAR(20) NOT NULL,
  `NameOnCard` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`CustomerID`),
  CONSTRAINT `fk_CUSTOMER_PERSON1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `MiniBooking`.`USER` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`HOST`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`HOST` (
  `HostID` INT NOT NULL,
  `BankName` VARCHAR(100) NOT NULL,
  `AccountTYpe` ENUM('CHECKING', 'SAVINGS') NOT NULL,
  `AccountNumber` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`HostID`),
  CONSTRAINT `fk_HOST_PERSON1`
    FOREIGN KEY (`HostID`)
    REFERENCES `MiniBooking`.`USER` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`LOCATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`LOCATION` (
  `LocationID` INT NOT NULL AUTO_INCREMENT,
  `Country` VARCHAR(100) NOT NULL,
  `State` VARCHAR(100) NULL,
  `City` VARCHAR(100) NULL,
  `Zipcode` VARCHAR(250) NULL,
  PRIMARY KEY (`LocationID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`HOUSE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`HOUSE` (
  `HouseID` INT NOT NULL AUTO_INCREMENT,
  `StreetNumber` VARCHAR(10) NOT NULL,
  `StreetName` VARCHAR(100) NOT NULL,
  `AptNumber` VARCHAR(10) NOT NULL,
  `Availability` ENUM('AVAILABLE', 'BOOKED') NOT NULL,
  `CostPerNight` DOUBLE NOT NULL,
  `LocationID` INT NOT NULL,
  `HostID` INT NOT NULL,
  PRIMARY KEY (`HouseID`),
  INDEX `fk_HOUSE_LOCATION1_idx` (`LocationID` ASC) VISIBLE,
  INDEX `fk_HOUSE_HOST1_idx` (`HostID` ASC) VISIBLE,
  CONSTRAINT `fk_HOUSE_LOCATION1`
    FOREIGN KEY (`LocationID`)
    REFERENCES `MiniBooking`.`LOCATION` (`LocationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HOUSE_HOST1`
    FOREIGN KEY (`HostID`)
    REFERENCES `MiniBooking`.`HOST` (`HostID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`BOOKING`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`BOOKING` (
  `BookingID` INT NOT NULL,
  `BookingStartDate` DATE NOT NULL,
  `BookingEndDate` DATE NOT NULL,
  `BookingStatus` ENUM('OPEN', 'CANCELLED') NOT NULL,
  `HouseID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  `FinalCost` DOUBLE NULL,
  `TimeStamp` DATETIME NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_BOOKING_HOUSE1_idx` (`HouseID` ASC) VISIBLE,
  INDEX `fk_BOOKING_CUSTOMER1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_BOOKING_HOUSE1`
    FOREIGN KEY (`HouseID`)
    REFERENCES `MiniBooking`.`HOUSE` (`HouseID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT `fk_BOOKING_CUSTOMER1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `MiniBooking`.`CUSTOMER` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`RATING`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`RATING` (
  `RatingID` INT NOT NULL AUTO_INCREMENT,
  `CustomerRating` VARCHAR(2) NOT NULL,
  `CustomerComments` MEDIUMTEXT NOT NULL,
  `HostRating` VARCHAR(2) NOT NULL,
  `HostComments` MEDIUMTEXT NOT NULL,
  `CustomerID` INT NOT NULL,
  `HostID` INT NOT NULL,
  `BookingID` INT NOT NULL,
  PRIMARY KEY (`RatingID`),
  INDEX `fk_RATING_CUSTOMER1_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_RATING_HOST1_idx` (`HostID` ASC) VISIBLE,
  INDEX `fk_RATING_BOOKING1_idx` (`BookingID` ASC) VISIBLE,
  CONSTRAINT `fk_RATING_CUSTOMER1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `MiniBooking`.`CUSTOMER` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RATING_HOST1`
    FOREIGN KEY (`HostID`)
    REFERENCES `MiniBooking`.`HOST` (`HostID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RATING_BOOKING1`
    FOREIGN KEY (`BookingID`)
    REFERENCES `MiniBooking`.`BOOKING` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`REVIEW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`REVIEW` (
  `ReviewID` INT NOT NULL AUTO_INCREMENT,
  `ReviewComments` MEDIUMTEXT NOT NULL,
  `ReviewDate` DATETIME NULL,
  `CustomerID` INT NOT NULL,
  `HouseID` INT NOT NULL,
  PRIMARY KEY (`ReviewID`),
  INDEX `fk_REVIEW_CUSTOMER1_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_REVIEW_HOUSE1_idx` (`HouseID` ASC) VISIBLE,
  CONSTRAINT `fk_REVIEW_CUSTOMER1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `MiniBooking`.`CUSTOMER` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REVIEW_HOUSE1`
    FOREIGN KEY (`HouseID`)
    REFERENCES `MiniBooking`.`HOUSE` (`HouseID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `MiniBooking`.`FEEDBACK`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `MiniBooking`.`FEEDBACK` (
  `FeedbackID` INT NOT NULL AUTO_INCREMENT,
  `Description` MEDIUMTEXT NOT NULL,
  `FeedbackDate` DATETIME NOT NULL,
  `UserID` INT NOT NULL,
  PRIMARY KEY (`FeedbackID`),
  INDEX `fk_FEEDBACK_PERSON1_idx` (`UserID` ASC) VISIBLE,
  CONSTRAINT `fk_FEEDBACK_PERSON1`
    FOREIGN KEY (`UserID`)
    REFERENCES `MiniBooking`.`USER` (`UserID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
