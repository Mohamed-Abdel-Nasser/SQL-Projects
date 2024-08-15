-- Example 1: Scalar Function to Calculate Net Sales
-- This function calculates the net sales amount for a given quantity, list price, and discount.
		CREATE FUNCTION GetNetSales(@quantity INT, @list_price DEC(10,2), @discount DEC(4,2)) RETURNS DECIMAL(10,2)
		AS 
		BEGIN
			RETURN @quantity * @list_price * (1 - @discount);
		END;

		-- Usage:
		SELECT GetNetSales(10, 100, 0.1) AS net_sale;

		SELECT order_id, SUM(GetNetSales(quantity, list_price, discount)) AS net_amount
		FROM sales.order_items
		GROUP BY order_id
		ORDER BY net_amount DESC;
		
		CREATE FUNCTION GetNetSales (@quantity INT , @list_price DEC(10,2), @discount DEC(10,2))RETURNS DECIMAL(10,2)
		AS 
		BEGIN 
		    RETURN @quantity * @list_price *(1 - @discount)
		END
		
--#############################################################################################
-- Example 2: Scalar Function to Calculate Discount Amount
-- This function calculates the discount amount for a given quantity, list price, and discount rate.
-- The SCHEMABINDING option ensures that the function is bound to the schema, preventing changes to the underlying tables or views.
		CREATE FUNCTION getDiscountAmount (@quantity INT, @list_price DEC(10,2), @discount DEC(4,2)) RETURNS DEC(10,2) 
		WITH SCHEMABINDING
		AS
		BEGIN
			RETURN @quantity * @list_price * @discount;
		END;

		-- Usage:
		SELECT dbo.getDiscountAmount(10, 100, 0.1) AS discount_amount;
--#############################################################################################
-- Example 3: Table-Valued Function to Retrieve Contacts
-- This function returns a table containing the first name, last name, email, phone number,
-- and contact type (either 'Staff' or 'Customer') from the sales.staffs and sales.customers tables.
CREATE FUNCTION Contacts() RETURNS @contacts TABLE (
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(255),
	phone VARCHAR(25),
	contact_gtype VARCHAR(20)
	)
AS
BEGIN
	INSERT INTO @contacts
	SELECT first_name, last_name, email, phone, 'Staff'
	FROM sales.staffs;
	INSERT INTO @contacts
	SELECT first_name, last_name, email, phone, 'Customer'
	FROM sales.customers;
	RETURN;
END;

-- Usage:
SELECT * FROM dbo.Contacts();
--#############################################################################################
--Example 4: Scalar Function to Get Full Customer Name
--This function concatenates the first name and last name of a customer.
		CREATE FUNCTION GetCustomerFullName(@customer_id INT)RETURNS VARCHAR(510)
		AS
		BEGIN
			DECLARE @full_name VARCHAR(510);
			SELECT @full_name = first_name + ' ' + last_name
			FROM sales.customers
			WHERE customer_id = @customer_id;
			RETURN @full_name;
		END;
		-- Usage:
		SELECT dbo.GetCustomerFullName(1) AS CustomerFullName;
--#############################################################################################
--Example 5: Scalar Function to Calculate Order Total
--This function calculates the total amount for a given order, including discounts.
		CREATE FUNCTION CalculateSoTotalSale(@order_id INT) RETURNS DECIMAL(10, 2)
		AS
		BEGIN
			DECLARE @totalSale DECIMAL(10, 2);
			SELECT @totalSale = SUM((oi.list_price * oi.quantity) * (1 - oi.discount / 100))
			FROM sales.order_items oi
			WHERE order_id = @order_id;
			RETURN @totalSale;
		END;

		-- Usage:
		SELECT dbo.CalculateSoTotalSale(1) AS OrderTotalSale;
--#############################################################################################
-- Example 6: Scalar Function to Get Total Sales by Store
-- This function calculates the total sales for a specific store, taking into account the 
-- quantity, list price, and discount of each order item.
		CREATE OR ALTER FUNCTION GetTotalSalesByStore(@store_id INT) RETURNS DECIMAL(10, 2)
		AS
		BEGIN
			DECLARE @total_sales DECIMAL(10, 2);
			SELECT @total_sales = SUM(oi.list_price * oi.quantity * (1 - oi.discount / 100))
			FROM sales.order_items oi
			JOIN sales.orders o ON oi.order_id = o.order_id
			WHERE o.store_id = @store_id;
			RETURN @total_sales;
		END;

		-- Usage:
		SELECT dbo.GetTotalSalesByStore(1) AS TotalSales;
--#############################################################################################
--Example 7: Scalar Function to Calculate Stock Value by Store
--This function calculates the total value of stock available in a given store.
		CREATE FUNCTION GetStoreStockValue(@store_id INT) RETURNS DECIMAL(10, 2)
		AS
		BEGIN
			DECLARE @stock_value DECIMAL(10, 2);
			SELECT @stock_value = SUM(s.quantity * p.list_price)
			FROM production.stocks s
			JOIN production.products p ON s.product_id = p.product_id
			WHERE s.store_id = @store_id;
			RETURN @stock_value;
		END;

		-- Usage:
		SELECT dbo.GetStoreStockValue(1) AS StoreStockValue;
