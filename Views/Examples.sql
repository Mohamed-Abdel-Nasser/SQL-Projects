
            --Pls US BikeStores DB 

--(1)-- To create a new view in SQL Server, you use the CREATE VIEW statement as shown below:
CREATE VIEW [OR ALTER] schema_name.view_name [(column_list)] AS
    select_statement;

--Exampls:

CREATE OR ALTER VIEW Sales.HighValueOrders AS
SELECT o.order_id, o.customer_id, c.first_name, c.last_name, o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS total_order_value
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.customers c ON o.customer_id = c.customer_id
GROUP BY o.order_id, o.customer_id, c.first_name, c.last_name, o.order_date
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) > 500;

------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW Sales.MonthlyPerformance AS
SELECT
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    s.store_name ,
    COUNT(o.order_id) AS number_of_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS total_sales
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date), s.store_name;

------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW Production.LowStockProducts AS
SELECT p.product_id, p.product_name, s.store_name, st.quantity 
FROM production.stocks st
JOIN production.products p ON st.product_id = p.product_id
JOIN sales.stores s ON st.store_id = s.store_id
WHERE st.quantity < 10;  -- Threshold for low stock

------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW Sales.StaffPerformance AS
SELECT st.staff_id, st.first_name, st.last_name,
    COUNT(o.order_id) AS number_of_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS total_sales
FROM sales.staffs st
JOIN sales.orders o ON st.staff_id = o.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY st.staff_id, st.first_name, st.last_name;

------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW Sales.CustomerPurchaseHistory AS
SELECT c.customer_id, c.first_name, c.last_name,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS total_spent
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;

------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW Production.AvgPriceByCategory AS
SELECT c.category_name, AVG(p.list_price) AS average_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW Sales.StaffManagedStores 
AS
SELECT
    st.staff_id,
    st.first_name AS staff_first_name,
    st.last_name AS staff_last_name,
    s.store_name,
    s.phone AS store_phone,
    s.email AS store_email
FROM sales.staffs st
    JOIN sales.stores s ON st.store_id = s.store_id
WHERE st.manager_id IS NULL;  -- Assuming managers have no manager themselves

------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW sales.daily_sales 
AS
SELECT
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    DAY(o.order_date) AS day,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_id,
    p.product_name,
    oi.quantity * oi.list_price AS sales
FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    INNER JOIN production.products AS p ON p.product_id = oi.product_id
    INNER JOIN sales.customers AS c ON c.customer_id = o.customer_id;

------------------------------------------------------------------------------------------

CREATE VIEW sales.staff_sales (first_name, last_name,year, amount)
AS 
SELECT  first_name, last_name, YEAR(order_date), SUM(list_price * quantity) amount
FROM sales.order_items i
    INNER JOIN sales.orders o ON i.order_id = o.order_id
    INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
GROUP BY  first_name,  last_name,  YEAR(order_date);

------------------------------------------------------------------------------------------

CREATE VIEW sales.product_catalog
AS
SELECT product_name, category_name, brand_name,list_price
FROM production.products p
    INNER JOIN production.categories c ON c.category_id = p.category_id
    INNER JOIN production.brands b ON b.brand_id = p.brand_id;

------------------------------------------------------------------------------------------

CREATE VIEW production.proproproduct_master WITH SCHEMABINDING
AS 
SELECT product_id, product_name, model_year, list_price, brand_name, category_name
FROM production.products p
    INNER JOIN production.brands b  ON b.brand_id = p.brand_id
    INNER JOIN production.categories c  ON c.category_id = p.category_id;


--≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
--¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶

--(2)--TO rename a view programmatically, you can use the sp_rename stored procedure:

EXEC sp_rename 
    @objname = 'Schema.View_Old_Name',
    @newname = 'View_New_Name';

--In this statement:
--First, pass the name of the view which you want to rename using the @objname parameter 
--and the new view name to using the @newname parameter. Note that in the @objectname 
--you must specify the schema name of the view. However, in the @newname parameter, you must not.
--Second, execute the statement.
--The sp_rename stored procedure returns the following message:
--Caution: Changing any part of an object name could break scripts and stored procedures.

--≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
--¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶

--(3)--To list all views in a SQL Server Database, you query the sys.views or sys.objects catalog view. Here is an example:

SELECT OBJECT_SCHEMA_NAME (views.object_id) AS "schemaName" ,views.name AS "viewName"   
FROM SYS.VIEWS views 
ORDER BY "schemaName"


SELECT OBJECT_SCHEMA_NAME(objects.object_id)  AS "schemaName", objects.name 
FROM SYS.OBJECTS objects 
WHERE objects.TYPE = 'V'
ORDER BY "schemaName";



--Creating a stored procedure to show views in SQL Server Database
--CREATE PROCEDURE SP_list_views(@schema_name AS VARCHAR(MAX)  = NULL,@view_name AS VARCHAR(MAX) = NULL)
--AS
--SELECT OBJECT_SCHEMA_NAME(v.object_id) schema_name,v.name view_name
--FROM sys.views as v
--WHERE (@schema_name IS NULL OR OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') 
--AND(@view_name IS NULL ORv.name LIKE '%' + @view_name + '%');
--
--
--For example, if you want to know the views that contain the word sales, 
--you can call the stored procedure usp_list_views:
--
--EXEC SP_list_views @view_name = 'sales'

--≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
--¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶

--(4)--Getting Views Information 
    -- (A)Getting the view information using the sql.sql_module catalog
    -- (B)Getting view information using the sp_helptext stored procedure
    -- (C)Getting the view information using OBJECT_DEFINITION() function


    	-- (A)Getting the view information using the sql.sql_module catalog
SELECT sm.definition, sm.uses_ansi_nulls, sm.uses_quoted_identifier, sm.is_schema_bound
FROM SYS.SQL_MODULES sm
WHERE object_id = object_id('sales.daily_sales');

    	-- (B)Getting view information using the sp_helptext stored procedure
EXEC sp_helptext 'sales.product_catalog' ;

    	-- (C)Getting the view information using OBJECT_DEFINITION() function
SELECT OBJECT_DEFINITION(OBJECT_ID('sales.staff_sales')) view_info;

--≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
--¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶

--(5)--To Remove a view in SQL Server
-- you use the DROP VIEW IF EXISTS statement as shown below:

--(A)--Removing one view 
        --Structure 
        DROP VIEW IF EXISTS 
            Schema_Name.View_Name
        
        --The following statement removes sales.staff_sales views:
        DROP VIEW IF EXISTS 
            sales.staff_sales;

--(B)--Removing multiple views 
        --Structure 
        DROP VIEW IF EXISTS 
            Schema_Name.View_Name, 
            Schema_Name.View_Name;
        
        --The following statement removes both sales.staff_sales and 
        --sales.product_catalog views at the same time:
        DROP VIEW IF EXISTS 
            sales.staff_sales, 
            sales.product_catalogs;

--≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠≠
--¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
  
----(6)--SQL Server Indexed View
    --In My Plan