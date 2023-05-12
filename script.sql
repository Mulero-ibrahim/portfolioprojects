-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema VidlyRentals
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema VidlyRentals
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `VidlyRentals` DEFAULT CHARACTER SET utf8 ;
USE `VidlyRentals` ;

-- -----------------------------------------------------
-- Table `VidlyRentals`.`Role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VidlyRentals`.`Role` (
  `Description` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Description`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VidlyRentals`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VidlyRentals`.`User` (
  `Role_Description` VARCHAR(50) NOT NULL,
  `Username` VARCHAR(50) NOT NULL,
  `Password` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Role_Description`),
  CONSTRAINT `fk_User_Role1`
    FOREIGN KEY (`Role_Description`)
    REFERENCES `VidlyRentals`.`Role` (`Description`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VidlyRentals`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VidlyRentals`.`Customer` (
  `Customer_id` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VidlyRentals`.`Movies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VidlyRentals`.`Movies` (
  `Barcode` VARCHAR(50) NOT NULL,
  `DailyRentalRate` FLOAT(9,2) NOT NULL,
  `NumberInStock` INT NOT NULL,
  PRIMARY KEY (`Barcode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VidlyRentals`.`coupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VidlyRentals`.`coupon` (
  `C_Code` VARCHAR(50) NOT NULL,
  `Description` VARCHAR(50) NOT NULL,
  `Discount` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`C_Code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VidlyRentals`.`Rental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VidlyRentals`.`Rental` (
  `Customer_id` INT NOT NULL,
  `Barcode` VARCHAR(50) NOT NULL,
  `C_code` VARCHAR(50) NOT NULL,
  `RentalDate` DATE NOT NULL,
  `ReturnDate` DATE NOT NULL,
  PRIMARY KEY (`Customer_id`, `Barcode`, `C_code`),
  INDEX `fk_Rental_Movies1_idx` (`Barcode` ASC) VISIBLE,
  INDEX `fk_Rental_coupon1_idx` (`C_code` ASC) VISIBLE,
  CONSTRAINT `fk_Rental_Customer`
    FOREIGN KEY (`Customer_id`)
    REFERENCES `VidlyRentals`.`Customer` (`Customer_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Rental_Movies1`
    FOREIGN KEY (`Barcode`)
    REFERENCES `VidlyRentals`.`Movies` (`Barcode`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Rental_coupon1`
    FOREIGN KEY (`C_code`)
    REFERENCES `VidlyRentals`.`coupon` (`C_Code`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
