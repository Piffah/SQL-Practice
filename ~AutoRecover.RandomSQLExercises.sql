

   DECLARE @Training VARCHAR(20) = 'My Training Session'






USE AdventureWorks2012
GO



-- Task 1: Retrieve all columns and rows from the Production.Product table

SELECT * 
FROM Production.Product;




-- Task 2: Retrieve the ProductID, Name, and ListPrice columns from the Production.Product table

SELECT ProductID, Name, ListPrice
FROM Production.Product;




-- Task 3: Retrieve the ProductID and Name columns and only rows where the ListPrice is greater than $100

SELECT ProductID, Name
FROM Production.Product
WHERE ListPrice > 100;




-- Task 4: Retrieve the average ListPrice of all products in the Production.Product table

SELECT AVG(ListPrice) as AverageListPrice
FROM Production.Product;




-- Task 5: Retrieve the total number of products in the Production.Product table

SELECT COUNT(ProductID) as TotalProducts
FROM Production.Product;




-- Task 6: Retrieve the minimum and maximum ListPrice of products in the Production.Product table

SELECT MIN(ListPrice) as MinListPrice, MAX(ListPrice) as MaxListPrice
FROM Production.Product;




-- Task 7: Retrieve the Name and ListPrice of the most expensive product in the Production.Product table

SELECT Name, ListPrice
FROM Production.Product
WHERE ListPrice = (SELECT MAX(ListPrice) FROM Production.Product);




-- Task 8: Retrieve the Name, ProductNumber, and ListPrice of all products in the Production.Product table where the average ListPrice of all products is greater than the ListPrice of the product

SELECT Name, ProductNumber, ListPrice
FROM Production.Product
WHERE ListPrice < (SELECT AVG(ListPrice) FROM Production.Product);
GO




-- Task 9: Create a stored procedure to retrieve the Name, ProductNumber, and ListPrice of all products in the Production.Product table

CREATE PROCEDURE GetProductDetails
AS
BEGIN
    SELECT Name, ProductNumber, ListPrice
    FROM Production.Product;
END;
GO




-- Task 10: Create a trigger to automatically update the ModifiedDate column in the Production.Product table whenever a product's information is updated

CREATE TRIGGER tr_UpdateProductModifiedDate
ON Production.Product
AFTER UPDATE
AS
BEGIN
    UPDATE Production.Product
    SET ModifiedDate = GETDATE()
    WHERE ProductID IN (SELECT ProductID FROM inserted);
END;
GO





-- Task 11: Create a view to retrieve the Name, ProductNumber, and ListPrice of all products in the Production.Product table

CREATE VIEW vw_ProductDetails
AS
SELECT Name, ProductNumber, ListPrice
FROM Production.Product;
GO





-- Task 12: Create a query that categorizes the products in the AdventureWorks2012 database based on their list price into "Affordable", "Moderately Priced", or "Expensive".

SELECT 
    Name,
    ListPrice,
    CASE 
        WHEN ListPrice < 50 THEN 'Affordable'
        WHEN ListPrice BETWEEN 50 AND 100 THEN 'Moderately Priced'
        ELSE 'Expensive'
    END AS PriceRange
FROM 
    Production.Product;




	-- Task 13: Use a CASE statement to update the list price of products in the AdventureWorks2012 database based on their current price.
	-- The list price should be increased by 10% if the current price is less than 100, and decreased by 10% if the current price is equal to or greater than 100.

	DECLARE @PriceThreshold money = 100;

UPDATE Production.Product
SET ListPrice = 
    CASE 
        WHEN ListPrice < @PriceThreshold THEN ListPrice * 1.10
        ELSE ListPrice * 0.90
    END
WHERE 
    ProductID BETWEEN 1 AND 100;





 -- Task 14: Create a query that increments the list price of products in the AdventureWorks2012 database until a target price of 150 is reached.
 -- The list price should be incremented by 10 for each iteration of the loop.
	
	DECLARE @TargetPrice money = 150;
   DECLARE @CurrentPrice money;
  DECLARE @ProductID INT = 1;

WHILE @CurrentPrice < @TargetPrice
BEGIN
    SELECT @CurrentPrice = ListPrice
    FROM Production.Product
    WHERE ProductID = @ProductID;

    UPDATE Production.Product
    SET ListPrice = ListPrice + 10
    WHERE ProductID = @ProductID;

    SET @ProductID = @ProductID + 1;
END
GO


 --Task 15: Create a query that retrieves the product name and list price for all products in the AdventureWorks2012 database that are in the "Bikes" category, 
 --and increases their list price by 20% if the list price is less than 500. If the list price is equal to or greater than 500, then the list price should remain the same.

 DECLARE @PriceThreshold money = 500;

