 /*****
 DATA CLEANING
 ******/
 #table information
DESC classicmodels.customers;
DESC classicmodels.employees;
DESC classicmodels.offices;
DESC classicmodels.orderdetails;
DESC classicmodels.orders;
DESC classicmodels.payments;
DESC classicmodels.productlines;
DESC classicmodels.payments;

 -- 1. Finding the total number of customers and orders.
 
 select count(customerNumber) AS Total_number_of_customers
 from classicmodels.customers;
 
  select count(orderNumber) AS Total_number_of_customers
 from classicmodels.orders;
 
 -- There are total 120 customers and 326 orders in the dataset.
 
 -- 2. Checking for duplicate rows 
 
 select customerNumber, count(customerNumber) 
 from classicmodels.customers
 group by customerNumber
 having count(customerNumber) > 1;
 
select orderNumber, count(orderNumber) 
from classicmodels.orders
group by orderNumber
having count(orderNumber) > 1;

 select productCode, count(productCode) 
 from classicmodels.products
 group by productCode
 having count(productCode) > 1;
 
 -- No duplicates are found in the data.
 
-- 4. Dropping unwanted columns from the dataset.
/* Customers Table */
alter table customers
drop column phone, 
drop column addressLine1, 
drop column addressLine2, 
drop column city, 
drop column state, 
drop column postalCode;

select * from customers;

/*Employess Table*/
alter table employees
drop column extension,
drop column email;

select * from employees;

/* Offices Table */
alter table offices
drop column phone,
drop column addressLine1,
drop column addressLine2,
drop column territory,
drop column state,
drop column postalCode;

select * from offices;

/* Orders Table */
alter table orders
drop column requiredDate,
drop column shippedDate,
drop column comments;

select * from orders;

/* Product Lines Table*/
alter table productlines
drop column textDescription,
drop column htmlDescription,
drop column image;

select * from productlines;

/* Products table */
alter table products
drop column productScale,
drop column productDescription;

select * from products;
 -- 3. Checking for NUll Values.

-- Checking for NULL Values --

select * from customers;
SELECT 
COUNT(CASE WHEN customerName IS NULL THEN 1 END) as customerName_null,
COUNT(CASE WHEN customerNumber is Null then 1 End) as customerNumber_null,
COUNT(CASE WHEN contactLastName is Null then 1 End) as contact_null,
COUNT(CASE WHEN contactFirstName is Null then 1 End) as First_null,
COUNT(CASE WHEN country is Null then 1 End) as country_null,
COUNT(CASE WHEN salesRepEmployeeNumber is Null then 1 End) as salesRepEmployeeNumber_null,
COUNT(CASE WHEN creditLimit is Null then 1 End) as creditLimit_null
FROM classicmodels.customers;

/* There are 22 Null values in salesRepEmployeeNumber columns, its is a foreign key and we connot
impute it with 0 or ther value as we might face data intergrity issue. */
---------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from employees;
SELECT 
COUNT(CASE WHEN employeeNumber IS NULL THEN 1 END) as employeeNumber_null,
COUNT(CASE WHEN lastName is Null then 1 End) as lastName_null,
COUNT(CASE WHEN firstName is Null then 1 End) as firstName_null,
COUNT(CASE WHEN officeCode is Null then 1 End) as Office_code_null,
COUNT(CASE WHEN reportsTo is Null then 1 End) as reports_null,
COUNT(CASE WHEN jobTitle is Null then 1 End) as jobTitle_null
FROM classicmodels.employees;

-- There is only 1 Null value present in the reportsTo, so replace it with 0.*/

update employees
set reportsTo = 0001
where reportsTo = Null;

select*from employees;
--------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from offices;
SELECT 
COUNT(CASE WHEN officeCode IS NULL THEN 1 END) as officeCode_null,
COUNT(CASE WHEN city is Null then 1 End) as city_null,
COUNT(CASE WHEN country is Null then 1 End) as country_null
FROM classicmodels.offices;

-- There are no null values.alter.
---------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from orderdetails;
SELECT 
COUNT(CASE WHEN orderNumber IS NULL THEN 1 END) as orderNumber_null,
COUNT(CASE WHEN orderDate is Null then 1 End) as Date_null,
COUNT(CASE WHEN status is Null then 1 End) as status_null,
COUNT(CASE WHEN customerNumber is Null then 1 End) as price_null
FROM classicmodels.orders;

-- There are no null values.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from orders;
SELECT 
COUNT(CASE WHEN orderNumber IS NULL THEN 1 END) as orderNumber_null,
COUNT(CASE WHEN productCode is Null then 1 End) as Code_null,
COUNT(CASE WHEN quantityOrdered is Null then 1 End) as quantity_null,
COUNT(CASE WHEN priceEach is Null then 1 End) as price_null,
COUNT(CASE WHEN orderLineNumber is Null then 1 End) as orderLineNumber_null
FROM classicmodels.orderdetails;

-- There are no null values.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from payments;
SELECT 
COUNT(CASE WHEN customerNumber IS NULL THEN 1 END) as customerNumber_null,
COUNT(CASE WHEN checkNumber is Null then 1 End) as checknumber_null,
COUNT(CASE WHEN paymentDate is Null then 1 End) as date_null,
COUNT(CASE WHEN amount is Null then 1 End) as amount_null
FROM classicmodels.payments;

