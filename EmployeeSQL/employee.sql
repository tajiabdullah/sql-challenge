-- Table schema:
-- ERD can be accessed through link: https://app.quickdatabasediagrams.com/#/d/mIsF3Z
-- Create tables along with primary keys
CREATE TABLE "titles" (
    "title_id" VARCHAR(10)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
	CONSTRAINT "pk_titles" PRIMARY KEY ("title_id")
);
CREATE TABLE "departments" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
	CONSTRAINT "pk_departments" PRIMARY KEY ("dept_no")
);
CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR(10)   NOT NULL,
    "birth_date" VARCHAR(15)   NOT NULL,
    "first_name" VARCHAR(20)   NOT NULL,
    "last_name" VARCHAR(20)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" VARCHAR(15)   NOT NULL,
	CONSTRAINT "pk_employees" PRIMARY KEY ("emp_no")
);
CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);
CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);
CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
	"dept_no" VARCHAR(15)   NOT NULL
);
--Assign foreign keys
ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");
ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");
ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");
-- Import data to each table manually
-- Confirm data in each table using SELECT * FROM
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM dept_emp;
-- List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no AS "Employee Number",
employees.last_name AS "Last Name",
employees.first_name AS "First Name",
employees.sex AS "Sex",
salaries.salary AS "Salary"
FROM employees, salaries
WHERE employees.emp_no = salaries.emp_no;
-- List first name, last name, and hire date for employees hired in 1986.
SELECT first_name AS "First Name",
last_name AS "Last Name",
hire_date AS "Hire Date"
FROM employees
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;
-- List the following information of the managers: the manager’s employee number, last name, first name, department number, department name.
SELECT dept_manager.emp_no AS "Employee Number",
employees.last_name AS "Last Name",
employees.first_name AS "First Name",
departments.dept_no AS "Department Number",
departments.dept_name AS "Department"
FROM dept_manager
JOIN employees
ON dept_manager.emp_no = employees.emp_no
JOIN departments
ON departments.dept_no = dept_manager.dept_no;
-- List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT dept_emp.emp_no AS "Employee Number",
employees.last_name AS "Last Name",
employees.first_name AS "First Name",
departments.dept_name AS "Department"
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;
-- List first name, last name, and sex for employees whose first name is “Hercules” and last names begin with “B.”
SELECT employees.first_name AS "First Name",
employees.last_name AS "Last Name",
employees.sex AS "Sex"
FROM employees
WHERE first_name = 'Hercules' AND last_name Like 'B%'
-- List all employees in the Sales department with the department name, employee number, last name, and first name.
SELECT departments.dept_name AS "Department",
employees.emp_no AS "Employee Number",
employees.last_name AS "Last Name",
employees.first_name AS "First Name"
FROM employees
JOIN dept_emp
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';
-- List all employees in the Sales and Development departments with the department name, employee number, last name, first name.
SELECT departments.dept_name AS "Department",
dept_emp.emp_no AS "Employee Number",
employees.last_name AS "Last Name",
employees.first_name AS "First Name"
FROM employees
JOIN dept_emp
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development'
ORDER BY dept_name; --make it easier to see by department, order it by department
-- In descending order, list how many employees share the same last name for all last names.
SELECT last_name AS "Last Name",
COUNT(last_name) AS "Frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;