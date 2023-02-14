

-- Here are some of the exercises I did while working through the Microsoft SQL Server T-SQL Fundamentals 2012 book


USE TSQL2012
GO



-- 1. Write a query against the Sales.Orders table that returns orders placed in June 2007.
--   Tables involved: TSQL2012 database and the Sales.Orders table


SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate >= '20070601'
AND orderdate < '20070701';


-- 2. Write a query against the Sales.Orders table that returns orders placed on the last day of the month.
--   Tables involved: TSQL2012 database and the Sales.Orders table


SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);

   -- The first solution uses the EOMONTH function, which was introduced in T-SQL 2012.
   
   -- The second solution uses the combination of the DATEADD and DATEDIFF functions, which was possible before T-SQL 2012.

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = DATEADD(month, DATEDIFF(month, '19991231', orderdate), '19991231');



-- 3. Write a query against the HR.Employees table that returns employees with last name containing the letter a twice or more.
-- Tables involved: TSQL2012 database and the HR.Employees table

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE '%a%a%';


-- 4. Write a query against the Sales.OrderDetails table that returns orders with total value (quantity * unit-
-- price) greater than 10,000, sorted by total value.
-- Tables involved: TSQL2012 database and the Sales.OrderDetails table

SELECT orderid, SUM(qty*unitprice) AS totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty*unitprice) > 10000
ORDER BY totalvalue DESC;


-- 5. Write a query against the Sales.Orders table that returns the three shipped-to countries with the highest average freight in 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20070101' AND orderdate < '20080101'
GROUP BY shipcountry
ORDER BY avgfreight DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;


-- 6. Write a query against the Sales.Orders table that calculates row numbers for orders based on order
-- date ordering (using the order ID as the tiebreaker) for each customer separately.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT custid, orderdate, orderid,
ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, rownum;


-- 7. Using the HR.Employees table, figure out the SELECT statement that returns for each employee the
-- gender based on the title of courtesy. For ‘Ms. ‘ and ‘Mrs.’ return ‘Female’; for ‘Mr. ‘ return ‘Male’; and
-- in all other cases (for example, ‘Dr. ‘) return ‘Unknown’.
-- Tables involved: TSQL2012 database and the HR.Employees table

SELECT empid, firstname, lastname, titleofcourtesy,
CASE
WHEN titleofcourtesy IN('Ms.', 'Mrs.') THEN 'Female'
WHEN titleofcourtesy = 'Mr.' THEN 'Male'
ELSE 'Unknown'
END AS gender
FROM HR.Employees;


-- 8. Write a query against the Sales.Customers table that returns for each customer the customer ID and
-- region. Sort the rows in the output by region, having NULL marks sort last (after non-NULL values).
-- Note that the default sort behavior for NULL marks in T-SQL is to sort first (before non-NULL values).
-- Tables involved: TSQL2012 database and the Sales.Customers table

SELECT custid, region
FROM Sales.Customers
ORDER BY
CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;




-- 9. Write a query that generates five copies of each employee row.
-- Tables involved: HR.Employees and dbo.Nums

SELECT E.empid, E.firstname, E.lastname, N.n
FROM HR.Employees AS E
CROSS JOIN dbo.Nums AS N
WHERE N.n <= 5
ORDER BY n, empid;


-- 10. Write a query that returns a row for each employee and day in the range June 12, 2009 through June 16, 2009.
-- Tables involved: HR.Employees and dbo.Nums

SELECT E.empid,
DATEADD(day, D.n - 1, '20090612') AS dt
FROM HR.Employees AS E
CROSS JOIN dbo.Nums AS D
WHERE D.n <= DATEDIFF(day, '20090612', '20090616') + 1
ORDER BY empid, dt;


-- 11. Return United States customers, and for each customer return the total number of orders and total quantities.
-- Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails

SELECT C.custid, COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
JOIN Sales.Orders AS O
ON O.custid = C.custid
JOIN Sales.OrderDetails AS OD
ON OD.orderid = O.orderid
WHERE C.country = N'USA'
GROUP BY C.custid;



-- 12. Return customers and their orders, including customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid;



-- 13. Return customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

SELECT C.custid, C.companyname
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid
WHERE O.orderid IS NULL;



-- 14. Return customers with orders placed on February 12, 2007, along with their orders.
-- Tables involved: Sales.Customers and Sales.Orders

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
JOIN Sales.Orders AS O
ON O.custid = C.custid
WHERE O.orderdate = '20070212';



-- 15. Return customers with orders placed on February 12, 2007, along with their orders.
-- Also return customers who didn’t place orders on February 12, 2007.
-- Tables involved: Sales.Customers and Sales.Orders

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid
AND O.orderdate = '20070212';



-- 16.  Return all customers, and for each return a Yes/No value depending on whether the customer placed an order on February 12, 2007.
-- Tables involved: Sales.Customers and Sales.Orders

SELECT DISTINCT C.custid, C.companyname,
CASE WHEN O.orderid IS NOT NULL THEN 'Yes' ELSE 'No' END AS [HasOrderOn20070212]
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid
AND O.orderdate = '20070212';






--This is just a small part of my learning path.


