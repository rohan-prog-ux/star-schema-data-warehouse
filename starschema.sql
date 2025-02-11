-- MySQL Script generated by MySQL Workbench
-- Sun May 15 20:15:42 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';




DROP SCHEMA IF EXISTS `starschema` ;

-- -----------------------------------------------------
-- Schema starschema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `starschema` ;





USE `starschema` ;

-- -----------------------------------------------------
-- Table `starschema`.`customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `starschema`.`customers` ;

CREATE TABLE IF NOT EXISTS `starschema`.`customers` 
 (
    `CustomerID` VARCHAR(45),
    `CompanyName` VARCHAR(40) NOT NULL,
    `ContactName` VARCHAR(30),
    `ContactTitle` VARCHAR(30),
    `Address` VARCHAR(60),
    `City` VARCHAR(15),
    `Region` VARCHAR(15),
    `PostalCode` VARCHAR(10),
    `Country` VARCHAR(15),
    `Phone` VARCHAR(24),
    `Fax` VARCHAR(24),
    `customer_dimension_key`INT,
    PRIMARY KEY (`CustomerID`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `starschema`.`employees`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `starschema`.`employees` ;

CREATE TABLE IF NOT EXISTS `starschema`.`employees` (
    `EmployeeID` VARCHAR(50),
    `LastName` VARCHAR(20) NOT NULL,
    `FirstName` VARCHAR(10) NOT NULL,
    `Title` VARCHAR(30),
    `TitleOfCourtesy` VARCHAR(25),
    `BirthDate` DATETIME,
    `HireDate` DATETIME,
    `Address` VARCHAR(60),
    `City` VARCHAR(15),
    `Region` VARCHAR(15),
    `PostalCode` VARCHAR(10),
    `Country` VARCHAR(15),
    `HomePhone` VARCHAR(24),
    `Extension` VARCHAR(4),
    `Photo` LONGBLOB,
    `Notes` MEDIUMTEXT NOT NULL,
    `ReportsTo` INTEGER,
    `PhotoPath` VARCHAR(255),
	`Salary` FLOAT,
    PRIMARY KEY (`EmployeeID`))   
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `starschema`.`products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `starschema`.`products` ;

CREATE TABLE IF NOT EXISTS `starschema`.`products` 
(
    `ProductID` INT,
    `ProductName` VARCHAR(40) NOT NULL,
    `SupplierID` INT,
    `QuantityPerUnit` VARCHAR(20),
    `UnitPrice`  DECIMAL(10,4) DEFAULT 0,
    `UnitsInStock` SMALLINT(2) DEFAULT 0,
    `UnitsOnOrder` SMALLINT(2) DEFAULT 0,
    `ReorderLevel` SMALLINT(2) DEFAULT 0,
    `Discontinued` BIT NOT NULL DEFAULT 0,
    `categoryid` VARCHAR(20),
    `CategoryName` VARCHAR(50),
    `Discription` VARCHAR(50),
	`Picture` Varchar(45),
    PRIMARY KEY (`ProductID`))
    
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `starschema`.`fact_northwind`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `starschema`.`fact_northwind` ;

CREATE TABLE IF NOT EXISTS `starschema`.`fact_northwind` (

  `fk_CustomerID` INT ,
  `fk_employeeID` INT,
  `requireddate` VARCHAR(10) NOT NULL,
  `shipcity` VARCHAR(50) NOT NULL,
  `fk_productID` INT NOT NULL,
  `shipperdate` VARCHAR(45),
  `shipvia` VARCHAR(45),
  `ship_city` VARCHAR(50),
  `region` VARCHAR(45),
  `orderID` INT(11),
  `orderdate`  VARCHAR(11) ,
  `UnitPrice` DECIMAL(10,2) NULL,
  `Quantity` SMALLINT(2) NOT NULL DEFAULT 1,
  `Discount` REAL(8,0) NOT NULL DEFAULT 0,
  `Freight` VARCHAR(45),
  `orderdetails` VARCHAR(50),
  foreign key(`fk_CustomerID`) references customers(customerID),
  foreign key(`fk_EmployeeID`) references employees(employeeID),
  foreign key(`fk_productID`) references products(ProductID))
ENGINE = InnoDB;




# ---------------------------------------------------------------------- #
# Table `starschema` . `TimeDimension`                                                #
# ---------------------------------------------------------------------- #

DROP TABLE IF EXISTS `starschema`.`TimeDimension` ;

CREATE TABLE IF NOT EXISTS `starschema`. `TimeDimension` (
   `DateID` INT,
   `date` VARCHAR(45),
   `year` VARCHAR(45),
   `month` VARCHAR(45),
   `day` VARCHAR(45),
   `day_of_week` VARCHAR(45),
   `month_of_year` VARCHAR(45),
   `day_of_month` VARCHAR(45),
   `day_of_year` VARCHAR(45),
   `weekend` VARCHAR(45),
   `quater` VARCHAR(45))
    
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;






SELECT * FROM starschema.customers;


-- 1) customers
DELIMITER //

CREATE PROCEDURE insertinto_dim_customers()
BEGIN

    SET FOREIGN_KEY_CHECKS=0;
    TRUNCATE TABLE starschema.customers;
    SET FOREIGN_KEY_CHECKS=1;

    INSERT INTO starschema.customers (
    
	 CustomerID,
     CompanyName,
     ContactName,
     ContactTitle,
     Address,
     City,
     Region,
     PostalCode,
     Country,
     Phone,
     Fax

    )
    SELECT
	 CustomerID,
     CompanyName,
     ContactName,
     ContactTitle,
     Address,
     City,
     Region,
     PostalCode,
     Country,
     Phone,
     Fax
    FROM northwind.Customers
    WHERE (CompanyName IS NOT NULL) ;