--#############################################################################################
-- Example 8: Scalar Function to Get Available Stock by Store and Product
-- This function returns the available stock quantity for a specific product in a specific store.
		CREATE OR ALTER FUNCTION GetStockByStoreAndProduct(@store_id INT, @product_id INT) RETURNS INT
		AS
		BEGIN
			DECLARE @quantity INT;
			SELECT @quantity = quantity
			FROM production.stocks
			WHERE store_id = @store_id AND product_id = @product_id;
			RETURN @quantity;
		END;

		-- Usage:
		SELECT dbo.GetStockByStoreAndProduct(1, 1) AS AvailableStock;
--#############################################################################################
--Example 9: Scalar Function to Calculate Total Sales by a Specific Staff Member
--This function calculates the total sales made by a particular staff member.
		CREATE FUNCTION GetTotalSalesByStaff(@staff_id INT) RETURNS DECIMAL(10, 2)
		AS
		BEGIN
			DECLARE @total_sales DECIMAL(10, 2);
			SELECT @total_sales = SUM(oi.list_price * oi.quantity * (1 - oi.discount / 100))
			FROM sales.orders o
			JOIN sales.order_items oi ON o.order_id = oi.order_id
			WHERE o.staff_id = @staff_id;
			RETURN @total_sales;
		END;

		-- Usage:
		SELECT dbo.GetTotalSalesByStaff(1) AS TotalSales;
--#############################################################################################
-- Example 10: Scalar Function to Calculate Average Order Value by Customer
-- This function calculates the average order value for a specific customer.
		CREATE OR ALTER FUNCTION CalculateAvgOrderValueByCustomer(@customer_id INT) RETURNS DECIMAL(10, 2)
		AS
		BEGIN
			DECLARE @avg_order_value DECIMAL(10, 2);
			SELECT @avg_order_value = AVG(total_order_value)
			FROM (
				SELECT SUM(oi.list_price * oi.quantity * (1 - oi.discount / 100)) AS total_order_value
				FROM sales.order_items oi
				JOIN sales.orders o ON oi.order_id = o.order_id
				WHERE o.customer_id = @customer_id
				GROUP BY oi.order_id
			) AS AvgOrderValues;
			RETURN @avg_order_value;
		END;

		-- Usage:
		SELECT dbo.CalculateAvgOrderValueByCustomer(1) AS AvgOrderValue;
--#############################################################################################
-- Example 11: Table-Valued Function to Retrieve Order Details by Customer ID
-- This function returns details of orders made by a specific customer, including order ID, dates, status, store name, and staff name.
		CREATE FUNCTION GetOrdersDetails(@customer_id INT) RETURNS TABLE
		AS
		RETURN
		(
			SELECT o.order_id, o.order_date, o.order_status, o.required_date, o.shipped_date, s.store_name,
				   CONCAT(st.first_name, ' ', st.last_name) AS Staff_name
			FROM sales.orders o
			JOIN sales.stores s ON o.store_id = s.store_id
			JOIN sales.staffs st ON o.staff_id = st.staff_id
			WHERE o.customer_id = @customer_id
		);

		-- Usage:
		SELECT * FROM dbo.GetOrdersDetails(1);
--#############################################################################################
--Example 12: Table-Valued Function to Get Top N Products by Sales
--This function returns the top N products based on total sales amount.
		CREATE FUNCTION GetTopsellingProducts(@NoOfTopSellingProducts INT)RETURNS @TopOfSellingProducts TABLE
		(
			productId INT ,
			ProducName VARCHAR (500) ,
			totalSales DEC 
		)
		AS
		BEGIN
			INSERT INTO @TopOfSellingProducts
			SELECT TOP (@NoOfTopSellingProducts)p.product_id , p.product_name ,SUM (oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS totalSales
			FROM sales.order_items oi
			INNER JOIN production.products p ON oi.product_id = p.product_id 
			GROUP BY p.product_id , p.product_name
			ORDER BY totalSales DESC;
			RETURN;
		END;
		-- Usage:
		SELECT * FROM dbo.GetTopsellingProducts (10);
--#####################################################################################################################################
--Example 13: Table-Valued Function to Get Order Details with Customer and Staff Names
--This function returns order details along with customer and staff names for a given order status.
		CREATE FUNCTION GetOrderDetails(@order_status INT)RETURNS @OrderDetails TABLE
		(
			order_id INT,
			order_date DATE,
			store_name VARCHAR(255),
			customer_name VARCHAR(510),
			staff_name VARCHAR(100),
			total_amount DECIMAL(10, 2)
		)
		AS
		BEGIN
			INSERT INTO @OrderDetails
			SELECT 
				o.order_id,
				o.order_date,
				s.store_name,
				CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
				CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
				SUM(oi.list_price * oi.quantity * (1 - oi.discount / 100)) AS total_amount
			FROM sales.orders o
			JOIN sales.customers c ON o.customer_id = c.customer_id
			JOIN sales.staffs st ON o.staff_id = st.staff_id
			JOIN sales.stores s ON o.store_id = s.store_id
			JOIN sales.order_items oi ON o.order_id = oi.order_id
			WHERE o.order_status = @order_status
			GROUP BY o.order_id, o.order_date, c.first_name, c.last_name, st.first_name, st.last_name, s.store_name;
			RETURN;
		END;
		-- Usage:
		SELECT * FROM dbo.GetOrderDetails(1);
--#####################################################################################################################################
--Example 14: Table-Valued Function to Get Products by Category ID
--This function returns a table of products that belong to a specific category.
		CREATE FUNCTION GetProducts(@category_id INT) RETURNS TABLE 
		AS
		RETURN
		(
			SELECT product_id, product_name, list_price
			FROM production.products
			WHERE category_id = @category_id
		);
		-- Usage:
		SELECT * FROM dbo.GetProducts(1);












