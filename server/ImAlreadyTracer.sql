-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ImAlreadyTracer
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ImAlreadyTracer
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ImAlreadyTracer` DEFAULT CHARACTER SET utf8 ;
USE `ImAlreadyTracer` ;

-- -----------------------------------------------------
-- Table `ImAlreadyTracer`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ImAlreadyTracer`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `login_token` VARCHAR(45) NULL,
  `device_token` VARCHAR(255) NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ImAlreadyTracer`.`location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ImAlreadyTracer`.`location` (
  `location_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `latitude` DOUBLE NULL,
  `longtitude` DOUBLE NULL,
  `time` DATETIME NULL,
  `infected` TINYINT NULL,
  PRIMARY KEY (`location_id`, `user_id`),
  INDEX `fk_location_user_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_location_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `ImAlreadyTracer`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
