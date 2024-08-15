
-- Example 1: Customers and Orders
-- This query retrieves the first name, last name, email of customers along with their orders' details.
-- It joins the customers table with the orders table using the customer_id field.
SELECT 
    c.first_name AS "First Name",
    c.last_name AS "Last Name",
    c.email AS "Email",
    o.order_id AS "Order ID",
    o.order_date AS "Order Date",
    o.store_id AS "Store ID"
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id;

-----------------------------------------------------------------------------

-- Example 2: Staff and Orders
-- This query retrieves the first name, last name, email of staff members along with their orders' details.
-- It joins the staffs table with the orders table using the staff_id field.
SELECT 
    s.first_name AS "First Name",
    s.last_name AS "Last Name",
    s.email AS "Email",
    o.order_id AS "Order ID",
    o.order_status AS "Order Status",
    o.order_date AS "Order Date"
FROM sales.staffs s
INNER JOIN sales.orders o ON s.staff_id = o.staff_id;

-----------------------------------------------------------------------------

-- Example 3: Products and Brands
-- This query retrieves the product names, brand names, and list prices.
-- It joins the products table with the brands table using the brand_id field.
SELECT 
    p.product_name AS "Product Name",
    b.brand_name AS "Brand Name",
    p.list_price AS "List Price"
FROM production.products p
INNER JOIN production.brands b ON p.brand_id = b.brand_id;

-----------------------------------------------------------------------------

-- Example 4: Orders and Stores
-- This query retrieves order details along with store information.
-- It joins the orders table with the stores table using the store_id field.
SELECT 
    o.order_id AS "Order ID",
    o.order_date AS "Order Date",
    s.store_name AS "Store Name",
    s.city AS "City",
    s.state AS "State"
FROM sales.orders o
INNER JOIN sales.stores s ON o.store_id = s.store_id;

-----------------------------------------------------------------------------

-- Example 5: Order Items and Products
-- This query retrieves order item details along with product information.
-- It joins the order_items table with the products table using the product_id field.
SELECT 
    oi.order_id AS "Order ID",
    oi.item_id AS "Item ID",
    p.product_name AS "Product Name",
    oi.quantity AS "Quantity",
    p.list_price AS "List Price"
FROM sales.order_items oi
INNER JOIN production.products p ON oi.product_id = p.product_id;

-----------------------------------------------------------------------------

-- Example 6: Stocks and Stores
-- This query retrieves stock information along with store names.
-- It joins the stocks table with the stores table using the store_id field.
SELECT 
    t.store_name AS "Store Name",
    s.product_id AS "Product ID",
    s.quantity AS "Quantity"
FROM production.stocks s
INNER JOIN sales.stores t ON s.store_id = t.store_id;

-----------------------------------------------------------------------------

-- Example 7: Orders and Staffs
-- This query retrieves order details along with staff information.
-- It joins the orders table with the staffs table using the staff_id field.
SELECT 
    o.order_id AS "Order ID",
    o.order_date AS "Order Date",
    s.first_name AS "Staff First Name",
    s.last_name AS "Staff Last Name"
FROM sales.orders o
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id;

-----------------------------------------------------------------------------

-- Example 8: Customers, Orders, and Stores
-- This query retrieves customer details along with store names and order information.
-- It joins the customers, orders, and stores tables using customer_id and store_id fields.
SELECT 
    c.first_name AS "Customer First Name",
    c.last_name AS "Customer Last Name",
    t.store_name AS "Store Name",
    o.order_id AS "Order ID"
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id
INNER JOIN sales.stores t ON o.store_id = t.store_id;

-----------------------------------------------------------------------------

-- Example 9: Orders with Detailed Information
-- This query retrieves order details, customer names, staff names, and store names.
-- It joins the orders table with customers, staffs, and stores tables.
SELECT 
    o.order_id AS "Order ID",
    o.order_date AS "Order Date",
    o.order_status AS "Order Status",
    o.required_date AS "Required Date",
    o.shipped_date AS "Shipped Date",
    CONCAT(c.first_name, ' ', c.last_name) AS "Customer Name",
    CONCAT(s.first_name, ' ', s.last_name) AS "Staff Name",
    st.store_name AS "Store Name"
FROM sales.orders o
INNER JOIN sales.customers c ON o.customer_id = c.customer_id
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
INNER JOIN sales.stores st ON o.store_id = st.store_id;

-----------------------------------------------------------------------------

-- Example 10: Total Sales by Category
-- This query retrieves category names and the total sales amount per category.
-- It joins the order_items table with products and categories tables.
SELECT 
    c.category_name AS "Category Name",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS "Total Sales"
FROM sales.order_items oi
INNER JOIN production.products p ON oi.product_id = p.product_id
INNER JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY "Total Sales" DESC;

-----------------------------------------------------------------------------

