--1) Stored Procedure to Update Staff Email:CREATE PROCEDURE SP_UpdateStaffEmail (@staffId INT,@newEmail VARCHAR(255))ASBEGIN	UPDATE sales.staffs s				SET email = @newEmail	WHERE staff_id = @staffId;	IF @@ROWCOUNT > 0		PRINT 'Email updated successfully.';	ELSE
		PRINT 'Staff member not found.';END;
-- Usage
EXEC UpdateStaffEmail 10, 'newemail@example.com';	
EXEC UpdateStaffEmail 
	 @staff_id = 101, 
	 @new_email = 'newemail@example.com';	

--This stored procedure updates a staff member's email by their ID  
--and prints a success message if the update is successful  
--or an errormessage if the staff member is not found.

--#####################################################################
--2) Stored Procedure to Retrieve product stock information for a specific store
CREATE PROCEDURE SP_GetProductStockByStoreId (@storeId INT)
AS
BEGIN
	SELECT s.quantity , p.product_name
	FROM production.stocks s
	JOIN production.products p ON s.product_id = p.product_id
	WHERE s.store_id = @storeId
	ORDER BY s.quantity;
END;       -- Usage
EXEC GetProductStockByStoreId 2;
EXEC GetProductStockByStoreId 
	 @store_id =2;

--#############################################################################
--3)Stored Procedure to Calculate Total Sales by Store:CREATE PROCEDURE SP_CalculateTotalSalesByStoreASBEGIN	SELECT s.store_name, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales	FROM sales.orders o	JOIN sales.stores s ON o.store_id = s.store_id
			JOIN sales.order_items oi ON o.order_id = oi.order_id	GROUP BY s.store_name	ORDER BY total_sales DESC;END;
	
-- UsageEXEC SP_CalculateTotalSalesByStore;

--##################################################################
--4)Stored Procedure to Retrieve Products by Category NameCREATE PROCEDURE SP_GetProductsByCategoryName(@category_name VARCHAR(255))ASBEGIN	SELECT p.product_name, p.list_price	FROM production.products p	JOIN production.categories c ON p.category_id = c.category_id	WHERE c.category_name = @category_name	ORDER BY p.product_name;END;

-- Usage

EXEC SP_GetProductsByCategoryName 'Children Bicycles';

EXEC SP_GetProductsByCategoryName 
		@category_name = 'Children Bicycles';


--############################################################################33
--5) Stored Procedure to Get Product Details by Category
CREATE PROCEDURE SP_GetProductsByCategory (@categoryId INT)
AS
BEGIN
	SELECT p.product_id,p.product_name,b.brand_name,c.category_name,p.model_year,p.list_price
	FROM production.products p
	INNER JOIN production.brands b ON p.brand_id = b.brand_id
	INNER JOIN production.categories c ON p.category_id = c.category_id
	WHERE p.category_id = @categoryId
	ORDER BY p.product_name;
END;-- Usage
EXEC SP_GetProductsByCategory 1;
EXEC SP_GetProductsByCategory 2;
EXEC SP_GetProductsByCategory 3;


EXEC SP_GetProductsByCategory 
	 @category_id = 1;

EXEC SP_GetProductsByCategory 
	 @category_id = 2;

EXEC SP_GetProductsByCategory 
	 @category_id = 3;

--#####################################################################
--6) Stored Procedure to Get Stock Quantity By StoreId AND productIdCREATE PROCEDURE SP_GetStockQuantity (@storeId INT,@productId INT)ASBEGIN	SELECT quantity	FROM  production.stocks	WHERE  store_id = @storeId AND product_id = @productId;END
-- Usage
EXEC SP_GetStockQuantity 1,10;

		
EXEC SP_GetStockQuantity 
	 @storeId = 1,
	 @productId = 10;

EXEC SP_GetStockQuantity
	 @storeId = 2,
	 @productId = 10

EXEC SP_GetStockQuantity
	 @storeId = 3,
	 @productId = 10

--######################################################################
--7)Stored Procedure to Get Orders by Customer
CREATE PROCEDURE SP_GetOrdersByCustomer (@customerId INT)
AS
BEGIN
	SELECT o.order_id,o.order_date,o.order_status,o.required_date,o.shipped_date,s.store_name,
	CONCAT(st.first_name, ' ', st.last_name) AS staff_name
	FROM sales.orders o
	INNER JOIN sales.stores s ON o.store_id = s.store_id
	INNER JOIN sales.staffs st ON o.staff_id = st.staff_id
	WHERE o.customer_id = @customer_id
	ORDER BY o.order_date DESC;
END;
-- Usage
EXEC SP_GetOrdersByCustomer  123;

EXEC SP_GetOrdersByCustomer 
	 @customer_id = 123;
--################################################################
--8) Stored Procedure To Retrieve Staff Information by Store and Active Status
CREATE PROCEDURE SP_GetActiveStaffByStore (@storeId INT,@active TINYINT)
AS
BEGIN
	SELECT CONCAT(s.first_name,' ', s.last_name) AS "Staff Name", s.email, s.phone
	FROM sales.staffs s
	WHERE store_id = @storeId AND active = @active
	ORDER BY s.first_name, s.last_name;
END;

-- Usage

EXEC SP_GetActiveStaffByStore 1, @active = 1;

EXEC SP_GetActiveStaffByStore 
	 @store_id = 1, 
	 @active = 1;

