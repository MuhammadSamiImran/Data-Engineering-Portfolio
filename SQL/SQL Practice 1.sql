/* =====================================================
   SECTION 1: TABLE CREATION + CONSTRAINTS
===================================================== */

-- Q: Create Departments table (drop if exists)
-- (Concepts: OBJECT_ID, DROP TABLE, IDENTITY, UNIQUE, DEFAULT)

IF OBJECT_ID('Departments','U') IS NOT NULL
BEGIN
    PRINT('Departments Table Already Exists')
    DROP TABLE Departments

    CREATE TABLE Departments(
        DeptID INT PRIMARY KEY IDENTITY(10,1),
        DeptName VARCHAR(20) UNIQUE NOT NULL,
        Location VARCHAR(20) DEFAULT('Headquarters')
    )
END
ELSE
BEGIN
    PRINT('Table Created')
    CREATE TABLE Departments(
        DeptID INT PRIMARY KEY IDENTITY(10,1),
        DeptName VARCHAR(20) UNIQUE NOT NULL,
        Location VARCHAR(20) DEFAULT('Headquarters')
    )
END


-- Q: Create Employees table with constraints
-- (Concepts: FOREIGN KEY, CHECK, UNIQUE)

IF OBJECT_ID('Employees','U') IS NOT NULL
BEGIN    
    PRINT('Employees Table Already Exists')
    DROP TABLE Employees

    CREATE TABLE Employees(
        EmpID INT PRIMARY KEY IDENTITY(1,1),
        EmpName VARCHAR(15) NOT NULL,
        Email VARCHAR(20) UNIQUE CHECK(Email LIKE '%@%'),
        Salary FLOAT CHECK(Salary >= 30000),
        DepID INT CONSTRAINT FK_DE FOREIGN KEY REFERENCES Departments(DeptID)
    )
END
ELSE
BEGIN
    CREATE TABLE Employees(
        EmpID INT PRIMARY KEY IDENTITY(1,1),
        EmpName VARCHAR(15) NOT NULL,
        Email VARCHAR(20) UNIQUE CHECK(Email LIKE '%@%'),
        Salary FLOAT CHECK(Salary >= 30000),
        DepID INT CONSTRAINT FK_DE FOREIGN KEY REFERENCES Departments(DeptID)
    )
END


/* =====================================================
   SECTION 2: INSERT + BASIC JOIN
===================================================== */

-- Q: Insert sample data
-- (Concepts: INSERT)

INSERT INTO Departments (DeptName,Location) VALUES
('IT','Lahore'),
('HR','Islamabad'),
('Finance','Karachi')

INSERT INTO Employees (EmpName,Email,Salary,DepID) VALUES
('Ali','Ali@.com',31000,10),
('Sami','Sami@.com',40000,10),
('Asad','Asad@.com',37000,11),
('Mahad','Mahad@.com',35000,12)


-- Q: Show Employee Name with Department Name
-- (Concepts: INNER JOIN)

SELECT Employees.EmpName, Departments.DeptName
FROM Employees
INNER JOIN Departments ON Employees.DepID = Departments.DeptID


/* =====================================================
   SECTION 3: UPDATE + JOIN
===================================================== */

-- Q: Increase salary by 10% for IT department
-- (Concepts: UPDATE with JOIN)

UPDATE e 
SET Salary = Salary + Salary * 0.1
FROM Employees e
JOIN Departments d ON e.DepID = d.DeptID
WHERE d.DeptName = 'IT'


/* =====================================================
   SECTION 4: FOREIGN KEY ALTER + CASCADE BEHAVIOR
===================================================== */

-- Q: Modify foreign key to SET DEFAULT on delete
-- (Concepts: ALTER TABLE, FOREIGN KEY)

ALTER TABLE Employees DROP CONSTRAINT FK_DE

ALTER TABLE Employees
ADD CONSTRAINT FK_DE FOREIGN KEY (DepID)
REFERENCES Departments(DeptID)
ON DELETE SET DEFAULT

-- Test delete
DELETE FROM Departments
WHERE DeptName = 'HR'


/* =====================================================
   SECTION 5: AGGREGATION PRACTICE
===================================================== */

CREATE TABLE MonthlySales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName NVARCHAR(100),
    Department NVARCHAR(50),
    Region NVARCHAR(50),
    SaleAmount DECIMAL(18, 2),
    SaleDate DATE,
    ProductCategory NVARCHAR(50)
);

