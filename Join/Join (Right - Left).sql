-- Example 1: 
--Employees with their Projects
--Here, if you want to know which employees have projects assigned to them and
-- which employees have not been assigned projects.
SELECT CONCAT(e.first_name ,' ',e.last_name)AS "Employee Name",p.project_name 
From hr.employees e
LEFT OUTER JOIN projects.tasks t ON e.employee_id =t.assigned_employee_id 
LEFT OUTER JOIN projects.projects p ON t.project_id =p.project_id 
ORDER BY "Employee Name" ASC;

-----------------------------------------------------------------------------

-- Example 2:
 --Departments and Their Projects
--Here, if you want to know which departments have projects assigned to them and
--which departments have no projects assigned to them
SELECT d.department_name, p.project_name
FROM hr.departments d
LEFT OUTER JOIN projects.projects p ON d.department_id = p.department_id
ORDER BY d.department_name;

-----------------------------------------------------------------------------

-- Example 3:
-- Task Status and Projects
SELECT s.status_name, p.project_name
FROM projects.project_status s
RIGHT OUTER JOIN projects.tasks t ON s.status_name = t.status
RIGHT OUTER JOIN projects.projects p ON t.project_id = p.project_id
ORDER BY s.status_name;

-----------------------------------------------------------------------------

-- Example 4:
--Query: List all employees with their assigned tasks, 
--including employees who don't have any tasks assigned and the status of this task.
SELECT e.employee_id,e.first_name + ' ' + e.last_name AS "Employee Name",t.task_name,t.status
FROM hr.employees e
LEFT JOIN projects.tasks t ON e.employee_id = t.assigned_employee_id
ORDER BY e.employee_id;

-----------------------------------------------------------------------------

-- Example 5:
-- Query: List all tasks with the names of employees assigned to them, 
--including tasks that have not been assigned to any employee.
SELECT t.task_id,t.task_name,t.status,e.first_name + ' ' + e.last_name AS assigned_to
FROM projects.tasks t
RIGHT JOIN hr.employees e ON t.assigned_employee_id = e.employee_id
ORDER BY t.task_id;

-----------------------------------------------------------------------------

--- Example 6:
-- Query: Retrieve a list of all departments along with the projects they are handling, 
--including departments that currently have no projects assigned.
SELECT d.department_id,d.department_name,p.project_name,p.start_date,p.end_date
FROM hr.departments d
LEFT JOIN projects.projects p ON d.department_id = p.department_id
ORDER BY d.department_id;

-----------------------------------------------------------------------------

-- Example 7:
-- Query: Retrieve a list of all tasks with their assigned employees, 
--including those that are not assigned to any department.
SELECT t.task_name,t.due_date,e.first_name+' '+e.last_name AS "Employee Name",d.department_name
FROM projects.tasks t
RIGHT JOIN hr.employees e ON t.assigned_employee_id = e.employee_id
RIGHT JOIN hr.departments d ON e.department_id = d.department_id
ORDER BY t.task_id;

-----------------------------------------------------------------------------

-- Example 8: Projects and Their Team Members
-- This query retrieves all projects and their team members, including projects that do not have any team members assigned.

SELECT p.project_name,e.first_name + ' ' + e.last_name AS "Team Member"
FROM projects.projects p
LEFT JOIN projects.tasks t ON p.project_id = t.project_id
LEFT JOIN hr.employees e ON t.assigned_employee_id = e.employee_id
ORDER BY p.project_name;

-----------------------------------------------------------------------------

-- Example 9: Project Duration and Status
-- Retrieve a list of projects with their start dates, end dates, and current status, including projects that are not currently in progress.
SELECT p.project_name, p.start_date,p.end_date,s.status_name
FROM projects.projects p
LEFT JOIN projects.tasks t ON p.project_id = t.project_id
LEFT JOIN projects.project_status s ON t.status = s.status_name
ORDER BY p.project_name;

-----------------------------------------------------------------------------

-- Example 10: Employees and Their Project Tasks
-- Retrieve a list of employees and their assigned project tasks, including employees who do not have any tasks assigned.
SELECT e.first_name + ' ' + e.last_name AS "Employee Name",t.task_name,p.project_name
FROM hr.employees e
LEFT JOIN projects.tasks t ON e.employee_id = t.assigned_employee_id
LEFT JOIN projects.projects p ON t.project_id = p.project_id
ORDER BY e.first_name, e.last_name;

-----------------------------------------------------------------------------

