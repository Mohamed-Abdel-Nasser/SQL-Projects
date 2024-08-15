                        --Pls Use BikeStore DB--

-- Example 1: Aggregated Information for Products by Category
-- This query retrieves the category ID, the total number of products in each category, 
-- the highest price, the lowest price, and the average price for each category.
-- Results are sorted by the number of products in descending order.
SELECT 
    p.category_id,
    COUNT(p.product_id) AS "Number Of Products",
    MAX(p.list_price) AS "Highest Price",
    MIN(p.list_price) AS "Lowest Price",
    AVG(p.list_price) AS "Average Price"
FROM production.products p
GROUP BY p.category_id
ORDER BY COUNT(p.product_id) DESC;

-----------------------------------------------------------------------------

-- Example 2: Orders Count and Date Range for Each Customer
-- This query retrieves the customer ID, the total number of orders placed by each customer, 
-- the date of the first order, and the date of the last order.
-- It only includes customers with more than 2 orders, sorted by the number of orders in descending order.
SELECT 
    o.customer_id,
    COUNT(o.order_id) AS "Number Of Orders",
    MIN(o.order_date) AS "First Order Date",
    MAX(o.order_date) AS "Last Order Date"
FROM sales.orders o
GROUP BY o.customer_id
HAVING COUNT(o.order_id) > 2
ORDER BY COUNT(o.order_id) DESC;

-----------------------------------------------------------------------------

-- Example 3: Stock Summary for Stores
-- This query retrieves the store ID, the total quantity of stock, the highest quantity in stock, 
-- and the lowest quantity in stock for each store.
-- It only includes stores where the total stock quantity exceeds 100, sorted by total stock quantity in descending order.
SELECT 
    store_id,
    SUM(quantity) AS "Total Quantity",
    MAX(quantity) AS "Highest Quantity in Stock",
    MIN(quantity) AS "Lowest Quantity in Stock"
FROM production.stocks
GROUP BY store_id
HAVING SUM(quantity) > 100
ORDER BY SUM(quantity) DESC;

-----------------------------------------------------------------------------

-- Example 4: Total Sales per Store
-- This query retrieves the store name and the total sales amount for each store.
-- It only includes stores where total sales exceed 10,000, sorted by total sales in descending order.
SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS "Total Sales"
FROM sales.stores s
JOIN sales.orders o ON s.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 10000
ORDER BY "Total Sales" DESC;

-----------------------------------------------------------------------------

-- Example 5: Average Order Value by Customer
-- This query retrieves the customer's full name and the average order value for each customer.
-- It only includes customers with an average order value greater than 200, sorted by average order value in descending order.
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS "Customer Name",
    AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS "Average Order Value"
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.first_name, c.last_name
HAVING AVG(oi.quantity * oi.list_price * (1 - oi.discount)) > 200
ORDER BY "Average Order Value" DESC;

-----------------------------------------------------------------------------

-- Example 6: Best-Selling Products by Category
-- This query retrieves the category name, product name, and the total quantity sold for each product.
-- It only includes products where the total quantity sold is greater than 50, sorted by total quantity sold in descending order.
SELECT 
    c.category_name,
    p.product_name,
    SUM(oi.quantity) AS "Total Quantity Sold"
FROM production.categories c
JOIN production.products p ON c.category_id = p.category_id
JOIN sales.order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name, p.product_name
HAVING SUM(oi.quantity) > 50
ORDER BY "Total Quantity Sold" DESC;

-----------------------------------------------------------------------------

-- Example 7: Store Inventory Summary
-- This query retrieves the store name, the total inventory quantity, and the average inventory quantity for each store.
-- It only includes stores where the total inventory exceeds 100, sorted by total inventory in descending order.
SELECT 
    s.store_name,
    SUM(st.quantity) AS "Total Inventory",
    AVG(st.quantity) AS "Average Inventory"
FROM sales.stores s
JOIN production.stocks st ON s.store_id = st.store_id
GROUP BY s.store_name
HAVING SUM(st.quantity) > 100
ORDER BY "Total Inventory" DESC;

-----------------------------------------------------------------------------

-- Example 8: Orders Per Staff Member
-- This query retrieves the staff member's full name and the total number of orders they have handled.
-- It only includes staff members with more than 10 orders, sorted by the number of orders in descending order.
SELECT 
    st.first_name,
    st.last_name,
    COUNT(o.order_id) AS "Total Orders"
FROM sales.staffs st
JOIN sales.orders o ON st.staff_id = o.staff_id
GROUP BY st.first_name, st.last_name
HAVING COUNT(o.order_id) > 10
ORDER BY "Total Orders" DESC;

-----------------------------------------------------------------------------

-- Example 9: Store Performance with Revenue and Discount Analysis
-- This query retrieves the store name, the total number of orders, the total revenue generated, 
-- and the average discount applied for each store.
-- It only includes stores where the total revenue exceeds 10,000, sorted by total revenue in descending order.
SELECT 
    s.store_name,
    COUNT(o.order_id) AS "Total Orders",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS "Total Revenue",
    AVG(oi.discount) AS "Average Discount"
FROM sales.stores s
JOIN sales.orders o ON s.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 10000
ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC;

-----------------------------------------------------------------------------

-- Example 10: Aggregated Store Performance Metrics
-- This query retrieves the store name, total number of orders, total revenue, and average discount.
-- It only includes stores where the total revenue exceeds 10,000, sorted by total revenue in descending order.
SELECT 
    s.store_name,
    COUNT(o.order_id) AS "Total Orders",
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS "Total Revenue",
    AVG(oi.discount) AS "Average Discount"
