-- ------------------------------------------------------
-- SETUP
-- ------------------------------------------------------

--@block
-- Shows all available databases
show databases;

--@block
-- We select the "ClassicModels" database and list the tables it's composed of
use ClassicModels
show tables;


-- ------------------------------------------------------
-- QUESTIONS:
-- ------------------------------------------------------

--@block
-- List the customers in the United States with a credit limit higher than \$1000.
select customerNumber, customerName, CreditLimit
from Customers 
where creditLimit > 1000 
and country = 'USA'
order by creditLimit DESC;


--@block
-- List the employee codes for sales representatives of customers in Spain, France and Italy.
DROP table if exists Employee_Subset;
CREATE TEMPORARY TABLE Employee_Subset AS 
select employeeNumber from Employees join Offices on Employees.officeCode = Offices.officeCode
where jobTitle = 'Sales Rep' OR jobTitle = 'Sales Representative'
AND Offices.country in ('Spain', 'France', 'Italy');
select * from Employee_Subset


--@block
-- Make another query to list the names and email addresses of those employees.
select email from Employees JOIN Employee_Subset
on Employees.employeeNumber = Employee_Subset.employeeNumber;

 
--@block
-- Change the job title "Sales Rep" to "Sales Representative"
UPDATE Employees
SET jobTitle='Sales Representative' 
WHERE jobTitle='Sales Rep';

--@block
-- Delete the entries for Sales Representatives working in London.
SET FOREIGN_KEY_CHECKS =0;

DELETE Employees 
FROM Employees LEFT JOIN
Offices on Employees.officeCode = Offices.officeCode
 where Employees.jobTitle='Sales Representative' 
 and Offices.city = 'London';

SET FOREIGN_KEY_CHECKS=1;

--@block
-- Show a list of employees who are not sales representatives
select employeeNumber, lastName, firstName, jobTitle
from Employees
where NOT jobTitle ='Sales Representative';

--@block
-- Show a list of customers with "Toys" in their name
select customerName from Customers 
where customerName LIKE '%Toys%';

--@block
-- List the 5 most expensive products from the "Planes" product line
select productCode, productName, MSRP 
from Products 
where productLine = 'Planes' 
order by MSRP DESC limit 5;


-- @block
-- Identify the products that are about to run out of stock (quantity in stock < 100)
select productCode, productName, quantityInStock 
from Products 
where quantityInStock < 100;

--@block
-- list 10 products in the "Motorcycles" category with the lowest buy price and more than 1000 units in stock:

select productCode, ProductName, MSRP from Products 
where quantityInStock > 1000
AND productLine = 'Motorcycles'
order by MSRP limit 10;

--@block
-- Prepare a list of offices sorted by country, state, city.
select * from Offices
order by country,  state, city;


--@block
-- How many employees are there in the company?
select count (employeeNumber) from Employees;


-- @block
-- What is the total of payments received?
select format (
    (select SUM(amount) from Payments), 'c', 'en-US') as 'Total Payment';
 
--@block
-- List the products in each product line.
select productLine, productName from Products
ORDER by productLine;


--@block
-- How many products in each product line?
select productLine, COUNT (productName) from Products
group by productLine;

--@block   
-- List all payments greater than twice the average payment.
select amount 
FROM Payments 
WHERE  
    amount > (select avg (amount) from Payments)
order by amount desc;

--@block
-- What is the average percentage markup of the MSRP on buyPrice?
select ROUND 
(
    (select avg ((MSRP - buyPrice)/buyPrice *100)
from Products), 
2
);

--@block
-- Report the name and city of customers who don't have sales representatives?
 select customerName from Customers 
 where salesRepEmployeeNumber IS NULL;
