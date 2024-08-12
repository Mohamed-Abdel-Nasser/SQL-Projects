--Data Definition Language (DDL)
--Example:CREATE,DROP,ALTER
1. Create 
Create Database 
--Structure:
CREATE DATABASE database_name;
--Example:
CREATE DATABASE sales;
Create Schema 
--Structure:
USE database_name;
GO
CREATE SCHEMA schema_name
    [AUTHORIZATION owner_name];
GO

--Example:
USE sales;
GO
CREATE SCHEMA sales_schema
    [AUTHORIZATION dbo;]
GO
Create Table 
--Structure:
CREATE TABLE [database_name].[schema_name].[table_name]
(
    column1 datatype,
    column2 datatype,
    column3 datatype,
    ...
);
--Example:
CREATE TABLE sales.sales_schema.orders
(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

2. Alter Table 
Alter Table - Add Column
--Structure:
ALTER TABLE table_name
ADD column_name datatype constraints;
--Example:
ALTER TABLE production.products
ADD product_description VARCHAR(500);

Alter Table - Drop Column
--Structure:
ALTER TABLE table_name
DROP COLUMN column_name;

--Example:
ALTER TABLE sales.customers
DROP COLUMN phone;


Alter Table - Modify Column’s Data Type
--Structure:
ALTER TABLE table_name
ALTER COLUMN column_name new_datatype;
-- when you need edit datatype 
--Example:
ALTER TABLE sales.stores
ALTER COLUMN zip_code VARCHAR(10);


Alter Table - Rename Column
If you need to rename table  you use the following syntax:
EXEC sp_rename 'staff', 'workers';
---------------------------------------------------------------------

EXEC sp_rename 'staff', 'workers';

    If you need to rename column in table  you use the following syntax:
Exec sp_rename table name. column old name ',' column new name ','column;
----------------------------------------------------------------------

EXEC sp_rename 'categories.category_name', 'cname', 'COLUMN'; 

Alter ADD Constraint  

--1. Add a Check Constraint

--Structure 
ALTER TABLE Schema_Name.Table_Name
ADD CONSTRAINT Constraint_Name CHECK (Check_Constraint);
 

ALTER TABLE employees
ADD CONSTRAINT chk_age CHECK (age >= 18 AND age <= 65);

--2. Add a Unique Constraint

--Structure 
ALTER TABLE Schema_Name.Table_Name
ADD CONSTRAINT Constraint_Name UNIQUE (Column_Name);


ALTER TABLE employees
ADD CONSTRAINT uq_email UNIQUE (email);


--3. Add a Primary Key Constraint

--Structure 
ALTER TABLE Schema_Name.Table_Name
ADD CONSTRAINT Constraint_Name PRIMARY KEY (Column_Name);



ALTER TABLE employees
ADD CONSTRAINT pk_employe PRIMARY KEY (employee_id);

--4. Add a Foreign Key Constraint

--Structure 
ALTER TABLE Schema_Name.Table_Name
ADD CONSTRAINT Constraint_Name FOREIGN KEY (Chield_Column) REFERENCES Perent_Table (Prent_Column);



ALTER TABLE employees
ADD CONSTRAINT fk_department_id FOREIGN KEY (department_id) REFERENCES departments(department_id);

Alter Drop Constraint  

ALTER TABLE Schema_Name.Table_Name
DROP CONSTRAINT Constraint_Name;
