 --inner join
--Example 1: Customers Table and Orders Table
SELECT first_name,last_name,email,order_id,order_date,store_id
FROM sales.customers c,sales.orders o
WHERE c.customer_id=o.customer_id;

SELECT first_name,last_name,email,order_id,order_date,store_id
FROM sales.customers c 
inner join sales.orders o ON c.customer_id=o.customer_id;


--Example 2: Staff Table and Orders Table

SELECT first_name,last_name,email,order_id,order_status,order_date
FROM sales.staffs s,sales.orders o 
WHERE s.staff_id=o.staff_id;


SELECT first_name,last_name,email,order_id,order_status,order_date 
FROM sales.staffs s 
inner join sales.orders o ON s.staff_id = o.staff_id;


--Example 3: Products Table and Brands Table
SELECT product_name, brand_name, list_price
FROM production.products p, production.brands b
WHERE p.brand_id = b.brand_id;

SELECT product_name, brand_name, list_price
FROM production.products p INNER JOIN production.brands b 
ON p.brand_id = b.brand_id;



--Example 4: Orders Table and Stores Table
SELECT order_id, order_date, store_name, city, state
FROM sales.orders o, sales.stores s
WHERE o.store_id = s.store_id;


SELECT order_id, order_date, store_name, city, state
FROM sales.orders oINNER JOIN sales.stores s 
ON o.store_id = s.store_id;


--Example 5: Order Items Table and Products Table
SELECT order_id, item_id, product_name, quantity, list_price
FROM sales.order_items oi, production.products p
WHERE oi.product_id = p.product_id;


SELECT order_id, item_id, product_name, quantity, list_price
FROM sales.order_items oi INNER JOIN production.products p 
ON oi.product_id = p.product_id;


--Example 6: Stocks Table and Stores Table
SELECT store_name, product_id, quantity
FROM production.stocks s, sales.stores t
WHERE s.store_id = t.store_id;

SELECT store_name, product_id, quantity
FROM production.stocks s INNER JOIN sales.stores t 
ON s.store_id = t.store_id;


--Example 8: Orders Table and Staffs Table
SELECT order_id, order_date, s.first_name, s.last_name
FROM sales.orders o, sales.staffs s
WHERE o.staff_id = s.staff_id;


SELECT order_id, order_date, s.first_name, s.last_name
FROM sales.orders o INNER JOIN sales.staffs s 
ON o.staff_id = s.staff_id;


--Example 9: Customers Table and Stores Table through Orders
SELECT c.first_name, c.last_name, t.store_name, o.order_id
FROM sales.customers c, sales.orders o, sales.stores t
WHERE c.customer_id = o.customer_id AND o.store_id = t.store_id;


SELECT c.first_name, c.last_name, t.store_name, o.order_id
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id
INNER JOIN sales.stores t ON o.store_id = t.store_id;

--Example 10: 
SELECT o.order_id, o.order_date, o.order_status, o.required_date, o.shipped_date,
       c.first_name + ' ' + c.last_name AS customer_name,
       CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
       st.store_name
FROM sales.orders o
INNER JOIN sales.customers c ON o.customer_id = c.customer_id
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
INNER JOIN sales.stores st ON o.store_id = st.store_id;



SELECT c.category_name, SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS total_sales
FROM sales.order_items oi
INNER JOIN production.products p ON oi.product_id = p.product_id
INNER JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;


SELECT o.order_id, o.order_date, o.order_status,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.product_name, oi.quantity, oi.list_price, oi.discount,
       oi.quantity * oi.list_price * (1 - oi.discount / 100) AS total_amount
FROM sales.orders o
INNER JOIN sales.customers c ON o.customer_id = c.customer_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN production.products p ON oi.product_id = p.product_id;




SELECT CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
       st.store_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount / 100)) AS total_sales
FROM sales.orders o
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
INNER JOIN sales.stores st ON o.store_id = st.store_id
GROUP BY s.staff_id, s.first_name, s.last_name, st.store_name
ORDER BY total_sales DESC;