INSERT INTO MonthlySales VALUES
('Ali', 'Software', 'North', 55000, '2023-01-15', 'Cloud'),
('Sami', 'Software', 'North', 12000, '2023-01-20', 'Hardware'),
('Asad', 'Hardware', 'South', 45000, '2023-02-10', 'Hardware'),
('Mahad', 'Software', 'East', 90000, '2023-02-15', 'Cloud'),
('Sami', 'Software', 'North', 60000, '2023-03-05', 'Cloud'),
('Ali', 'Software', 'North', 5000, '2023-03-10', 'Support'),
('Sara', 'Marketing', 'West', 25000, '2023-03-12', 'Ads');


-- Q: Employees with total sales < 70000 (Software dept)
-- (Concepts: GROUP BY, HAVING)

SELECT EmployeeName, SUM(SaleAmount) AS TotalSales
FROM MonthlySales
WHERE Department = 'Software'
GROUP BY EmployeeName
HAVING SUM(SaleAmount) < 70000


-- Q: Regions with avg sales > 30000
-- (Concepts: GROUP BY, HAVING, ORDER BY)

SELECT Region, COUNT(*) AS TransactionCount, AVG(SaleAmount) AS AverageRevenue
FROM MonthlySales
GROUP BY Region
HAVING AVG(SaleAmount) > 30000
ORDER BY TransactionCount DESC


-- Q: Max & Min sales for Cloud category
-- (Concepts: LIKE, GROUP BY)

SELECT ProductCategory, MAX(SaleAmount), MIN(SaleAmount)
FROM MonthlySales
WHERE ProductCategory LIKE 'C%'
GROUP BY ProductCategory
HAVING MIN(SaleAmount) < 10000


/* =====================================================
   SECTION 6: NULL HANDLING + COALESCE
===================================================== */

-- Q: Get primary contact number
-- (Concepts: COALESCE)

SELECT CustomerName,
COALESCE(MobilePhone, WorkPhone, HomePhone, 'No Phone Available') AS PrimaryContact
FROM CustomerLeads


-- Q: Top region with purchase > 500
-- (Concepts: GROUP BY, HAVING, TOP)

SELECT DISTINCT TOP 1 Region
FROM CustomerLeads
WHERE LastPurchase > 500
GROUP BY Region
HAVING Region != 'South'


-- Q: Top 3 customers by purchase
-- (Concepts: COALESCE, ORDER BY)

SELECT TOP 3 *, COALESCE(LastPurchase,0.00)
FROM CustomerLeads
WHERE MarketingOptIn = 1
ORDER BY LastPurchase DESC


/* =====================================================
   SECTION 7: PROJECT + PAYROLL
===================================================== */

-- Q: Assign active manager
-- (Concepts: COALESCE)

SELECT ProjectName,
COALESCE(LeadDeveloper, BackupDeveloper, 'Manager Unassigned') AS ActiveManager
FROM Project_Staging


-- Q: Avg salary for overtime employees
-- (Concepts: GROUP BY, HAVING)

SELECT OvertimeStatus, AVG(HourlyRate) AS AverageHourlyRate, COUNT(*) AS TotalEmployees
FROM Employee_Payroll
WHERE OvertimeStatus = 1
GROUP BY OvertimeStatus
HAVING COUNT(*) > 1


-- Q: Top 2 project budgets
-- (Concepts: TOP, ORDER BY)

SELECT DISTINCT TOP 2 Budget
FROM Project_Staging
WHERE Budget IS NOT NULL
ORDER BY Budget DESC


/* =====================================================
   SECTION 8: UNION + WINDOW FUNCTIONS
===================================================== */

-- Q: Combine store data
-- (Concepts: UNION)

SELECT * FROM Store_North
UNION
SELECT * FROM Store_South


-- Q: Category total using window function
-- (Concepts: UNION, OVER, PARTITION BY)

SELECT Product, Category, Amount,
SUM(Amount) OVER(PARTITION BY Category) AS CategoryTotal
FROM Store_North
UNION
SELECT Product, Category, Amount,
SUM(Amount) OVER(PARTITION BY Category)
FROM Store_South


-- Q: Running total
-- (Concepts: WINDOW FUNCTION)

SELECT Product, Amount, SaleDate,
SUM(Amount) OVER(PARTITION BY Amount ORDER BY SaleDate) AS RunningTotal
FROM Store_North


/* =====================================================
   SECTION 9: RANKING FUNCTIONS
===================================================== */