-- There are no null values.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from products;
SELECT 
COUNT(CASE WHEN productName IS NULL THEN 1 END) as productName_null,
COUNT(CASE WHEN productCode is Null then 1 End) as Code_null,
COUNT(CASE WHEN productLine is Null then 1 End) as productLine_null,
COUNT(CASE WHEN productVendor is Null then 1 End) as productVendor_null,
COUNT(CASE WHEN quantityInStock is Null then 1 End) as quantitystock_null,
COUNT(CASE WHEN buyPrice is Null then 1 End) as buyPrice_null,
COUNT(CASE WHEN MSRP is Null then 1 End) as MSRP_null
FROM classicmodels.products;

-- There are no Null values.

/*****
Data Analysis
******/

-- Compute Profit, Cost Price and Sales Price.

select * from products;

with t1 as 
(select*, quantityInStock*MSRP as Sales,
quantityInStock*buyPrice as Cost,
(quantityInStock*MSRP)-(quantityInStock*buyPrice) as Profit from products)
select sum(sales) as Total_Sales, sum(Profit) as Total_Profit
from t1;

-- Total Sales is 56287967.27 and Total_Profit is 25753651.04.
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Total number of Product Lines, Product Vendors, Product Names, 

select count(productLine) as Total_Product_Lines
from productlines;
-- There are a total of 7 product lines.
---------------------------------------------------------------------
select distinct(count(productVendor)) as Total_Product_Vendors
from products;
-- There are total 110 product vendors.
---------------------------------------------------------------------
select count(productName) as Total_Products
from products;
-- There are total 110 Products
---------------------------------------------------------------------
-- Customers by their Credit limit.

select customerNumber, customerName, creditLimit
from customers 
order by creditLimit DESC
LIMIT 5;
-- Euro+ Shopping Channel, Mini Gifts Distributors Ltd., Vida Sport, Ltd, Muscle Machine Inc, AV Stores, Co. are top 5 customers according their credit limit.
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Top 5 customers who ordered maximum quantity of products.
select customerName Customer_Name, count(distinct(orderNumber)) as Order_Count
from customers c
left join orders o on 
c.customerNumber = o.customerNumber
group by customerName
order by count(distinct(orderNumber)) DESC
limit 5;
/*  Euro+ Shopping Channel, Mini Gifts Distributors Ltd., Danish Wholesale Imports, Australian Collectors, Co. and Down Under Souveniers, Inc
are the top 5 customers with highest orders.*/
---------------------------------------------------------------------------------------------------------------------------------------------------
-- Number of orders which are shipped and cancelled.

select count(status) as Shipped_Order
from orders
where status = "Shipped";

select count(status) as Cancelled_Order
from orders
where status = "Cancelled";
-- There are 303 shipped orders and 6 cancelled orders.
---------------------------------------------------------------------------------------------------------------------------------------------------
-- Top 5 Products with highest quantity in stock.
select productName, quantityInStock as Total_QuantityInStock
from products
order by quantityInStock DESC
limit 5;
/* 2002 Suzuki XREO, 1995 Honda Civic, America West Airlines B757-200, 2002 Chevy Corvette and 1932 Model A Ford J-Coupe are the products
with highest quantity in stock.*/
---------------------------------------------------------------------------------------------------------------------------------------------------
-- Total Sales and Profit by Product Name.
with t1 as 
(select*, quantityInStock*MSRP as Sales,
quantityInStock*buyPrice as Cost,
(quantityInStock*MSRP)-(quantityInStock*buyPrice) as Profit from products)

select productName as Product_Name, sum(sales) as Total_Sales, sum(Profit) as Total_Profit
from t1
group by productname
order by Total_Profit and Total_Sales DESC
limit 5;
/* 1952 Alpine Renault 1300, 2003 Harley-Davidson Eagle Drag Bike, 1969 Harley Davidson Ultimate Chopper, 1996 Moto Guzzi 1100i and 1972 Alfa Romeo GTA
are the products which are giving highest profit.*/
---------------------------------------------------------------------------------------------------------------------------------------------------
-- Order count per year
with t2 as 
(select orderNumber, year(orderDate) as Order_Year
from orders)

select Order_Year, count(*) Order_Count from t2
group by Order_Year;
-- Highest orders are placed in year 2004 followed by 2003 and 2005.
---------------------------------------------------------------------------------------------------------------------------------------------------
-- Monthly order count for all years combined
with t1 as 
(select orderNumber, monthname(orderDate) as Order_month
from orders)

select Order_month, count(*) Order_Count from t1
group by Order_month;
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Customers who paid highest amount.
select customerName, sum(amount) As Highest_Paid_Amount
from payments p
left join customers c
on p.customerNumber = c.customerNumber
group by customerName
order by sum(amount) DESC
limit 5;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Total Sales and Profit by Product Lines.
with t1 as 
(select*, quantityInStock*MSRP as Sales,
quantityInStock*buyPrice as Cost,
(quantityInStock*MSRP)-(quantityInStock*buyPrice) as Profit from products)

select productLine, sum(sales) as Total_Sales, sum(Profit) as Total_Profit
from t1
group by productLine
order by Total_Profit and Total_Sales DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Top 10 payments by customername.
with t1 as
(select concat(contactFirstName, "", contactLastName) as Customer_Name, 
sum(amount) as payments from customers c
join payments as p
on c.customernumber = p.customerNumber
group by concat(contactFirstName, "", contactLastName))

select*from t1
order by payments DESC limit 10;
