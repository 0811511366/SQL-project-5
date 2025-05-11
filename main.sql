DROP TABLE IF EXISTS Salesman;
CREATE TABLE Salesman (
    SalesmanID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50),
    Commission DECIMAL(5,2)
);

INSERT INTO Salesman (SalesmanID, Name, City, Commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13),
(5003, 'Lauson Hen', 'San Jose', 0.12);

SELECT * FROM Salesman;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    OrderNumber INT PRIMARY KEY,
    PurchaseAmount DECIMAL(10,2),
    OrderDate DATE,
    CustomerID INT,
    SalesmanID INT,
    FOREIGN KEY (SalesmanID) REFERENCES Salesman(SalesmanID)
);

INSERT INTO Orders (OrderNumber, PurchaseAmount, OrderDate, CustomerID, SalesmanID) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5001),
(70002, 65.26, '2012-10-05', 3002, 5003),
(70004, 110.5, '2012-08-17', 3009, 5007),
(70007, 948.5, '2012-09-10', 3005, 5005),
(70005, 2400.6, '2012-07-27', 3007, 5006);

SELECT * FROM Orders;

DROP TABLE IF EXISTS Customer;
CREATE TABLE IF NOT EXISTS Customer (
    customer_id TEXT PRIMARY KEY,
    cust_name TEXT,
    city TEXT,
    grade INTEGER,
    Salesman_id INT,
    FOREIGN KEY (Salesman_id) REFERENCES Salesman(SalesmanID)
);

INSERT INTO Customer (customer_id, cust_name, city, grade, Salesman_id) VALUES
('3002', 'Nick Rimando', 'New York', 100, 5001),
('3007', 'Brad Davis', 'New York', 200, 5001),
('3005', 'Graham Zusi', 'California', 200, 5002),
('3008', 'Julian Green', 'London', 300, 5002),
('3004', 'Fabian Johnson', 'Paris', 300, 5006),
('3009', 'Geoff Cameron', 'Berlin', 100, 5003),
('3003', 'Jozy Altidore', 'Moscow', 200, 5007),
('3001', 'Brad Guzan', 'London', NULL, 5005);
SELECT * FROM Customer;

--match customer and sales man by city
DROP TABLE IF EXISTS SalesmanCustomerMatch;

SELECT customer.cust_name, salesman.name, salesman.city
FROM Customer
JOIN Salesman
  ON LOWER(Customer.city) = LOWER(Salesman.city);
--Linking salesman with customers
DROP TABLE IF EXISTS CustomerSalesmanLINK;
CREATE TABLE CustomerSalesmanLINK AS
SELECT
Customer.cust_name,
SalesMan.Name AS Salesman_name,
Salesman.City
FROM
 Customer
JOIN
 Salesman
ON
Customer.Salesman_id=Salesman.SalesmanID;
SELECT * FROM CustomerSalesmanLINK;

--match order where customer city does not match salesman city
DROP TABLE IF EXISTS OrderMatch;
CREATE TABLE OrderMatch AS
SELECT
Orders.OrderNumber,
Customer.cust_name,
Salesman.Name AS Salesman_name,
Salesman.City AS Salesman_City,
Customer.city AS Customer_city,
Orders.PurchaseAmount
FROM
Orders
JOIN
Customer ON Orders.CustomerID=Customer.customer_id
JOIN
Salesman ON Orders.SalesmanID=Salesman.SalesmanID
WHERE
  LOWER(Customer.city) <>LOWER(Salesman.city);
SELECT * FROM OrderMatch;

DROP TABLE IF EXISTS OrderAndCustomer;
CREATE TABLE OrderAndCustomer AS
SELECT
Orders.OrderNumber,
Orders.PurchaseAmount,
Orders.OrderDate,
Customer.cust_name
FROM
Orders
JOIN
Customer ON Orders.CustomerID=Customer.customer_id;
SELECT * FROM OrderAndCustomer;

--customer with grades
DROP TABLE IF EXISTS CustomerGrade;
CREATE TABLE CustomerGrade AS
SELECT Customer.cust_name AS "Customer",Customer.grade AS "Grade"
FROM 
Orders
JOIN 
 Salesman ON Orders.SalesmanID=Salesman.SalesmanID
JOIN
 Customer ON Orders.CustomerID=Customer.customer_id
WHERE
 Customer.grade IS NOT NULL;

SELECT * FROM CustomerGrade;

--orders with specific dates
DROP TABLE IF EXISTS OrdersOnDate;

CREATE TABLE OrdersOnDate AS
SELECT
    o.OrderNumber,
    o.PurchaseAmount,
    o.OrderDate,
    c.cust_name,
    c.grade
FROM Orders o
JOIN Customer c ON o.CustomerID = c.customer_id
WHERE o.OrderDate = '2012-10-05';

SELECT * FROM OrdersOnDate;
