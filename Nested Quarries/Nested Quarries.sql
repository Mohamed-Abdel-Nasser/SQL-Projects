--1-- Find Employees with Salaries Higher Than Average
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name, s.salary
FROM hr.employees e
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.salary > (
    SELECT AVG(s2.salary)
    FROM hr.salaries s2
    JOIN hr.employees e2 ON s2.employee_id = e2.employee_id
    WHERE e2.department_id = e.department_id
   );


--1-- Find Employees with Salaries Higher Than Average
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name, s.salary
FROM hr.employees e
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.salary > (
    SELECT AVG(s2.salary)
    FROM hr.salaries s2
   );

 

--2-- Find Employees Who Have Received a Performance Review with Rating 5 <<< DONE >>>
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name
FROM hr.employees e
WHERE EXISTS (
    SELECT *
    FROM hr.performance_reviews pr
    WHERE e.employee_id = pr.employee_id AND pr.rating = 5
);

--9-- Find Employees with a Performance Review with Rating Less Than 3
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name
FROM hr.employees e
WHERE e.employee_id IN (
    SELECT pr.employee_id
    FROM hr.performance_reviews pr
    WHERE pr.rating < 3
);

-- List departments where all employees have received a performance review
SELECT d.department_name
FROM hr.departments d
WHERE NOT EXISTS (
    SELECT *
    FROM hr.employees e
    WHERE e.department_id = d.department_id
    AND NOT EXISTS (
        SELECT *
        FROM hr.performance_reviews pr
        WHERE pr.employee_id = e.employee_id
    )
);

--3-- Retrieve Employees Who Are Not Managers
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name
FROM hr.employees e
WHERE e.employee_id NOT IN (
    SELECT DISTINCT manager_id
    FROM hr.employees
    WHERE manager_id IS NOT NULL
);

--4-- Get Employees and Their Latest Salary
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name, s.salary
FROM hr.employees e
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.effective_date = (
    SELECT MAX(s2.effective_date)
    FROM hr.salaries s2
    WHERE e.employee_id = s2.employee_id 
);

--5-- Retrieve Department Names That Have No Employees
SELECT d.department_name
FROM hr.departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM hr.employees e
    WHERE e.department_id = d.department_id
);

--6-- Retrieve First and Last Names of Employees Who Are Not Managers
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name
FROM hr.employees e
WHERE e.employee_id NOT IN (
    SELECT DISTINCT manager_id
    FROM hr.employees
    WHERE manager_id IS NOT NULL
);

--7-- Retrieve First and Last Names of Employees Whose Salary is Less Than the Average Salary in Their Department
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name, s.salary
FROM hr.employees e
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.salary < (
    SELECT AVG(s2.salary)
    FROM hr.salaries s2
    JOIN hr.employees e2 ON s2.employee_id = e2.employee_id
    WHERE e2.department_id = e.department_id
);

--8-- Retrieve Department Names Where the Number of Employees is Greater Than 5
SELECT d.department_name
FROM hr.departments d
WHERE (
    SELECT COUNT(*)
    FROM hr.employees e
    WHERE e.department_id = d.department_id
) > 5;



--10-- Retrieve First and Last Names And Salaries of Employees in 'Software Engineering' Department Who Have Not Received a Performance Rating of 5
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name, s.salary
FROM hr.employees e
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE e.department_id = (
    SELECT department_id 
    FROM hr.departments 
    WHERE department_name = 'Software Engineering'
) AND e.employee_id NOT IN (
    SELECT r.employee_id
    FROM hr.performance_reviews r
    WHERE r.rating = 5
);

--11-- Retrieve Department Names That Do Not Have Any Ongoing Projects
SELECT d.department_name
FROM hr.departments d
WHERE NOT EXISTS (
    SELECT *
    FROM projects.projects p
    WHERE p.department_id = d.department_id
    AND p.start_date <= GETDATE()
    AND (p.end_date IS NULL OR p.end_date >= GETDATE())
);

--12-- Retrieve First and Last Names of Employees Whose Performance Rating is Below the Average Rating
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name, s.salary
FROM hr.employees e
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE e.employee_id IN (
    SELECT pr.employee_id
    FROM hr.performance_reviews pr
    WHERE pr.rating < (
        SELECT AVG(pr2.rating)
        FROM hr.performance_reviews pr2
    )
);

