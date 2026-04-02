# SQL Engineering & Database Mastery

Welcome to the SQL core of my Data Engineering portfolio. This directory serves as a centralized hub for my end-to-end database projects, industry-level practice tasks, and advanced query optimization scripts.

## Overview
The contents of this folder demonstrate a transition from foundational data manipulation to complex database architecture. Each file is designed to solve specific data challenges—ranging from relational integrity in logistics to high-performance analytical reporting.

## Technical Pillars & Concepts
The code within this directory covers the essential pillars of modern SQL Engineering:

### 1. Database Architecture & Design
* **Schema Evolution:** Designing robust table structures with optimized data types.
* **Data Integrity:** Implementation of `PRIMARY KEY`, `FOREIGN KEY`, and `CHECK` constraints to ensure "Golden Source" data quality.
* **Identity Management:** Automating record indexing using `IDENTITY` and `SEQUENCE` logic.

### 2. Advanced Analytical Querying (Window Functions)
* **Ranking & Row Identification:** Utilizing `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` for complex sorting and "Top-N" analysis.
* **Time-Series Analysis:** Applying `LEAD()` and `LAG()` to identify trends and progression across data points.
* **Partitioned Math:** Using `OVER(PARTITION BY...)` to perform granular aggregations without collapsing the dataset.

### 3. Procedural SQL & Automation
* **Stored Procedures:** Encapsulating business logic into reusable, parameterized modules for system automation.
* **Triggers (DML):** Developing `AFTER` and `INSTEAD OF` triggers for automated auditing, inventory management, and preventative data protection.
* **Dynamic Views:** Creating abstracted data layers to simplify reporting for non-technical stakeholders.

### 4. Data Optimization & Logic
* **CTEs (Common Table Expressions):** Writing modular, readable code for multi-step data transformations.
* **Subqueries:** Mastering scalar, multi-row, and correlated subqueries for dynamic filtering.
* **Gaps & Islands Problems:** Solving complex data challenges like "Forward Filling" null values and sequence identification.

## Tech Stack
* **Engine:** Microsoft SQL Server (T-SQL)
* **Environment:** SQL Server Management Studio (SSMS) / Azure Data Studio
* **Focus:** Relational Design, ETL Logic, and Query Optimization.
