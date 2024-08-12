--Pls Use BikeStore DB
-- Example 1: Aggregated Information for Products by Category
SELECT 
    category_id,
    COUNT(product_id) AS "Number of Products",
    MAX(list_price) AS "Highest Price",
    MIN(list_price) AS "Lowest Price",
    AVG(list_price) AS "Average Price"
FROM production.products
GROUP BY category_id
ORDER BY COUNT(product_id) DESC;

-- Example 2: Orders Count and Date Range for Each Customer
SELECT 
    customer_id,
    COUNT(order_id) AS "Number of Orders",
    MIN(order_date) AS "First Order Date",
    MAX(order_date) AS "Last Order Date"
FROM sales.orders
GROUP BY customer_id
HAVING COUNT(order_id) > 2
ORDER BY COUNT(order_id) DESC;

-- Example 3: Stock Summary for Stores
SELECT 
    store_id,
    SUM(quantity) AS "Total Quantity",
    MAX(quantity) AS "Highest Quantity in Stock",
    MIN(quantity) AS "Lowest Quantity in Stock"
FROM production.stocks
GROUP BY store_id
HAVING SUM(quantity) > 100
ORDER BY SUM(quantity) DESC;



-- Pls Use Employee DB
-- Example 4: Performance Reviews Summary for Employees
SELECT e.first_name,e.last_name,
    COUNT(pr.review_id) AS "Number of Reviews",
    MAX(pr.rating) AS "Highest Rating"
FROM hr.employees e
JOIN hr.performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY e.first_name, e.last_name
HAVING COUNT(pr.review_id) > 1
ORDER BY MAX(pr.rating) DESC;

-- Example 5: Average Salary by Department
SELECT d.department_name,AVG(s.salary) AS "Average Salary"
FROM hr.departments d
JOIN hr.employees e ON d.department_id = e.department_id
JOIN hr.salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_name
HAVING AVG(s.salary) > 5000
ORDER BY AVG(s.salary) DESC;