FROM sales.stores s
JOIN sales.orders o ON s.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 10000
ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC;


--##########################################################################################

                                -- Pls Use Employee DB--

-- Example 1: Grouping employees by department and filtering with HAVING clause
-- This query retrieves the department name, total number of employees in each department, and the average salary.
-- It only includes departments where the average salary is greater than 5000, sorted by the average salary in descending order.
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS "Total Employees",
    AVG(s.salary) AS "Average Salary"
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_name
HAVING AVG(s.salary) > 5000
ORDER BY AVG(s.salary) DESC;

-----------------------------------------------------------------------------

-- Example 2: Grouping projects by status and department, and filtering with HAVING clause
-- This query retrieves the department name, project status, and counts the number of projects.
-- It includes only those statuses where the number of projects is greater than 2, sorted by the number of projects in descending order.
SELECT 
    d.department_name,
    ps.status_name,
    COUNT(p.project_id) AS "Number of Projects"
FROM projects.projects p
JOIN hr.departments d ON p.department_id = d.department_id
JOIN projects.project_status ps ON ps.status_id = p.department_id
GROUP BY d.department_name, ps.status_name
HAVING COUNT(p.project_id) > 2
ORDER BY COUNT(p.project_id) DESC;

-----------------------------------------------------------------------------

-- Example 3: Grouping employees by manager and department, and filtering with HAVING clause
-- This query retrieves the manager's name, department name, and total salary of employees under each manager.
-- It includes only those managers where the total salary exceeds 20000, sorted by total salary in descending order.
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS "Manager Name",
    d.department_name,
    SUM(s.salary) AS "Total Salary"
FROM hr.employees e
JOIN hr.employees m ON e.manager_id = m.employee_id
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.salaries s ON e.employee_id = s.employee_id
GROUP BY m.first_name, m.last_name, d.department_name
HAVING SUM(s.salary) > 20000
ORDER BY SUM(s.salary) DESC;

-----------------------------------------------------------------------------

-- Example 4: Grouping employees by department and performance rating
-- This query retrieves the department name, the performance rating, and counts the number of employees with each rating.
-- It filters out departments where fewer than 2 employees have a rating of 4 or higher.
-- Results are ordered by department name and then by rating in descending order.
SELECT 
    d.department_name,
    pr.rating,
    COUNT(e.employee_id) AS "Number of Employees"
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY d.department_name, pr.rating
HAVING COUNT(e.employee_id) >= 2 AND pr.rating >= 4
ORDER BY d.department_name ASC, pr.rating DESC;

-----------------------------------------------------------------------------

-- Example 5: Grouping projects by location and filtering with HAVING clause
-- This query retrieves the location name, country, and counts the number of projects associated with each location.
-- It filters out locations with fewer than 3 projects and orders the results by the number of projects in descending order.
SELECT 
    l.location_name,
    l.country,
    COUNT(p.project_id) AS "Number of Projects"
FROM projects.projects p
JOIN company.locations l ON p.department_id = l.location_id
GROUP BY l.location_name, l.country
HAVING COUNT(p.project_id) >= 3
ORDER BY COUNT(p.project_id) DESC;

-----------------------------------------------------------------------------

-- Example 6: Average Salary by Department with a Minimum Threshold
-- This query retrieves the department name and average salary.
-- It only includes departments where the average salary is greater than 5000, sorted by average salary in descending order.
SELECT d.department_name,AVG(s.salary) AS "Average Salary"
FROM hr.salaries s
JOIN hr.employees e ON s.employee_id = e.employee_id
JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(s.salary) > 5000
ORDER BY AVG(s.salary) DESC;

-----------------------------------------------------------------------------

-- Example 7: Count of Employees in Each Department with More Than 3 Employees
-- This query retrieves the department name and the total number of employees in each department.
-- It only includes departments with more than 3 employees, sorted by the number of employees in descending order.
SELECT d.department_name,COUNT(e.employee_id) AS "Total Employees"
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 3
ORDER BY COUNT(e.employee_id) DESC;

-----------------------------------------------------------------------------

-- Example 8: Total Salary by Job Title with a Minimum Total Salary
-- This query retrieves the job title and the total salary for each job title.
-- It only includes job titles where the total salary is greater than 15,000, sorted by total salary in ascending order.
SELECT e.job_title,SUM(s.salary) AS "Total Salary"
FROM hr.salaries s
JOIN hr.employees e ON s.employee_id = e.employee_id
GROUP BY e.job_title
HAVING SUM(s.salary) > 15000
ORDER BY SUM(s.salary) ASC;

-----------------------------------------------------------------------------

-- Example 9: Average Performance Rating by Department with a Minimum Average Rating
-- This query retrieves the department name and the average performance rating.
-- It only includes departments with an average rating greater than 4, sorted by average rating in descending order.
SELECT d.department_name,AVG(pr.rating) AS "Average Rating"
FROM hr.performance_reviews pr
JOIN hr.employees e ON pr.employee_id = e.employee_id
JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(pr.rating) > 4
ORDER BY AVG(pr.rating) DESC;

-----------------------------------------------------------------------------

-- Example 10: Number of Projects by Department with a Minimum Project Count
-- This query retrieves the department name and the number of projects in each department.
-- It only includes departments with more than 2 projects, sorted by the number of projects in descending order.
SELECT d.department_name,COUNT(p.project_id) AS "Number of Projects"
FROM projects.projects p
JOIN hr.departments d ON p.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(p.project_id) > 2
ORDER BY COUNT(p.project_id) DESC;