-- Example 11: Detailed Order Information
-- This query retrieves detailed order information including customer names, product details, and total amount.
-- It joins the orders table with customers, order_items, and products tables.
SELECT 
    o.order_id AS "Order ID",
    o.order_date AS "Order Date",
    o.order_status AS "Order Status",
    c.first_name AS "Customer First Name",
    c.last_name AS "Customer Last Name",
    p.product_name AS "Product Name",
    oi.quantity AS "Quantity",
    oi.list_price AS "List Price",
    oi.discount AS "Discount",
    oi.quantity * oi.list_price * (1 - oi.discount / 100) AS "Total Amount"
FROM sales.orders o
INNER JOIN sales.customers c ON o.customer_id = c.customer_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN production.products p ON oi.product_id = p.product_id;

-----------------------------------------------------------------------------

-- Example 12: Total Sales by Staff and Store
-- This query retrieves staff names, store names, and total sales amounts.
-- It joins the orders table with staff, order_items, and stores tables.
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS "Staff Name",
    st.store_name AS "Store Name",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS "Total Sales"
FROM sales.orders o
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN sales.stores st ON o.store_id = st.store_id
GROUP BY s.staff_id, s.first_name, s.last_name, st.store_name
ORDER BY "Total Sales" DESC;

-----------------------------------------------------------------------------

--Example 13:Aggregated Sales Data by Store, Brand, and Category
-- This query retrieves detailed sales information, including store names, brand names, category names,
-- total revenue, and average discount per product, and aggregates this information at the store level.
SELECT 
    st.store_name AS "Store Name",
    b.brand_name AS "Brand Name",
    c.category_name AS "Category Name",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS "Total Revenue",
    AVG(oi.discount) AS "Average Discount",
    COUNT(DISTINCT o.order_id) AS "Total Orders"
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN production.products p ON oi.product_id = p.product_id
INNER JOIN production.brands b ON p.brand_id = b.brand_id
INNER JOIN production.categories c ON p.category_id = c.category_id
INNER JOIN sales.stores st ON o.store_id = st.store_id
GROUP BY 
    st.store_name,
    b.brand_name,
    c.category_name
HAVING 
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) > 5000 -- Filter for stores with revenue > 5000
ORDER BY 
    "Total Revenue" DESC, 
    st.store_name, 
    b.brand_name, 
    c.category_name;

-----------------------------------------------------------------------------

-- Example 14: Top Selling Products by Store
-- This query retrieves the store name, product name, total quantity sold, and total revenue for the top-selling products in each store.
SELECT 
    st.store_name AS "Store Name",
    p.product_name AS "Product Name",
    SUM(oi.quantity) AS "Total Quantity Sold",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS "Total Revenue"
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN production.products p ON oi.product_id = p.product_id
INNER JOIN sales.stores st ON o.store_id = st.store_id
GROUP BY 
    st.store_name,
    p.product_name
ORDER BY 
    st.store_name,
    "Total Revenue" DESC;

-----------------------------------------------------------------------------

-- Example 15: Sales Performance by Staff
-- This query retrieves the staff name, total sales, and average discount handled by each staff member.
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS "Staff Name",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS "Total Sales",
    AVG(oi.discount) AS "Average Discount"
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
GROUP BY 
    s.staff_id, 
    s.first_name, 
    s.last_name
ORDER BY 
    "Total Sales" DESC;


-----------------------------------------------------------------------------

-- Example 16: Aggregated Sales Data by Store, Brand, and Category
-- This query retrieves detailed sales information, including store names, brand names, category names,
-- total revenue, average discount per product, and aggregates this information at the store level.
SELECT 
    st.store_name AS "Store Name",
    b.brand_name AS "Brand Name",
    c.category_name AS "Category Name",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS "Total Revenue",
    AVG(oi.discount) AS "Average Discount",
    COUNT(DISTINCT o.order_id) AS "Total Orders"
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN production.products p ON oi.product_id = p.product_id
INNER JOIN production.brands b ON p.brand_id = b.brand_id
INNER JOIN production.categories c ON p.category_id = c.category_id
INNER JOIN sales.stores st ON o.store_id = st.store_id
GROUP BY 
    st.store_name,
    b.brand_name,
    c.category_name
HAVING 
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) > 5000 -- Filter for stores with revenue > 5000
ORDER BY 
    "Total Revenue" DESC;

-----------------------------------------------------------------------------

-- Example 17: Top Selling Products by Store
-- This query retrieves the store name, product name, total quantity sold, and total revenue for the top-selling products in each store.
SELECT 
    st.store_name AS "Store Name",
    p.product_name AS "Product Name",
    SUM(oi.quantity) AS "Total Quantity Sold",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS "Total Revenue"
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN production.products p ON oi.product_id = p.product_id
INNER JOIN sales.stores st ON o.store_id = st.store_id
GROUP BY 
    st.store_name,
    p.product_name
ORDER BY 
    st.store_name,
    "Total Revenue" DESC;

-----------------------------------------------------------------------------


