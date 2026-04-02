/* =====================================================
   SECTION 1: TABLE CREATION 
===================================================== */

-- Create Drivers table (Primary Key + Identity + Default)
IF OBJECT_ID('Drivers','U') IS NULL
CREATE TABLE Drivers(
    DriverID INT CONSTRAINT PK_D PRIMARY KEY IDENTITY(1,1),
    DriverName NVARCHAR(20) NOT NULL,
    LicenseType NVARCHAR(10),
    JoiningDate DATE CONSTRAINT D_D DEFAULT GETDATE()
)

-- Create Shipments table (Foreign Key + Check Constraints)
IF OBJECT_ID('Shipments','U') IS NULL
CREATE TABLE Shipments(
    ShipmentID INT CONSTRAINT PK_S PRIMARY KEY IDENTITY(1,1),
    DriverID INT CONSTRAINT FK_SD FOREIGN KEY REFERENCES Drivers(DriverID),
    Weight_KG DECIMAL(10,2) CONSTRAINT CK_W CHECK (Weight_KG > 0),
    Status NVARCHAR(15) CONSTRAINT CH_S CHECK (Status IN ('Pending', 'In Transit', 'Delivered')),
    DeliveryDate DATE
)

-- Create Employees table 
CREATE TABLE Employees(
employee_ID INT,
employee_name VARCHAR(50),
department_id INT,
position VARCHAR(50),
salary DECIMAL(10,2))

/* =====================================================
   SECTION 2: INSERT DATA 
===================================================== */

-- Insert Drivers
INSERT INTO Drivers(DriverName, LicenseType, JoiningDate) VALUES
('Sami','Light','2026-03-16'),
('Ali','Heavy','2025-05-02'),
('Hassan','Light','2022-07-05')

-- Insert Shipments
INSERT INTO Shipments(DriverID, Weight_KG, Status, DeliveryDate) VALUES
(1, 520.00, 'Delivered', '2026-04-01'),
(1, 1500.00, 'In Transit', NULL),
(2, 300.00, 'Delivered', '2026-03-30'),
(3, 750.00, 'Pending', NULL),
(3, 1200.00, 'In Transit', NULL)

--Insert Employees
INSERT INTO Employees VALUES
(1,'Alice Johnson',101,'Software Engineer',70000),
(2,'Bob Smith',102,'Data Scientist',80000),
(3,'Carol White',103,'Project Manager',75000),
(4,'David Brown',104,'Quality Assurance',60000),
(5,'Eva Green',105,'HR Specialist',55000),
(6,'Frank Martin',101,'Software Engineer',70000),
(3,'Carol White',103,'Project Manager',75000),
(4,'David Brown',104,'Quality Assurance',60000)


/* =====================================================
   SECTION 3: BASIC QUERY + FORMAT
===================================================== */

-- Q: Show ShipmentID, DriverName, and DeliveryDate (replace NULL with text)
-- (Concepts: JOIN, COALESCE, CONVERT)
SELECT s.ShipmentID, d.DriverName,
COALESCE(CONVERT(VARCHAR(20), s.DeliveryDate),'Not Delivered Yet') AS DeliveryStatus
FROM Drivers d
JOIN Shipments s ON d.DriverID = s.DriverID


/* =====================================================
   SECTION 4: WINDOW FUNCTIONS
===================================================== */

-- Q: Rank shipments based on Weight (highest first)
-- (Concepts: DENSE_RANK, Window Function)
SELECT *,
DENSE_RANK() OVER(ORDER BY Weight_KG DESC) AS Performance
FROM Shipments


-- Q: Calculate running total weight per driver
-- (Concepts: CTE, Window Function, PARTITION BY)
WITH CTE AS(
SELECT d.DriverName, s.*,
SUM(Weight_KG) OVER(PARTITION BY d.DriverID ORDER BY Weight_KG) AS TotalWeight
FROM Drivers d
JOIN Shipments s ON d.DriverID = s.DriverID)

SELECT * FROM CTE
WHERE TotalWeight > 10000


/* =====================================================
   SECTION 5: VIEW
===================================================== */

-- Q: Create a view for active shipments (not delivered)
-- (Concepts: VIEW, Filtering)
CREATE VIEW v_ActiveShipments AS
SELECT * FROM Shipments
WHERE Status != 'Delivered'

-- View data
SELECT * FROM v_ActiveShipments


/* =====================================================
   SECTION 6: STORED PROCEDURE
===================================================== */

-- Q: Mark shipment as delivered using procedure
-- (Concepts: Stored Procedure, UPDATE)
CREATE PROCEDURE sp_CompleteDelivery @ShipID INT AS
BEGIN
    UPDATE Shipments
    SET Status = 'Delivered'
    WHERE ShipmentID = @ShipID
    PRINT('Shipment '+ CAST(@ShipID AS VARCHAR(10)) + ' Updated to Delivered')
END

EXEC sp_CompleteDelivery 2


/* =====================================================
   SECTION 7: DUPLICATES HANDLING
===================================================== */

-- Q: Remove duplicates (view only)
-- (Concepts: DISTINCT)
SELECT DISTINCT * FROM Employees

-- Q: Find duplicate records
-- (Concepts: GROUP BY, HAVING)
SELECT * FROM Employees
WHERE employee_ID IN (
    SELECT employee_ID
    FROM Employees
    GROUP BY employee_ID
    HAVING COUNT(*) > 1)


/* =====================================================
   SECTION 8: AGGREGATION
===================================================== */

-- Q: Highest earning employee per position
-- (Concepts: GROUP BY, SUBQUERY)
SELECT DISTINCT *
FROM Employees
WHERE salary IN (
    SELECT MAX(salary)
    FROM Employees
    GROUP BY position)


/* =====================================================
   SECTION 9: TOP N QUERIES
===================================================== */

-- Q: Top 3 highest salaries
-- (Concepts: CTE, ORDER BY)
WITH CTE AS(SELECT DISTINCT * FROM Employees)
SELECT TOP 3 * FROM CTE ORDER BY salary DESC

-- Q: Top 3 lowest salaries
WITH CTE AS(SELECT DISTINCT * FROM Employees)
SELECT TOP 3 * FROM CTE ORDER BY salary ASC


/* =====================================================
   SECTION 10: ADVANCED WINDOW FUNCTIONS
===================================================== */

-- Q: Find 2nd highest salary
-- (Concepts: ROW_NUMBER)
WITH CTE AS (
SELECT *, ROW_NUMBER() OVER(ORDER BY salary DESC) AS RowNum
FROM Employees_Data)

SELECT * FROM CTE WHERE RowNum = 2


-- Q: 2nd lowest salary
WITH CTE AS (
SELECT *, ROW_NUMBER() OVER(ORDER BY salary ASC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE WHERE RowNum = 2


-- Q: 2nd highest salary per department
-- (Concepts: PARTITION BY)
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY Department ORDER BY salary DESC) AS RowNum
FROM Employees_Data)

SELECT * FROM CTE WHERE RowNum = 2


-- Q: 3rd lowest salary per city
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY City ORDER BY salary ASC) AS RowNum
FROM Employees_Data)

SELECT * FROM CTE WHERE RowNum = 3


-- Q: Bottom 2 salaries per city
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY City ORDER BY salary ASC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE WHERE RowNum IN (1,2)


-- Q: Top 2 salaries per department
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY Department ORDER BY salary DESC) AS RowNum
FROM Employees_Data)

SELECT * FROM CTE WHERE RowNum IN (1,2)