END//

DELIMITER ;


call starschema.insertinto_dim_customers();

ALTER TABLE starschema.employees DROP COLUMN effectiveend;

alter table starschema.employees
add column skey INT NOT NULL AUTO_INCREMENT,
add column effectivedate timestamp Default current_timestamp NULL AFTER skey,
add column expiredate timestamp Default current_timestamp NULL AFTER effectivedate,
add column iscurrent BOOLEAN Default TRUE,
ADD UNIQUE INDEX skey_UNIQUE (skey ASC);



SELECT * FROM starschema.employees;

SELECT * FROM northwind.Employees;




-- 1) employees
DELIMITER //

CREATE PROCEDURE insertinto_dim_employees()
BEGIN

    SET FOREIGN_KEY_CHECKS=0;
    TRUNCATE TABLE starschema.employees;
    SET FOREIGN_KEY_CHECKS=1;

    INSERT INTO starschema.employees (
    
	EmployeeID,
    LastName,
    FirstName,
    Title ,
    TitleOfCourtesy ,
    BirthDate,
    HireDate ,
    Address ,
    City,
    Region,
    PostalCode ,
    Country,
    HomePhone,
    Extension,
    Photo,
    Notes,
    ReportsTo,
    PhotoPath,
	Salary
    )
    SELECT
	 EmployeeID,
    LastName,
    FirstName,
    Title ,
    TitleOfCourtesy ,
    BirthDate,
    HireDate ,
    Address ,
    City,
    Region,
    PostalCode ,
    Country,
    HomePhone,
    Extension,
    Photo,
    Notes,
    ReportsTo,
    PhotoPath,
	Salary
    FROM northwind.Employees
    WHERE (Notes IS NOT NULL) ;

END//

DELIMITER ;


call starschema.insertinto_dim_Employees();

Select * from northwind.Employees;
select * from starschema.employees;



-- Product
DELIMITER //

CREATE PROCEDURE insertinto_dim_Products()
BEGIN

    SET FOREIGN_KEY_CHECKS=0;
    TRUNCATE TABLE starschema.Products;
    SET FOREIGN_KEY_CHECKS=1;

    INSERT INTO starschema.Products (
    
	ProductID ,
    ProductName,
    SupplierID ,
    QuantityPerUnit,
    UnitPrice  ,
    UnitsInStock ,
    UnitsOnOrder ,
    ReorderLevel ,
    Discontinued,
    categoryid ,
    CategoryName ,
    Discription,
	Picture
    )
    SELECT
ProductID ,
    ProductName,
    SupplierID ,
    QuantityPerUnit,
    UnitPrice  ,
    UnitsInStock ,
    UnitsOnOrder ,
    ReorderLevel ,
    Discontinued,
    categoryid ,
    CategoryName ,
    Discription,
	Picture
    
    FROM northwind.Products
    WHERE (Notes IS NOT NULL) ;

END//

DELIMITER ;


call starschema.insertinto_dim_Products();

Select * from northwind.Employees; 

Select * from starschema.employees;
	
    






fact table
DELIMITER //
CREATE PROCEDURE insertinto_dim_fact_northwind()
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    TRUNCATE TABLE starschema.fact_classicmodels;
    SET FOREIGN_KEY_CHECKS=0;

    INSERT INTO starschema.fact_classicmodels (
        fk_CustomerID, fk_employeeID, fk_productID, requireddate, shipcity, 
        shipperdate, shipvia, region, orderID, orderdate, orderdetails,
        UnitPrice, Discount
    )
    SELECT 
        orders.customerID as fk_customerID, 
        payments.customerID as fk_customerID,
        northwind.orderdetails.productID as fk_productID, 
        northwind.orderdetails.orderID as orderID,
        northwind.products.quantityInStock as quantityInStock , 
        northwind.orderdetails.quantityOrdered as quantityOrdered,
        northwind.orderdetails.shipcity as shipcity ,
        year(orders.shipperdate)*10000+month(orders.shipperdate)*100+day(orders.shipperdate) as shipperdate ,
        year(orders.requireddate)*10000+month(orders.requireddate)*100+day(orders.requireddate) as requireddate,
        year(orders.orderdate)*1000+month(orders.orderdate)*100+day(orders.orderdate) as datedate , 
        orders.status as status ,
        northwind.products.UnitPrice as  UnitPrice,
        northwind.products.shipvia as shipvia,
        northwind.products.region as region,
        northwind.products.shipcity as shipcity,
        northwind.products.Discount as Discount
    FROM northwind.orders 
    LEFT JOIN northwind.customers AS c1 ON c1.customerID = orders.customerID
    LEFT JOIN northwind.employees  e ON e.employeeID = c1.salesRepEmployeeID
    LEFT JOIN northwind.orderdetails ON northwind.orderdetails.orderID = orders.orderID
    LEFT JOIN northwind.products ON northwind.products.productID = northwind.order.productID;
END
//
DELIMITER ;

call starschema.insertinto_dim_fact_northwind();




SELECT * FROM starschema.employees;

SELECT * FROM northwind.Employees;