-- 13. Retrieve Employees and Their Salaries Where the Salary is the Highest in Their Department
SELECT e.department_id, e.first_name, e.last_name, s.salary
FROM hr.employees e
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.salary = (
    SELECT MAX(salary)
    FROM hr.salaries
    WHERE employee_id IN (
        SELECT employee_id
        FROM hr.employees
        WHERE department_id = e.department_id
    )
)
ORDER BY e.department_id;

-- 14. Retrieve Project Names and  Salary of Employees in Each Project's Department
SELECT p.project_name, SUM(s.salary) AS employeesTotalSalaries
FROM projects.projects p
JOIN hr.employees e ON p.department_id = e.department_id
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.effective_date = (
    SELECT MAX(s2.effective_date)
    FROM hr.salaries s2
    WHERE s2.employee_id = e.employee_id
	)GROUP BY p.project_name;


SELECT p.project_name,SUM (s.salary) AS employeesTotalSalaries
FROM projects.projects p 
INNER JOIN hr.departments d ON p.department_id=d.department_id
INNER JOIN hr.employees e ON d.department_id = e.department_id
INNER JOIN hr.salaries s ON e.employee_id=s.employee_id
WHERE s.effective_date = (
	SELECT MAX (s2.effective_date)
	FROM hr.salaries s2
	WHERE e.employee_id =s2.employee_id
	)GROUP BY p.project_name

-- Average salary by department for employees with ratings 4 or higher
SELECT d.department_name, AVG(s.salary) AS average_salary
FROM hr.departments d
JOIN hr.employees e ON d.department_id = e.department_id
JOIN hr.salaries s ON e.employee_id = s.employee_id
JOIN (
    SELECT employee_id, MAX(review_date) AS latest_review_date
    FROM hr.performance_reviews
    WHERE rating >= 4
    GROUP BY employee_id
) latest_reviews ON e.employee_id = latest_reviews.employee_id
WHERE s.effective_date = (
    SELECT MAX(effective_date)
    FROM hr.salaries
    WHERE employee_id = s.employee_id
)
GROUP BY d.department_name
ORDER BY d.department_name;

-- 15. Retrieve Employees' Names, Performance Reviews, and Salaries for Their Most Recent Review
SELECT CONCAT (e.first_name,' ', e.last_name) AS Employee_Name,pr.review_date, pr.rating, s.salary
FROM hr.employees e
INNER JOIN hr.performance_reviews pr ON e.employee_id=pr.employee_id
INNER JOIN hr.salaries s ON e.employee_id=s.employee_id
WHERE pr.review_date = (
	SELECT MAX (pr2.review_date) 
	FROM hr.performance_reviews pr2 
	WHERE e.employee_id = pr2.employee_id
	)
AND s.effective_date =(
	SELECT MAX (s2.effective_date) 
	FROM hr.salaries s2 
	WHERE e.employee_id =s2.employee_id 
	);

-- 16. Retrieve Distinct Project Names with Employees Earning Above the Average Salary in Their Department
SELECT DISTINCT p.project_name
FROM projects.projects p
JOIN hr.employees e ON p.department_id = e.department_id
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.salary > (
    SELECT AVG(salary)
    FROM hr.salaries s
    JOIN hr.employees e ON s.employee_id = e.employee_id
    WHERE e.department_id = p.department_id
)
AND s.effective_date = (
    SELECT MAX(effective_date)
    FROM hr.salaries
    WHERE employee_id = e.employee_id
);

SELECT DISTINCT p.project_name
FROM projects.projects p
JOIN hr.employees e ON p.department_id = e.department_id
JOIN hr.salaries s ON e.employee_id = s.employee_id
WHERE s.salary > (
    SELECT AVG(s2.salary)
    FROM hr.salaries s2
    WHERE s2.employee_id IN (
        SELECT e2.employee_id
        FROM hr.employees e2
        WHERE e2.department_id = e.department_id
    )
)
AND s.effective_date = (
    SELECT MAX(s3.effective_date)
    FROM hr.salaries s3
    WHERE s3.employee_id = e.employee_id
);
