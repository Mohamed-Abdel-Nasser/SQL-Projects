SELECT Statement
1. SELECT
	--Structure:
		--	SELECT column1, column2, ...
		--	FROM table_name;

--Examples:
	
	--Example 1
	SELECT product_id, product_name, list_price
	FROM production.products;
	
	--Example 2
	SELECT first_name, last_name, email 
	FROM sales.customers;

2. SELECT DISTINCT

	--Structure:
		--	SELECT DISTINCT column1, column2, ...
		--	FROM table_name;
	
	--Example:
	SELECT DISTINCT category_id
	FROM production.products;
	
3.SELECT TOP 
	--Structure:
	--	SELECT TOP (expression) [PERCENT] [WITH TIES]
	--	FROM table_name
	--	ORDER BY column_name;

--Examples

--Example 1
	SELECT TOP 5 product_name,list_price
	FROM production.products
	ORDER BY list_price DESC;

--Example 2
	SELECT TOP 1 PERCENT product_name,list_price
	FROM production.products
	ORDER BY list_price DESC;

--Example 3
	SELECT TOP 3 WITH TIES product_name,list_price
	FROM production.products
	ORDER BY list_price DESC;

--Example 4
	SELECT TOP 3 product_name,list_price
	FROM production.products
	ORDER BY list_price DESC;