--################################################################
--9)tored Procedure To Retrieve Products by Brand Name and Model Year Range
CREATE PROCEDURE SP_GetProductsByBrandAndYear(@brandName VARCHAR(255),@startYear INT = 2000,@endYear INT = 2024)
AS
BEGIN
	SELECT p.product_name, p.model_year, p.list_price,b.brand_name
	FROM production.products p
	JOIN production.brands b ON p.brand_id = b.brand_id
	WHERE b.brand_name = @brand_name AND p.model_year BETWEEN @start_year AND @end_year
	ORDER BY p.model_year;
END;

-- Usage
		
EXEC SP_GetProductsByBrandAndYear 'Sun Bicycles', 2000,2024;

EXEC SP_GetProductsByBrandAndYear 
	 @brand_name = 'Sun Bicycles', 
	 @start_year = 2000,
	 @end_year = 2024;

--################################################################
--10)Stored Procedure To Retrieve Customers by City and StateCREATE PROCEDURE SP_GetCustomersByLocation @city VARCHAR(255),@state VARCHAR(25)ASBEGIN	SELECT customer_id, first_name, last_name, phone, email	FROM sales.customers	WHERE city = @city AND state = @state	ORDER BY last_name, first_name;END;

-- UsageEXEC SP_GetCustomersByLocation 'New York','NY';
EXEC SP_GetCustomersByLocation 	 @city = 'New York', 	 @state = 'NY';

--##############################################################################
--11)Stored Procedure To Retrieve Product Information and Count
CREATE PROCEDURE SP_FindProductByName (@product_name VARCHAR(255), @product_count INT OUTPUT)
AS
BEGIN
	SELECT product_name, list_price
	FROM production.products
	WHERE product_name LIKE '%' + @product_name + '%'
	ORDER BY list_price;
	SELECT @product_count = @@ROWCOUNT;
END;

-- Usage
DECLARE @count INT;
EXEC SP_FindProductByName 
	 @product_name = 'Trek',
	 @product_count = @count OUTPUT;
SELECT @count AS 'Number of Products';
--######################################################################################
--12)Stored Procedure To Retrieve Product Information and Count
CREATE PROCEDURE SP_GetOrdersByStatusAndDate (@order_status TINYINT,@start_date DATE = '2000-01-01',@end_date DATE = GETDATE())
AS
BEGIN
	SELECT order_id, order_date, order_status, store_id, staff_id
	FROM sales.orders
	WHERE order_status = @order_status
	  AND order_date BETWEEN @start_date AND @end_date
	ORDER BY order_date DESC;
END;

-- Usage
EXEC SP_GetOrdersByStatusAndDate 
	 @order_status = 2, 
	 @start_date = '2023-01-01', 
	 @end_date = '2023-12-31';
--#########################################################################################################################
--13)Stored Procedure To Retrieve Orders by Customer ID
CREATE PROCEDURE SP_GetOrderListByCustomer (@customer_id INT)
AS
BEGIN
	DECLARE @order_list VARCHAR(MAX);
	SET @order_list = '';
	SELECT @order_list = @order_list + CAST(order_id AS VARCHAR) + CHAR(10)
	FROM sales.orders
	WHERE customer_id = @customer_id
	ORDER BY order_date;
	PRINT @order_list;
END;

-- Usage
EXEC SP_GetOrderListByCustomer 1;
--######################################################################################
--14)Stored Procedure To Retrieve Stores by State
CREATE PROCEDURE SP_GetStoreListByState (@state VARCHAR(25))
AS
BEGIN
	DECLARE @store_list VARCHAR(MAX);
	SET @store_list = '';
	SELECT @store_list = @store_list + store_name + CHAR(10)
	FROM sales.stores
	WHERE state = @state
	ORDER BY store_name;
	PRINT @store_list;
END;

-- Usage
EXEC SP_GetStoreListByState 'NY';
--######################################################################################
----15)Stored Procedure To Retrieve Products by Brand with Count
CREATE PROCEDURE SP_FindProductByBrand (@brand_name VARCHAR(255),@product_count INT OUTPUT)
AS
BEGIN
	SELECT p.product_name, p.list_price
	FROM production.products p
	JOIN production.brands b ON p.brand_id = b.brand_id
	WHERE b.brand_name = @brand_name
	ORDER BY p.product_name;
	SELECT @product_count = @@ROWCOUNT;
END;

-- Usage
DECLARE @count INT;
EXEC SP_FindProductByBrand 
	 @brand_name = 'Trek', 
	 @product_count =
	 @count OUTPUT;
SELECT @count AS "Number of Products";

--######################################################################################
--16)Stored Procedure To Retrieve Orders by Status with Count
CREATE PROCEDURE SP_FindOrdersByStatus (@order_status TINYINT,@order_count INT OUTPUT)
AS
BEGIN
	SELECT order_id, customer_id, order_date
	FROM sales.orders
	WHERE order_status = @order_status
	ORDER BY order_date DESC;
	SELECT @order_count = @@ROWCOUNT;
END;

-- Usage
DECLARE @count INT;
EXEC SP_FindOrdersByStatus 
	 @order_status = 1, 
	 @order_count = 
	 @count OUTPUT;
SELECT @count AS "Number of Orders";
--######################################################################################
--17)Stored Procedure To Retrieve Customers by City with Count
CREATE PROCEDURE SP_FindCustomersByCity (@city VARCHAR(255),@customer_count INT OUTPUT)
AS
BEGIN
	SELECT customer_id, first_name, last_name
	FROM sales.customers
	WHERE city = @city
	ORDER BY last_name, first_name;
	SELECT @customer_count = @@ROWCOUNT;
END;

-- Usage
DECLARE @count INT;
EXEC SP_FindCustomersByCity 
	 @city = 'New York', 
	 @customer_count = 
	 @count OUTPUT;
SELECT @count AS "Number of Customers";			