-- Q: Compare ranking functions
-- (Concepts: ROW_NUMBER, RANK, DENSE_RANK)

SELECT ItemName, Category, Price,
ROW_NUMBER() OVER(ORDER BY Price DESC) AS Row_Num,
RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS Rank_With_Gaps,
DENSE_RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS Dense_Rank_No_Gaps
FROM Inventory


/* =====================================================
   SECTION 10: LAG & LEAD (TIME ANALYSIS)
===================================================== */

-- Q: Stock price analysis
-- (Concepts: LAG, LEAD, CASE)

SELECT StockSymbol, TradeDate, Price,
LAG(Price) OVER(PARTITION BY StockSymbol ORDER BY TradeDate) AS PrevPrice,
LEAD(Price,1,0) OVER(PARTITION BY StockSymbol ORDER BY TradeDate) AS NextDayPrice,
CASE 
    WHEN Price - LAG(Price) OVER(PARTITION BY StockSymbol ORDER BY TradeDate) > 5 THEN 'STRONG BUY'
    WHEN Price - LAG(Price) OVER(PARTITION BY StockSymbol ORDER BY TradeDate) < -5 THEN 'STRONG SELL'
    ELSE 'HOLD'
END AS Signal
FROM StockTrades


/* =====================================================
   SECTION 11: CTE + BUSINESS LOGIC
===================================================== */

-- Q: Clean completed orders
-- (Concepts: CTE)

WITH CleanOrders AS(
SELECT OrderID, CustomerID, TotalAmount
FROM Raw_Orders
WHERE Status = 'Completed'
)
SELECT Customers.CustomerName, CleanOrders.TotalAmount
FROM CleanOrders
JOIN Customers ON CleanOrders.CustomerID = Customers.CustomerID


-- Q: Customer spending tiers
-- (Concepts: GROUP BY, CASE)

WITH CustomerSpending AS (
SELECT CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Raw_Orders
WHERE Status = 'Completed'
GROUP BY CustomerID
)
SELECT c.CustomerName, cs.TotalSpent,
CASE
    WHEN cs.TotalSpent > 1000 THEN 'Platinum'
    WHEN cs.TotalSpent > 500 THEN 'Gold'
    ELSE 'Silver'
END AS Tier
FROM CustomerSpending cs
JOIN Customers c ON cs.CustomerID = c.CustomerID


-- Q: Daily growth analysis
-- (Concepts: LAG)

WITH DailySales AS (
SELECT OrderDate, SUM(TotalAmount) AS SalesDaily
FROM Raw_Orders
WHERE Status = 'Completed'
GROUP BY OrderDate
)
SELECT OrderDate, SalesDaily,
LAG(SalesDaily) OVER(ORDER BY OrderDate) AS YesterdaySales,
SalesDaily - LAG(SalesDaily) OVER(ORDER BY OrderDate) AS DailyGrowth
FROM DailySales


/* =====================================================
   SECTION 12: VIEW + PROCEDURES
===================================================== */

-- Q: Create executive sales view
-- (Concepts: VIEW)

CREATE VIEW v_ExecutiveSalesSummary AS
SELECT c.CustomerName, r.OrderDate, r.TotalAmount
FROM Customers c
JOIN Raw_Orders r ON c.CustomerID = r.CustomerID
WHERE r.Status = 'Completed'


-- Q: Update order status procedure
-- (Concepts: PROCEDURE)

CREATE PROCEDURE sp_UpdateOrderStatus 
@TargetOrderID INT, 
@NewStatus NVARCHAR(20)
AS
BEGIN
UPDATE Raw_Orders
SET Status = @NewStatus
WHERE OrderID = @TargetOrderID

PRINT('Order ' + CAST(@TargetOrderID AS VARCHAR) + ' updated to ' + @NewStatus)

SELECT * FROM Raw_Orders WHERE OrderID = @TargetOrderID
END


-- Q: Apply discount conditionally
-- (Concepts: VARIABLES, IF)

CREATE PROCEDURE sp_ApplyDiscount @OrderID INT AS
BEGIN
DECLARE @CurrentAmount DECIMAL(10,2)

SELECT @CurrentAmount = TotalAmount
FROM Raw_Orders
WHERE OrderID = @OrderID

IF @CurrentAmount > 1000
BEGIN
    UPDATE Raw_Orders
    SET TotalAmount = TotalAmount * 0.90
    WHERE OrderID = @OrderID

    PRINT('10% discount applied')
END
ELSE
BEGIN
    PRINT('No discount applied')
END
END
