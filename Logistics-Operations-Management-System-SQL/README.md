#  Logistics Operations Management System (SQL)

This project demonstrates my ability to design and implement a relational database architecture from scratch. It simulates a real-world logistics environment where data integrity and automated reporting are critical.

##  Key Technical Features

### 1. Relational Database Architecture
- **Constraints & Integrity:** Designed tables with `PRIMARY KEY`, `FOREIGN KEY`, and `CHECK` constraints to prevent data corruption.
- **Auto-Automation:** Leveraged `IDENTITY` columns and `DEFAULT` values for streamlined data entry.

### 2. Advanced Analytical Querying
- **Window Functions:** Implemented `DENSE_RANK()` to analyze driver performance based on shipment weight.
- **Common Table Expressions (CTEs):** Used CTEs to calculate cumulative weight totals and filter high-performing assets.
- **LEAD & LAG:** Employed time-series functions to track shipment progression and delivery trends.

### 3. Business Logic & Automation
- **Stored Procedures:** Created `sp_CompleteDelivery` to automate the transition of shipment statuses and log delivery timestamps.
- **Views:** Developed `v_ActiveShipments` to provide a simplified, pre-filtered data layer for business stakeholders.
- **Data Cleaning:** Used `COALESCE` and `CONVERT` to handle missing data and ensure clean reporting.

### 4. Data Optimization & Performance Lab
- **Data Deduplication:** Implemented logic to identify and isolate redundant records using GROUP BY and HAVING clauses, ensuring data accuracy.
- **N-th Highest Salary Analysis:** Developed efficient solutions for "Top-N" problems using ROW_NUMBER() and CTE patterns—a critical skill for business reporting.
- **Partitioned Analytics:** Leveraged PARTITION BY across multiple dimensions (Department, City, Position) to generate localized insights without collapsing the dataset.
- **Ranking Strategies:** Demonstrated the practical application of DENSE_RANK() vs ROW_NUMBER() to handle "tied" values in financial datasets.

## Files Included
- **Logistics-Operations-Management-System-SQL.sql:** The full relational architecture and automation suite.
- **SQL-Query-Optimization-Lab.sql:** Focused exercises on advanced window functions, deduplication, and analytical problem-solving.

##  Tech Stack
- **Database Engine:** Microsoft SQL Server (T-SQL)
- **Tooling:** SQL Server Management Studio (SSMS)

##  How to Run
The main script `Logistics-Operations-Management-System-SQL.sql` contains the complete logic for:
1. Creating the Schema.
2. Inserting Sample Data.
3. Running Analytical Reports.
4. Testing Stored Procedures and Views.