-- Example 11: Projects with Unassigned Tasks
-- Retrieve a list of projects that have tasks assigned to them, including tasks that have not been assigned to any project.
SELECT p.project_name,t.task_name
FROM projects.projects p
LEFT JOIN projects.tasks t ON p.project_id = t.project_id
WHERE t.project_id IS NULL
ORDER BY p.project_name;

-----------------------------------------------------------------------------

-- Example 12: Task Assignments with Department Information
-- Retrieve a list of tasks with their assigned employees and the departments they belong to, including tasks with no department.
SELECT t.task_name,e.first_name + ' ' + e.last_name AS "Employee Name",d.department_name
FROM projects.tasks t
LEFT JOIN hr.employees e ON t.assigned_employee_id = e.employee_id
LEFT JOIN hr.departments d ON e.department_id = d.department_id
ORDER BY t.task_name;

-----------------------------------------------------------------------------

-- Example 13: Projects and Employees Without Tasks
-- Retrieve a list of projects and employees, including those who do not have any tasks assigned to them.
SELECT p.project_name,e.first_name + ' ' + e.last_name AS "Employee Name"
FROM projects.projects p
LEFT JOIN projects.tasks t ON p.project_id = t.project_id
LEFT JOIN hr.employees e ON t.assigned_employee_id = e.employee_id
WHERE e.employee_id IS NULL
ORDER BY p.project_name;

-----------------------------------------------------------------------------

-- Example 14: Employees with Tasks and Department Information
-- Retrieve a list of employees with their assigned tasks and department information, including employees with no tasks.
SELECT e.first_name + ' ' + e.last_name AS "Employee Name",t.task_name,d.department_name
FROM hr.employees e
LEFT JOIN projects.tasks t ON e.employee_id = t.assigned_employee_id
LEFT JOIN hr.departments d ON e.department_id = d.department_id
ORDER BY e.first_name, e.last_name;

-----------------------------------------------------------------------------

-- Example 15: Departments with Project Details
-- Retrieve a list of departments and the details of projects they are associated with, including departments with no associated projects.
SELECT d.department_name,p.project_name,p.start_date,p.end_date
FROM hr.departments d
LEFT JOIN projects.projects p ON d.department_id = p.department_id
ORDER BY d.department_name;

-----------------------------------------------------------------------------

-- Example 16: Employees with Uncompleted Tasks
-- Retrieve a list of employees and their uncompleted tasks, including employees with no tasks.
SELECT e.first_name + ' ' + e.last_name AS "Employee Name",t.task_name,t.due_date
FROM hr.employees e
LEFT JOIN projects.tasks t ON e.employee_id = t.assigned_employee_id AND t.status != 'Completed'
ORDER BY e.first_name, e.last_name;

-----------------------------------------------------------------------------

-- Example 17: Projects and Task Status
-- Retrieve a list of projects and the status of tasks within those projects, including projects with no tasks.
SELECT p.project_name,s.status_name
FROM projects.projects p
LEFT JOIN projects.tasks t ON p.project_id = t.project_id
LEFT JOIN projects.project_status s ON t.status = s.status_name
ORDER BY p.project_name, s.status_name;

-----------------------------------------------------------------------------

-- Example 18: Employees with Task Assignments and Their Departments
-- Retrieve a list of employees with their assigned tasks and departments, including employees with no tasks.
SELECT e.first_name + ' ' + e.last_name AS "Employee Name",t.task_name,d.department_name
FROM hr.employees e
LEFT JOIN projects.tasks t ON e.employee_id = t.assigned_employee_id
LEFT JOIN hr.departments d ON e.department_id = d.department_id
ORDER BY e.first_name, e.last_name;

-----------------------------------------------------------------------------

-- Example 19: Employees and Project Completion
-- Retrieve a list of employees with the projects they have worked on and the completion status of those projects.
SELECT e.first_name + ' ' + e.last_name AS "Employee Name",p.project_name,s.status_name
FROM hr.employees e
LEFT JOIN projects.tasks t ON e.employee_id = t.assigned_employee_id
LEFT JOIN projects.projects p ON t.project_id = p.project_id
LEFT JOIN projects.project_status s ON t.status = s.status_name
ORDER BY e.first_name, e.last_name;
-----------------------------------------------------------------------------

-- Example 20: Projects and Employees with No Tasks
-- Retrieve a list of projects and employees, including projects and employees with no tasks assigned.
SELECT p.project_name,e.first_name + ' ' + e.last_name AS "Employee Name"
FROM projects.projects p
LEFT JOIN projects.tasks t ON p.project_id = t.project_id
LEFT JOIN hr.employees e ON t.assigned_employee_id = e.employee_id
WHERE t.task_id IS NULL
ORDER BY p.project_name;

