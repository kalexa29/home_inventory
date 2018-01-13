drop schema home_inventory;
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema home_inventory
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema home_inventory
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `home_inventory` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `home_inventory` ;

-- -----------------------------------------------------
-- Table `home_inventory`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_inventory`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) NULL,
  PRIMARY KEY (`category_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_inventory`.`sub_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_inventory`.`sub_category` (
  `sub_category_id` INT NOT NULL AUTO_INCREMENT,
  `sub_category_name` VARCHAR(100) NULL,
  PRIMARY KEY (`sub_category_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_inventory`.`color`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_inventory`.`color` (
  `color_id` INT NOT NULL AUTO_INCREMENT,
  `color_name` VARCHAR(100) NULL,
  PRIMARY KEY (`color_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_inventory`.`closet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_inventory`.`closet` (
  `closet_id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NOT NULL,
  `sub_category_id` INT NULL,
  `item_id` INT NULL,
  `color_id` INT NULL,
  PRIMARY KEY (`closet_id`) ,
  INDEX `fk_closet_category` (`category_id` ASC) ,
  INDEX `fk_closet_sub_category` (`sub_category_id` ASC) ,
  INDEX `fk_closet_color` (`color_id` ASC) ,
  CONSTRAINT `fk_closet_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `home_inventory`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_closet_sub_category`
    FOREIGN KEY (`sub_category_id`)
    REFERENCES `home_inventory`.`sub_category` (`sub_category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_closet_color`
    FOREIGN KEY (`color_id`)
    REFERENCES `home_inventory`.`color` (`color_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_inventory`.`detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_inventory`.`detail` (
  `detail_id` INT NOT NULL AUTO_INCREMENT,
  `detail_name` VARCHAR(100) NULL,
  PRIMARY KEY (`detail_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_inventory`.`matrix_category_sub_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_inventory`.`matrix_category_sub_category` (
  `category_id` INT NULL,
  `sub_category_id` INT NULL,
  UNIQUE INDEX `unique_index` (`category_id` ASC, `sub_category_id` ASC) ,
  INDEX `fk_sub_category_idx` (`sub_category_id` ASC) ,
  CONSTRAINT `fk_sub_category`
    FOREIGN KEY (`sub_category_id`)
    REFERENCES `home_inventory`.`sub_category` (`sub_category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `home_inventory`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_inventory`.`matrix_item_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_inventory`.`matrix_item_detail` (
  `item_id` INT NULL,
  `detail_id` INT NULL,
  UNIQUE INDEX `unique_index` (`item_id` ASC, `detail_id` ASC) ,
  INDEX `fk_matrix_item_detail_detail1_idx` (`detail_id` ASC) ,
  CONSTRAINT `fk_matrix_detail`
    FOREIGN KEY (`detail_id`)
    REFERENCES `home_inventory`.`detail` (`detail_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_matrix_item`
    FOREIGN KEY (`item_id`)
    REFERENCES `home_inventory`.`closet` (`closet_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
