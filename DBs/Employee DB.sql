
CREATE DATABASE Employee;

CREATE SCHEMA hr;

CREATE SCHEMA projects;

CREATE SCHEMA company;

--------------------------------------------------------------------------

CREATE TABLE hr.departments (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL
);

INSERT INTO hr.departments (department_name)
VALUES 
('Civil Engineering'), 
('Software Engineering'), 
('Legal Marketing'), 
('HR'), 
('Finance'), 
('Sales'), 
('Support');
-----------------------------------------------------------------------------

CREATE TABLE hr.employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    job_title VARCHAR(255) NOT NULL,
    department_id INT NOT NULL,
    manager_id INT NULL,
    FOREIGN KEY (department_id) REFERENCES hr.departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES hr.employees(employee_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO hr.employees (first_name, last_name, email, hire_date, job_title, department_id, manager_id)
VALUES 
('Khaled', 'Abdel Nasser', 'khaled@example.com', '2022-01-01', 'Senior Engineer', 1, NULL),  
('Mohamed', 'Abdel Nasser', 'mohamed@example.com', '2022-02-01', 'Software Engineer', 2, 1),
('Ahmed', 'Abdel Nasser', 'ahmed@example.com', '2022-03-01', 'Software Engineer', 2, 1),
('Hassan', 'Abdel Nasser', 'hassan@example.com', '2022-04-01', 'Marketing Specialist', 3, 1),
('Sara', 'El-Sayed', 'sara@example.com', '2022-05-01', 'HR Manager', 4, 1),
('Fatma', 'Ali', 'fatma@example.com', '2022-06-01', 'Finance Analyst', 5, 1),
('Ali', 'Hassan', 'ali@example.com', '2022-07-01', 'Civil Engineer', 1, 1),
('Omar', 'Saad', 'omar@example.com', '2022-08-01', 'Software Engineer', 2, 2),
('Yara', 'Mohamed', 'yara@example.com', '2022-09-01', 'Software Engineer', 2, 2),
('Nour', 'Gamal', 'nour@example.com', '2022-10-01', 'Legal Advisor', 3, 4),
('Laila', 'Adel', 'laila@example.com', '2022-11-01', 'Accountant', 5, 6),
('Tarek', 'Youssef', 'tarek@example.com', '2022-12-01', 'Sales Manager', 6, NULL),  
('Rania', 'Ahmed', 'rania@example.com', '2023-01-01', 'Support Specialist', 1, NULL),  
('Salma', 'Hassan', 'salma@example.com', '2023-02-01', 'Intern', 1, NULL);
-----------------------------------------------------------------------------

CREATE TABLE hr.salaries (
    employee_id INT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    effective_date DATE NOT NULL,
    PRIMARY KEY (employee_id, effective_date),
    FOREIGN KEY (employee_id) REFERENCES hr.employees(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO hr.salaries (employee_id, salary, effective_date)
VALUES 
(1, 5000.00, '2023-01-01'),
(2, 6000.00, '2023-01-01'),
(3, 6000.00, '2023-01-01'),
(4, 5500.00, '2023-01-01'),
(5, 4500.00, '2023-01-01'),
(6, 7000.00, '2023-01-01'),
(7, 5000.00, '2023-01-01'),
(8, 6000.00, '2023-01-01'),
(9, 6000.00, '2023-01-01'),
(10, 5500.00, '2023-01-01'),
(11, 4500.00, '2023-01-01'),
(12, 8000.00, '2023-01-01'),
(13, 3000.00, '2023-02-01'),
(14, 2000.00, '2023-02-01');
-----------------------------------------------------------------------------

CREATE TABLE hr.performance_reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    review_date DATE NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    FOREIGN KEY (employee_id) REFERENCES hr.employees(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO hr.performance_reviews (employee_id, review_date, rating, comments)
VALUES 
(1, '2023-06-01', 4, 'Excellent performance'),
(2, '2023-06-01', 5, 'Outstanding performance'),
(3, '2023-06-01', 4, 'Very good performance'),
(4, '2023-06-01', 3, 'Good performance'),
(5, '2023-06-01', 4, 'Very good performance'),
(6, '2023-06-01', 5, 'Outstanding performance'),
(7, '2023-06-01', 4, 'Excellent performance'),
(8, '2023-06-01', 5, 'Outstanding performance'),
(9, '2023-06-01', 4, 'Very good performance'),
(10, '2023-06-01', 3, 'Good performance'),
(11, '2023-06-01', 4, 'Very good performance'),
(12, '2023-06-01', 5, 'Outstanding performance'),
(13, '2023-06-01', 2, 'Needs improvement'),
(14, '2023-06-01', 3, 'Satisfactory performance');
-----------------------------------------------------------------------------

CREATE TABLE projects.projects (
    project_id INT IDENTITY(1,1) PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    department_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (department_id) REFERENCES hr.departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO projects.projects (project_name, department_id, start_date, end_date)
VALUES 
('New House', 1, '2022-01-01', '2022-06-01'),
('New Website', 2, '2022-02-01', '2022-08-01'),
('Product Launch', 3, '2022-03-01', '2022-09-01'),
('System Upgrade', 2, '2022-04-01', '2022-10-01'),
('Recruitment Drive', 4, '2022-05-01', '2022-11-01'),
('Annual Budget', 5, '2022-06-01', '2022-12-01'),
('Software Development', 2, '2022-07-01', '2023-01-01'),
('HR Improvement', 4, '2022-08-01', '2023-02-01'),
('Financial Audit', 5, '2022-09-01', '2023-03-01');
-----------------------------------------------------------------------------

CREATE TABLE projects.project_status (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_name VARCHAR(100) NOT NULL
);

INSERT INTO projects.project_status (status_name)
VALUES 
('Planned'),
('In Progress'),
('Completed'),
('On Hold');

-----------------------------------------------------------------------------

CREATE TABLE projects.tasks (
    task_id INT IDENTITY(1,1) PRIMARY KEY,
    task_name VARCHAR(255) NOT NULL,
    project_id INT NOT NULL,
    assigned_employee_id INT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects.projects(project_id) ON DELETE NO ACTION ON UPDATE CASCADE,
    FOREIGN KEY (assigned_employee_id) REFERENCES hr.employees(employee_id) ON DELETE SET NULL ON UPDATE NO ACTION
);

INSERT INTO projects.tasks (task_name, project_id, assigned_employee_id, due_date, status)
VALUES 
('Design Phase', 1, 2, '2022-05-01', 'Completed'),
('Development Phase', 2, 3, '2022-07-01', 'In Progress'),
('Marketing Plan', 3, 4, '2022-08-01', 'Completed'),
('System Testing', 4, 8, '2022-09-01', 'In Progress'),
('Recruitment Process', 5, 5, '2022-10-01', 'Planned'),
('Budget Planning', 6, 11, '2022-11-01', 'On Hold');

-----------------------------------------------------------------------------

CREATE TABLE company.locations (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    location_name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

INSERT INTO company.locations (location_name, city, country)
VALUES 
('Head Office', 'Cairo', 'Egypt'),
('Branch Office', 'Alexandria', 'Egypt'),
('Remote Office', 'Giza', 'Egypt'),
('New York Office', 'New York', 'USA'),
('London Office', 'London', 'UK');




