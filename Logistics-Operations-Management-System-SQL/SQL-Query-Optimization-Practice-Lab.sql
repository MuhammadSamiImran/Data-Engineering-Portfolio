CREATE TABLE Employees(
employee_ID INT,
employee_name VARCHAR(50),
department_id int,
position VARCHAR(50),
salary DECIMAL(10,2))

INSERT INTO Employees VALUES
(1,'Alice Johnson',101,'Software Engineer',70000),
(2,'Bob Smith',102,'Data Scientist',80000),
(3,'Carol White',103,'Project Manager',75000),
(4,'David Brown',104,'Quality Assurance',60000),
(5,'Eva Green',105,'HR Specialist',55000),
(6,'Frank Martin',101,'Software Engineer',70000),
(3,'Carol White',103,'Project Manager',75000),
(4,'David Brown',104,'Quality Assurance',60000)

-- Remove duplicate values from employee table
SELECT DISTINCT * 
FROM EMPLOYEES


-- Find out duplicate values from employee table
SELECT * FROM EMPLOYEES
WHERE employee_ID IN (
SELECT employee_ID FROM EMPLOYEES
GROUP BY employee_ID
HAVING COUNT(employee_ID) > 1)


-- Find out highest earning employee based on each position
SELECT DISTINCT * FROM EMPLOYEES
WHERE salary IN ( SELECT MAX(salary) FROM EMPLOYEES GROUP BY position)

-- Get top 3 highest earning employees
WITH CTE AS(SELECT DISTINCT * FROM EMPLOYEES)
SELECT TOP 3 * FROM CTE
ORDER BY salary DESC

-- Get top 3 lowest earning employees
WITH CTE AS(SELECT DISTINCT * FROM EMPLOYEES)
SELECT TOP 3 * FROM CTE
ORDER BY salary ASC







CREATE TABLE Employees_Data (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(50),
    Salary INT,
    City NVARCHAR(50)
);

INSERT INTO Employees_Data (EmpID, EmpName, Department, Salary, City) VALUES
(1, 'Alice Johnson', 'Engineering', 75000, 'New York'),
(2, 'Bob Smith', 'Data Science', 85000, 'San Francisco'),
(3, 'Carol White', 'Human Resources', 65000, 'Chicago'),
(4, 'David Brown', 'Engineering', 78000, 'Austin'),
(5, 'Eva Green', 'Marketing', 70000, 'Seattle'),
(6, 'Frank Martin', 'Data Science', 82000, 'New York'),
(7, 'Grace Lee', 'Finance', 90000, 'Los Angeles'),
(8, 'Harry Clark', 'Sales', 72000, 'Chicago'),
(9, 'Ivy Baker', 'Human Resources', 67000, 'Austin'),
(10, 'Jack Wilson', 'Marketing', 71000, 'San Francisco'),
(11, 'Karen Evans', 'Engineering', 76000, 'Seattle'),
(12, 'Leo Adams', 'Data Science', 84000, 'New York'),
(13, 'Mia Scott', 'Finance', 88000, 'Los Angeles'),
(14, 'Nate Perry', 'Sales', 74000, 'Chicago'),
(15, 'Olivia Cooper', 'Engineering', 78000, 'Austin')


-- Find out 2nd highest salary employee 
WITH CTE AS (
SELECT *, ROW_NUMBER() OVER(ORDER BY salary DESC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE
WHERE RowNum = 2

-- Find out 2nd lowest salary employee 
WITH CTE AS (
SELECT *, ROW_NUMBER() OVER(ORDER BY salary ASC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE
WHERE RowNum = 2

-- Find out 2nd highest salary based on each department
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER( PARTITION BY Department ORDER BY salary DESC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE
WHERE RowNum = 2

-- Find out 3rd lowest salary based on each location
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY City ORDER BY salary ASC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE
WHERE RowNum = 3

-- Find out bottom 2 salary based on each location
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY City ORDER BY salary ASC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE
WHERE RowNum IN (1,2)

-- Find out top 2 highest salary based on each department
WITH CTE AS(
SELECT *,ROW_NUMBER() OVER(PARTITION BY Department ORDER BY salary DESC) AS RowNum
FROM Employees_Data)
SELECT * FROM CTE
WHERE RowNum IN (1,2)
