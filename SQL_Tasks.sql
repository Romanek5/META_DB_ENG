-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Booking` (
  `BookingID` INT NOT NULL,
  `Date` DATETIME NOT NULL,
  `TableNumber` INT NOT NULL,
  PRIMARY KEY (`BookingID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customer` (
  `CustomerID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Description` VARCHAR(255) NULL,
  PRIMARY KEY (`MenuID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`DeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`DeliveryStatus` (
  `DeliveryID` INT NOT NULL,
  `DeliveryDate` DATETIME NOT NULL,
  PRIMARY KEY (`DeliveryID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL,
  `Date` DATETIME NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL NULL,
  `Booking_BookingID` INT NOT NULL,
  `Customer_CustomerID` INT NOT NULL,
  `Menu_MenuID` INT NOT NULL,
  `DeliveryStatus_DeliveryID` INT NOT NULL,
  PRIMARY KEY (`OrderID`, `Customer_CustomerID`, `Menu_MenuID`, `DeliveryStatus_DeliveryID`),
  INDEX `fk_Orders_Booking_idx` (`Booking_BookingID` ASC) VISIBLE,
  INDEX `fk_Orders_Customer1_idx` (`Customer_CustomerID` ASC) VISIBLE,
  INDEX `fk_Orders_Menu1_idx` (`Menu_MenuID` ASC) VISIBLE,
  INDEX `fk_Orders_DeliveryStatus1_idx` (`DeliveryStatus_DeliveryID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Booking`
    FOREIGN KEY (`Booking_BookingID`)
    REFERENCES `LittleLemonDB`.`Booking` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Customer1`
    FOREIGN KEY (`Customer_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Menu1`
    FOREIGN KEY (`Menu_MenuID`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_DeliveryStatus1`
    FOREIGN KEY (`DeliveryStatus_DeliveryID`)
    REFERENCES `LittleLemonDB`.`DeliveryStatus` (`DeliveryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `StaffID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Salary` DECIMAL NOT NULL,
  `Customer_CustomerID` INT NOT NULL,
  PRIMARY KEY (`StaffID`),
  INDEX `fk_Staff_Customer1_idx` (`Customer_CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Staff_Customer1`
    FOREIGN KEY (`Customer_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


CREATE PROCEDURE AddBooking (IN BookingID INT, IN CustomerID INT, IN TableNumber INT, IN BookingDate DATE)
BEGIN
INSERT INTO booking (bookingid, customerid, tablenumber, date) VALUES (BookingID, CustomerID, TableNumber, BookingDate); 
END


CREATE PROCEDURE AddValidBooking (IN BookingDate DATE, IN TableNumber INT)

START TRANSACTION;

SELECT BookingDate, TableNumber
WHERE exists (SELECT * from Booking where Date = BookingDate and TableNumber = TableNumber)

	INSERT INTO booking (date, table_number)
	VALUES (BookingDate, TableNumber);
    
	COMMIT;


CREATE PROCEDURE CancelOrder(IN OrderID INT)
DELETE FROM orders;


CREATE PROCEDURE CheckBooking(IN BookingDate DATE, IN TableNumber INT)
SELECT BookingDate, TableNumber
WHERE exists (SELECT * from Booking where Date = BookingDate and TableNumber = TableNumber)
	

CREATE PROCEDURE UpdateBooking (IN BookingID INT, IN BookingDate DATE)
BEGIN
UPDATE bookings SET date = BookingDate WHERE booking_id = BookingID; 
END


CREATE PROCEDURE GetMaxQuantity()
SELECT MAX(orders.Quantity)
FROM orders;


PREPARE GetOrderDetail from 'SELECT OrderID, Quantity, TotalCost from Orders where OrderID=?'
SET @id = 1;
EXECUTE GetOrderDetail USING @id;


CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(IN BookingID INT)
BEGIN
DELETE FROM booking WHERE booking_id = BookingID;
END


INSERT INTO booking(BookingID, BookingDate, TableNumber)
VALUES 
(1, '2022-10-10', 5),
(2, '2022-11-12', 3),
(3, '2022-10-11', 2),
(4, '2022-10-13', 2);


CREATE VIEW OrdersView2 AS
SELECT customer.CustomerID, customer.FullName, orders.OrderID, orders.TotalCost
FROM customer INNER JOIN orders
WHERE orders.TotalCost > 150
ORDER BY orders.TotalCost DESC;


CREATE VIEW OrdersView AS
SELECT orders.OrderID, orders.Quantity, orders.TotalCost
FROM orders
WHERE orders.Quantity > 2


PREPARE GetOrderDetail FROM order

