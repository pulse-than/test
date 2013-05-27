SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `StitchportAutomation` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `StitchportAutomation` ;

-- -----------------------------------------------------
-- Table `StitchportAutomation`.`Orders`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`Orders` (
  `OrderId` INT NOT NULL AUTO_INCREMENT ,
  `Job` VARCHAR(45) NOT NULL ,
  `CustomerOrderNumber` VARCHAR(45) NULL DEFAULT NULL ,
  `OrderDate` DATETIME NULL DEFAULT NULL ,
  `ProductCode` VARCHAR(45) NOT NULL ,
  `Style` VARCHAR(45) NULL DEFAULT NULL ,
  `Design` VARCHAR(45) NULL DEFAULT NULL ,
  `Text1` VARCHAR(45) NULL DEFAULT NULL ,
  `TextColour1` VARCHAR(45) NULL DEFAULT NULL ,
  `Text2` VARCHAR(45) NULL DEFAULT NULL ,
  `TextColour2` VARCHAR(45) NULL DEFAULT NULL ,
  `Status` VARCHAR(45) NOT NULL ,
  `IsBlacklistChecked` BIT NOT NULL DEFAULT 0 ,
  `IsManuallyCreated` BIT NOT NULL DEFAULT 0 ,
  `CreatedDate` DATETIME NOT NULL ,
  `ProcessedDate` DATETIME NULL DEFAULT NULL ,
  `SewingDate` DATETIME NULL DEFAULT NULL ,
  `CompletedDate` DATETIME NULL DEFAULT NULL ,
  `IsDeleted` BIT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`OrderId`) ,
  INDEX `IX_Orders_CreatedDate` (`CreatedDate` ASC) ,
  INDEX `IX_Orders_Job` (`Job` ASC) ,
  INDEX `IX_Orders_Status` (`Status` ASC, `IsManuallyCreated` ASC) ,
  INDEX `IX_Orders_Text1` (`Text1` ASC) ,
  INDEX `IX_Orders_Text2` (`Text2` ASC) ,
  INDEX `IX_Orders_ProcessedDate` (`ProcessedDate` ASC) ,
  INDEX `IX_Orders_CompletedDate` (`CompletedDate` ASC) ,
  INDEX `IX_Orders_CustomerOrderNumber` (`CustomerOrderNumber` ASC) ,
  INDEX `IX_Orders_ForGenerator` (`IsManuallyCreated` DESC, `CreatedDate` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`Exceptions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`Exceptions` (
  `ExceptionId` INT NOT NULL AUTO_INCREMENT ,
  `CreatedDate` DATETIME NOT NULL ,
  `OrderId` INT NOT NULL ,
  `Code` INT NOT NULL ,
  `Message` VARCHAR(255) NOT NULL ,
  `IsCorrected` BIT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`ExceptionId`) ,
  INDEX `FK_Exceptions_Orders_OrderId_idx` (`OrderId` ASC) ,
  INDEX `IX_Exceptions_IsCorrected` (`IsCorrected` ASC) ,
  INDEX `IX_Exceptions_OrderId` (`OrderId` ASC) ,
  CONSTRAINT `FK_Exceptions_Orders_OrderId`
    FOREIGN KEY (`OrderId` )
    REFERENCES `StitchportAutomation`.`Orders` (`OrderId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`BlacklistItems`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`BlacklistItems` (
  `BlacklistItemId` INT NOT NULL AUTO_INCREMENT ,
  `Text` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`BlacklistItemId`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`KerningOverrides`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`KerningOverrides` (
  `KerningOverrideId` INT NOT NULL AUTO_INCREMENT ,
  `FontName` VARCHAR(45) NOT NULL ,
  `LetterA` CHAR(1) CHARACTER SET 'latin1' COLLATE 'latin1_general_cs' NOT NULL ,
  `LetterB` CHAR(1) CHARACTER SET 'latin1' COLLATE 'latin1_general_cs' NOT NULL ,
  `Kerning` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`KerningOverrideId`) ,
  UNIQUE INDEX `IX_KerningOverride_LetterA_LetterB` (`LetterA` ASC, `LetterB` ASC, `FontName` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`Colours`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`Colours` (
  `ColourId` INT NOT NULL AUTO_INCREMENT ,
  `Name` VARCHAR(45) NOT NULL ,
  `Code` VARCHAR(45) NOT NULL ,
  `Manufacturer` VARCHAR(45) NOT NULL ,
  `Red` TINYINT UNSIGNED NOT NULL ,
  `Green` TINYINT UNSIGNED NOT NULL ,
  `Blue` TINYINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`ColourId`) ,
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`NeedleColours`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`NeedleColours` (
  `NeedleColourId` INT NOT NULL AUTO_INCREMENT ,
  `NeedleNumber` TINYINT NOT NULL ,
  `ColourId` INT NULL DEFAULT NULL ,
  PRIMARY KEY (`NeedleColourId`) ,
  INDEX `FK_NeedleColours_Colours_ColourId_idx` (`ColourId` ASC) ,
  UNIQUE INDEX `IX_NeedleColours_NeedleNumber` (`NeedleNumber` ASC) ,
  CONSTRAINT `FK_NeedleColours_Colours_ColourId`
    FOREIGN KEY (`ColourId` )
    REFERENCES `StitchportAutomation`.`Colours` (`ColourId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`DesignDownloads`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`DesignDownloads` (
  `DesignDownloadId` INT NOT NULL AUTO_INCREMENT ,
  `MachineName` VARCHAR(255) NOT NULL ,
  `Job` VARCHAR(45) NOT NULL ,
  `DownloadDate` DATETIME NOT NULL ,
  PRIMARY KEY (`DesignDownloadId`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`DesignCompletes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`DesignCompletes` (
  `DesignCompleteId` INT NOT NULL AUTO_INCREMENT ,
  `MachineName` VARCHAR(255) NOT NULL ,
  `Job` VARCHAR(45) NOT NULL ,
  `CompletedDate` DATETIME NOT NULL ,
  PRIMARY KEY (`DesignCompleteId`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`DesignSewings`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`DesignSewings` (
  `DesignSewingId` INT NOT NULL AUTO_INCREMENT ,
  `MachineName` VARCHAR(255) NOT NULL ,
  `Job` VARCHAR(45) NOT NULL ,
  `SewingStartDate` DATETIME NOT NULL ,
  PRIMARY KEY (`DesignSewingId`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`Designs`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`Designs` (
  `DesignId` INT NOT NULL AUTO_INCREMENT ,
  `Name` VARCHAR(255) NOT NULL ,
  `File` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`DesignId`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`Products`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`Products` (
  `ProductId` INT NOT NULL AUTO_INCREMENT ,
  `Name` VARCHAR(45) NOT NULL ,
  `Code` VARCHAR(45) NOT NULL ,
  `MaxWidth` DOUBLE(9,6) NOT NULL ,
  `MaxHeight` DOUBLE(9,6) NOT NULL ,
  `Description` VARCHAR(255) NULL ,
  `RotationAngle` DOUBLE(9,6) NOT NULL DEFAULT 0 ,
  `Recipe` VARCHAR(45) NOT NULL DEFAULT 'Normal' ,
  `StartLocation` VARCHAR(45) NOT NULL DEFAULT 'centre' ,
  `StopLocation` VARCHAR(45) NOT NULL DEFAULT 'centre' ,
  PRIMARY KEY (`ProductId`) ,
  UNIQUE INDEX `IX_Products_ProductCode` (`Code` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`Styles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`Styles` (
  `StyleId` INT NOT NULL AUTO_INCREMENT ,
  `Name` VARCHAR(45) NOT NULL ,
  `Code` VARCHAR(45) NOT NULL ,
  `Description` VARCHAR(255) NULL DEFAULT NULL ,
  `FontName` VARCHAR(45) NOT NULL ,
  `TextHeight` DOUBLE(9,6) NOT NULL ,
  `Recipe` VARCHAR(45) NULL DEFAULT NULL ,
  `FontName2` VARCHAR(45) NULL DEFAULT NULL ,
  `TextHeight2` DOUBLE(9,6) NULL DEFAULT NULL ,
  `Recipe2` VARCHAR(45) NULL DEFAULT NULL ,
  `LineSpacing` DOUBLE(9,6) NULL DEFAULT NULL ,
  `WidthCompression` DOUBLE(9,6) NOT NULL DEFAULT 100 ,
  `TextType` VARCHAR(45) NOT NULL DEFAULT 'text' ,
  PRIMARY KEY (`StyleId`) ,
  UNIQUE INDEX `IX_Styles_Code` (`Code` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`DesignStyles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`DesignStyles` (
  `DesignStyleId` INT NOT NULL AUTO_INCREMENT ,
  `Name` VARCHAR(45) NOT NULL ,
  `Code` VARCHAR(45) NOT NULL ,
  `Description` VARCHAR(255) NULL DEFAULT NULL ,
  `Layout` VARCHAR(45) NOT NULL ,
  `Spacing` DOUBLE(9,6) NOT NULL ,
  `TextStyle` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`DesignStyleId`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`Machines`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`Machines` (
  `MachineId` INT NOT NULL AUTO_INCREMENT ,
  `Name` VARCHAR(45) NOT NULL ,
  `IsUseDefaultNeedles` BIT NOT NULL DEFAULT 1 ,
  PRIMARY KEY (`MachineId`) ,
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`MachineNeedles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`MachineNeedles` (
  `MachineNeedleId` INT NOT NULL AUTO_INCREMENT ,
  `MachineId` INT NOT NULL ,
  `NeedleNumber` TINYINT NOT NULL ,
  `ColourId` INT NULL DEFAULT NULL ,
  PRIMARY KEY (`MachineNeedleId`) ,
  INDEX `FK_MachineNeedles_Machines_MachineId_idx` (`MachineId` ASC) ,
  INDEX `FK_MachineNeedles_Colours_ColourId_idx` (`ColourId` ASC) ,
  UNIQUE INDEX `IX_MachineNeedles_Machine_NeedleNumber` (`MachineId` ASC, `NeedleNumber` ASC) ,
  INDEX `IX_MachineNeedles_Machine_Colour` (`MachineId` ASC, `ColourId` ASC) ,
  CONSTRAINT `FK_MachineNeedles_Machines_MachineId`
    FOREIGN KEY (`MachineId` )
    REFERENCES `StitchportAutomation`.`Machines` (`MachineId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_MachineNeedles_Colours_ColourId`
    FOREIGN KEY (`ColourId` )
    REFERENCES `StitchportAutomation`.`Colours` (`ColourId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `StitchportAutomation`.`TextHeightOverrides`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `StitchportAutomation`.`TextHeightOverrides` (
  `TextHeightOverrideId` INT NOT NULL AUTO_INCREMENT ,
  `StyleId` INT NOT NULL ,
  `ProductId` INT NULL DEFAULT NULL ,
  `FontName` VARCHAR(45) NULL DEFAULT NULL ,
  `MinCharacter` INT NOT NULL ,
  `MaxCharacter` INT NOT NULL ,
  `NewTextHeight` DOUBLE(9,6) NOT NULL ,
  PRIMARY KEY (`TextHeightOverrideId`) ,
  INDEX `FK_TextHeightOverrides_Styles_StyleId_idx` (`StyleId` ASC) ,
  INDEX `FK_TextHeightOverrides_Products_ProductId_idx` (`ProductId` ASC) ,
  CONSTRAINT `FK_TextHeightOverrides_Styles_StyleId`
    FOREIGN KEY (`StyleId` )
    REFERENCES `StitchportAutomation`.`Styles` (`StyleId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TextHeightOverrides_Products_ProductId`
    FOREIGN KEY (`ProductId` )
    REFERENCES `StitchportAutomation`.`Products` (`ProductId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `StitchportAutomation` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