SELECT 
    Name, 
    ListPrice,
    CASE 
        WHEN ListPrice < @PriceThreshold THEN ListPrice * 1.20
        ELSE ListPrice
    END AS NewListPrice
FROM 
    Production.Product
WHERE 
    ProductSubcategoryID = (SELECT ProductSubcategoryID FROM Production.ProductSubcategory WHERE Name = 'Bikes');
GO




 



-- Design a database for a construction company to store information about its customers, projects, and materials.
-- Tables for customers, projects, and materials, with columns for relevant info. 
-- This is a sample database I created and maintained in my last job for demonstration purposes only.
-- The actual database cannot be shared due to security reasons.

 
 CREATE DATABASE BULTRANS_LTD;

USE BULTRANS_LTD;

CREATE TABLE customers (
  customer_id INT IDENTITY PRIMARY KEY,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  company_name VARCHAR(50),
  email VARCHAR(50) NOT NULL,
  phone_number VARCHAR(30) NOT NULL,
  address VARCHAR(100) NOT NULL
);

CREATE TABLE projects (
  project_id INT IDENTITY PRIMARY KEY,
  project_name VARCHAR(50) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  customer_id INT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE materials (
  material_id INT IDENTITY PRIMARY KEY,
  material_name VARCHAR(100) NOT NULL,
  material_type VARCHAR(50) NOT NULL,
  quantity INT NOT NULL,
  price_per_unit DECIMAL(10, 2) NOT NULL,
  project_id INT NOT NULL,
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

 
 INSERT INTO customers (first_name, last_name, email, phone_number, address)
VALUES 
('John', 'Doe', 'johndoe@email.com', '555-555-5555', '1234 Main St'),
('Jane', 'Doe', 'janedoe@email.com', '555-555-5556', '5678 Main St'),
('Jim', 'Smith', 'jimsmith@email.com', '555-555-5557', '91011 Main St'),
('Lisa', 'Johnson', 'lisajohnson@email.com', '555-555-5558', '121314 Main St'),
('Bob', 'Brown', 'bobbrown@email.com', '555-555-5559', '151617 Main St');

INSERT INTO projects (project_name, start_date, end_date, customer_id)
VALUES 
('Project A', '2022-01-01', '2022-03-31', 1),
('Project B', '2022-02-01', '2022-05-30', 2),
('Project C', '2022-03-01', '2022-08-29', 3),
('Project D', '2022-04-01', '2022-06-02', 4),
('Project E', '2022-05-01', '2022-07-04', 5),
('Project F', '2022-06-01', '2022-07-01', 1),
('Project G', '2022-07-01', '2022-07-03', 2),
('Project H', '2022-08-01', '2022-08-02', 3),
('Project I', '2022-09-01', '2022-09-03', 4),
('Project J', '2022-10-01', '2022-10-04', 5);

INSERT INTO materials (material_name, material_type, quantity, price_per_unit, project_id)
VALUES 
('Aluminum Moldings', 'Metal Molding', 100, 2.80, 1),
('Drywall', 'Drywall', 500, 12.40, 2),
('Nails', 'Fasteners', 20, 11.90, 3),
('Bag of Cement', 'Cement', 200, 14.80, 4),
('Steel Beam', 'Steel', 75, 15.00, 5),
('Roofing Tiles', 'Roofing', 200, 7.50, 1),
('Wooden Planks', 'Wood', 400, 3.00, 2),
('PVC Pipes', 'Plumbing', 100, 5.00, 3),
('Insulation Material', 'Insulation', 200, 10.00, 4),
('Electric Wiring', 'Electrical', 500, 3.50, 5);


SELECT * FROM customers
SELECT * FROM projects
SELECT * FROM materials



 ALTER TABLE Customers
ALTER COLUMN email VARCHAR(50) NULL;

 ALTER TABLE Customers
ALTER COLUMN company_name VARCHAR(50) NULL;

GO






USE AdventureWorks2012
GO

--First CTE: Retrieves sales order data from the Sales.SalesOrderHeader table and calculates the order year and quarter using the DATEPART function.

--Second CTE: Joins the data from the first CTE with customer information from the Person.Person table to retrieve additional information such as first name and last name.

--Third CTE: Aggregates the sales order data by calendar year and quarter to calculate total sales for each period using the SUM function and the GROUP BY clause.

--Fourth CTE: Calculates the running total of sales for each quarter using the SUM aggregate function and the OVER clause.

--Final SELECT statement: Selects the calendar year, quarter, total sales, and running total from the fourth CTE and orders the results in descending order by running total.

WITH 
    SalesOrders AS 
    (
        SELECT 
            CustomerID, 
            DATEPART(YEAR, OrderDate) AS OrderYear, 
            DATEPART(QUARTER, OrderDate) AS OrderQuarter, 
            TotalDue
        FROM 
            Sales.SalesOrderHeader
    ), 
    CustomerOrders AS 
    (
        SELECT 
            SO.OrderYear, 
            SO.OrderQuarter, 
            P.FirstName, 
            P.LastName, 
            SO.TotalDue
        FROM 
            SalesOrders SO
            INNER JOIN Person.Person P ON SO.CustomerID = P.BusinessEntityID
    ), 
    SalesByPeriod AS 
    (
        SELECT 
            OrderYear, 
            OrderQuarter, 
            SUM(TotalDue) AS TotalSales
        FROM 
            CustomerOrders
        GROUP BY 
            OrderYear, 
            OrderQuarter
    ), 
    RunningTotals AS 
    (
        SELECT 
            OrderYear, 
            OrderQuarter, 
            TotalSales, 
            SUM(TotalSales) OVER (ORDER BY OrderYear, OrderQuarter) AS RunningTotal
        FROM 
            SalesByPeriod
    ) 
SELECT 
    OrderYear, 
    OrderQuarter, 
    TotalSales, 
    RunningTotal
FROM 
    RunningTotals
ORDER BY 
    RunningTotal DESC;
	




	--Check if the #TempTable already exists in the tempdb database
    --If it exists, drop the table
    --Create the #TempTable table
    --Insert data into the #TempTable table from the AdventureWorks2012.Sales.Customer table, selecting only the customers who have a TerritoryID of 5
    --Select all data from the #TempTable table to verify that the data has been successfully inserted

	IF OBJECT_ID('tempdb..#TempTable', 'U') IS NOT NULL
BEGIN
    DROP TABLE #TempTable;
END;
GO

CREATE TABLE #TempTable (
    CustomerID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);
GO

INSERT INTO #TempTable
SELECT CustomerID, FirstName, LastName
FROM AdventureWorks2012.Sales.Customer
WHERE TerritoryID = 5;
GO

SELECT *
FROM #TempTable;





USE AdventureWorks2012


IF OBJECT_ID('HumanResources.Department', 'U') IS NOT NULL
    PRINT 'Table exists'
ELSE
    PRINT 'Table does not exist'


SELECT TOP(1) *
FROM HumanResources.Department


-- Start a new transaction
BEGIN TRANSACTION

-- Update the data in the Department table
UPDATE HumanResources.Department
SET Name = 'Marketing'
WHERE DepartmentID = 4;

-- Check if the update was successful
IF @@ERROR <> 0
BEGIN
    -- If there was an error, roll back the transaction
    ROLLBACK TRANSACTION
    PRINT 'The transaction was rolled back due to an error'
END
ELSE
BEGIN
    -- If the update was successful, commit the transaction
    COMMIT TRANSACTION
    PRINT 'The transaction was committed'
END;



SELECT Name, DepartmentID
FROM HumanResources.Department




USE BULTRANS_LTD
GO 

SELECT * FROM customers
SELECT * FROM materials
SELECT * FROM projects


USE AdventureWorks2012
GO

--Here's an example of how the COALESCE function could be used in the AdventureWorks2012 database:


SELECT P.ProductID, P.Name, COALESCE(P.Color, 'N/A') AS Color
FROM Production.Product AS P;

--This query retrieves the product ID, name, and color of products from the Production.Product table in the AdventureWorks2012 database.
--The COALESCE function is used to return the value of the Color column if it's not null, otherwise it returns the string 'N/A'.








  --These are my old practice codes, created randomly or used from certain tasks sources for training purposes. They are not part of any larger project.




-- Declare a variable called @MyOption and set its value to 'Option B'.
DECLARE @MyOption AS VARCHAR(10) = 'Option B'

-- Use a CASE statement to compare @MyOption to different options.
SELECT CASE 
    WHEN @MyOption = 'Option A' THEN 'You chose Option A.'
    WHEN @MyOption = 'Option B' THEN 'You chose Option B, which is the default option.'
    ELSE 'You chose an option that is not recognized.'
END AS 'Option Result'

-- Use the CAST function to convert the string '123' to an integer, and then add 2 to the result.
SELECT '123' AS 'Original Value', CAST('123' AS INT) + 2 AS 'Result'

-- Use the CONVERT function to convert the current date to a string with a specific format.
SELECT GETDATE() AS 'Current Datetime', CONVERT(VARCHAR(10), GETDATE(), 5) AS 'Formatted Date'





IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO
CREATE TABLE dbo.Customers
(
custid INT NOT NULL,
companyname VARCHAR(25) NOT NULL,
phone VARCHAR(20) NOT NULL,
address VARCHAR(50) NOT NULL,
CONSTRAINT PK_Customers PRIMARY KEY(custid)
);



INSERT INTO dbo.Customers(custid, companyname, phone, address)
VALUES
(1, 'cust 1', '(111) 111-1111', 'address 1'),
(2, 'cust 2', '(222) 222-2222', 'address 2'),
(3, 'cust 3', '(333) 333-3333', 'address 3'),
(4, 'cust 4', '(444) 444-4444', 'address 4'),
(5, 'cust 5', '(555) 555-5555', 'address 5');



IF OBJECT_ID('dbo.CustomersStage', 'U') IS NOT NULL DROP TABLE dbo.
CustomersStage;
GO
CREATE TABLE dbo.CustomersStage
(
custid INT NOT NULL,
companyname VARCHAR(25) NOT NULL,
phone VARCHAR(20) NOT NULL,
address VARCHAR(50) NOT NULL,
CONSTRAINT PK_CustomersStage PRIMARY KEY(custid)
);
INSERT INTO dbo.CustomersStage(custid, companyname, phone, address)
VALUES
(2, 'AAAAA', '(222) 222-2222', 'address 2'),
(3, 'cust 3', '(333) 333-3333', 'address 3'),
(5, 'BBBBB', 'CCCCC', 'DDDDD'),
(6, 'cust 6 (new)', '(666) 666-6666', 'address 6'),
(7, 'cust 7 (new)', '(777) 777-7777', 'address 7');



SELECT TOP(10) * FROM dbo.Customers;
SELECT TOP(10) * FROM dbo.CustomersStage;

MERGE INTO dbo.Customers AS TGT
USING dbo.CustomersStage AS SRC
ON TGT.custid = SRC.custid
WHEN MATCHED THEN
UPDATE SET
TGT.Companyname = SRC.Companyname,
TGT.Phone = SRC.Phone,
TGT.address = SRC.address
WHEN NOT MATCHED THEN
INSERT (custID, companyname, phone, address)
VALUES (SRC.custID, SRC.companyname, SRC.phone, SRC.address);


DROP TABLE dbo.Customers
DROP TABLE dbo.CustomersStage



SELECT @@VERSION AS 'My SQL Server'


USE AdventureWorks2012
GO

SELECT TOP(1) * FROM dbo.Nums
SELECT TOP(1) * FROM Production.Products
SELECT TOP(1) * FROM hr.Employees
SELECT TOP(1) * FROM Production.Categories
SELECT TOP(1) * FROM Sales.Customers
SELECT TOP(1) * FROM Sales.OrderDetails
SELECT TOP(1) * FROM Sales.Orders


SELECT productid,
       qty,
	   SUM(qty) OVER (PARTITION BY ProductID ORDER BY OrderID) AS CumulativeSum
	   FROM Sales.OrderDetails


CREATE TABLE SalesOrderSummary (
    SalesOrderID INT,
    OrderYear INT,
    OrderMonth INT,
    ProductName NVARCHAR(50),
    TotalSales DECIMAL(18,2)
);

INSERT INTO SalesOrderSummary (
    SalesOrderID,
    OrderYear,
    OrderMonth,
    ProductName,
    TotalSales
)

SELECT 
    SOD.SalesOrderID,
    YEAR(SOH.OrderDate) AS OrderYear,
    MONTH(SOH.OrderDate) AS OrderMonth,
    SOD.ProductID,
    SUM(SOD.LineTotal) OVER (PARTITION BY 
        YEAR(SOH.OrderDate), 
        MONTH(SOH.OrderDate)) AS TotalSales
FROM 
    Sales.SalesOrderDetail AS SOD
INNER JOIN 
    Sales.SalesOrderHeader AS SOH
ON 
    SOD.SalesOrderID = SOH.SalesOrderID;



DECLARE @MyString NVARCHAR(20)
SET @MyString = N'Бележчица'

SELECT @MyString AS 'My String'









BEGIN TRY 
   PRINT 10/0;
   PRINT 'No Error'
END TRY
   BEGIN CATCH
   PRINT 'Error'
END CATCH;


IF OBJECT_ID('dbo.Employees') IS NOT NULL DROP TABLE dbo.Employees;
CREATE TABLE dbo.Employees
(
 empid   INT         NOT NULL,
 empname VARCHAR(25) NOT NULL,
 mgrid   INT             NULL,
 CONSTRAINT PK_Employees PRIMARY KEY(empid),
 CONSTRAINT CHK_Employees CHECK(empid > 0),
 CONSTRAINT FK_Employees_Employees
            FOREIGN KEY(mgrid) REFERENCES dbo.Employees(empid)
);

 
 
 
 BEGIN TRY
   INSERT INTO dbo.Employees(empid, empname, mgrid)
   VALUES (0, 'A', NULL) 
   -- Also try with empid = 0, 'A', NULL
 END TRY 
 BEGIN CATCH
        IF ERROR_NUMBER() = 2627
  BEGIN 
       PRINT  '    Handling PK violation.....'
  END
  ELSE IF ERROR_NUMBER() = 547
  BEGIN
       PRINT  '    Handling CHECK/FK constraint violation.....'
  END
  ELSE IF ERROR_NUMBER() = 515
  BEGIN
       PRINT  '    Handling NULL violation.....'
  END
  ELSE IF ERROR_NUMBER() = 245
  BEGIN
       PRINT  '    Handling conversion error.....'
  END
       ELSE
  BEGIN
     PRINT    '    Re throwing error.....';
	 THROW;   -- SQL Server 2012 only
  END

     PRINT  ' Error Number :  ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	 PRINT ' Error Message :  ' + ERROR_MESSAGE();
     PRINT ' Error Severity:  ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
     PRINT   ' Error State :  ' + CAST(ERROR_STATE() AS VARCHAR(10));
     PRINT    ' Error Line :  ' + CAST(ERROR_LINE() AS VARCHAR(10));
     PRINT    ' Error Proc :  ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
 END CATCH;

     SELECT * FROM dbo.Employees





DECLARE @inputString AS VARCHAR(100) = 'One hundred twenty three'

-- Define a lookup table that maps words to their corresponding numeric value.
DECLARE @lookupTable TABLE (word VARCHAR(10), value INT)
INSERT INTO @lookupTable VALUES
('zero', 0), ('one', 1), ('two', 2), ('three', 3), ('four', 4),
('five', 5), ('six', 6), ('seven', 7), ('eight', 8), ('nine', 9),
('ten', 10), ('eleven', 11), ('twelve', 12), ('thirteen', 13), ('fourteen', 14),
('fifteen', 15), ('sixteen', 16), ('seventeen', 17), ('eighteen', 18), ('nineteen', 19),
('twenty', 20), ('thirty', 30), ('forty', 40), ('fifty', 50),
('sixty', 60), ('seventy', 70), ('eighty', 80), ('ninety', 90),
('hundred', 100), ('thousand', 1000), ('million', 1000000)

-- Split the input string into individual words.
DECLARE @words TABLE (word VARCHAR(10))
DECLARE @pos INT = 1, @len INT, @word VARCHAR(10)
SET @inputString = LTRIM(RTRIM(@inputString)) + ' '
SET @len = LEN(@inputString)
WHILE @pos <= @len
BEGIN
    SET @word = SUBSTRING(@inputString, @pos, CHARINDEX(' ', @inputString, @pos) - @pos)
    SET @pos = CHARINDEX(' ', @inputString, @pos) + 1
    INSERT INTO @words VALUES (@word)
END

-- Calculate the integer value by summing up the values of each word.
DECLARE @result INT = 0, @currentValue INT = 0, @prevValue INT = 0
SELECT @result = SUM(value) FROM (
    SELECT CASE
        WHEN value = 100 THEN value * @currentValue
        WHEN value >= 1000 THEN @result * value + @currentValue
        ELSE value
    END AS value, @prevValue, @currentValue,
    CASE
        WHEN value >= 100 THEN value
        WHEN value >= 1000 THEN value
        ELSE 0
    END AS multiplier
    FROM (
        SELECT LT.value, @prevValue, @currentValue
        FROM @lookupTable LT
        JOIN @words W ON LT.word = W.word
        WHERE LT.value IS NOT NULL
    ) AS t
) AS t

-- Cast the resulting integer value to a string and display the result.
SELECT @inputString AS 'Original String', CAST(@result AS VARCHAR(10)) AS 'Result'



SELECT
     CASE
      WHEN GETDATE() BETWEEN GETDATE() AND (DATEADD(DAY, 1, GETDATE()))
       THEN 'You made it up to here, this means a lot to me. Thank you!.
             I am excited to bring my skills and experience to your team!'
       ELSE 'Thanks for considering my application. Have a great day!'
     END AS 'Best regards, Ivaylo Penchev'





