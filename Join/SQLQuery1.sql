SELECT
    e.first_name + ' ' + e.last_name As employeeName,
    m.first_name + ' ' + m.last_name As managerName
FROM
    sales.staffs e
INNER JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY managerName;

--------------------------------------------------------

SELECT
    e.first_name + ' ' + e.last_name As employeeName,
    m.first_name + ' ' + m.last_name As managerName
FROM sales.staffs e
LEFT JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY managerName;

--------------------------------------------------------

SELECT c1.city,
    c1.first_name + ' ' + c1.last_name AS customer_1,
    c2.first_name + ' ' + c2.last_name AS customer_2
FROM sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id > c2.customer_id AND c1.city = c2.city
ORDER BY city,customer_1,customer_2;


--------------------------------------------------------

SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id <> c2.customer_id
AND c1.city = c2.city
ORDER BY
    city,
    customer_1,
    customer_2;



--------------------------------------------------------

SELECT 
   customer_id, first_name + ' ' + last_name c, 
   city
FROM sales.customers
WHERE city = 'Albany'
ORDER BY c;

--------------------------------------------------------

SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id > c2.customer_id
AND c1.city = c2.city
WHERE c1.city = 'Albany'
ORDER BY c1.city,customer_1,customer_2;

--------------------------------------
--Right JOIN
SELECT product_name,
order_id
FROM sales.order_items o
RIGHT JOIN production.products p ON o.product_id = p.product_id
ORDER BY
order_id;
---------------------------------------------------
SELECT product_name,order_id
FROM sales.order_items o
RIGHT JOIN production.products p ON o.product_id = p.product_id
WHERE order_id IS NULL
ORDER BY product_name;
