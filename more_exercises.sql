####### MORE EXERCISES ######

### EMPLOYEES DATABASE ###

#1. How much do the current managers of each department get paid, relative to the average salary for the department? Is there any department where the department manager gets paid less than the average salary?

-- will need employees to get names, will need dept_emp to connect employees to department using emp_no, will need departments to get dept_name using dept_no, will need dep_manager to get managers

USE employees;

-- get current average salary for each department
SELECT dept_name, AVG(salary) AS avg_salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- join to add department info to employees and only add for current employees
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate() -- current salaries of all current employees
GROUP BY dept_name
ORDER BY dept_name;

-- get salaries for current department managers
SELECT dept_name, salary
FROM dept_manager AS dm
JOIN salaries AS s ON s.emp_no = dm.emp_no AND s.to_date > curdate()
JOIN departments AS d USING(dept_no)
WHERE dm.to_date > curdate()
ORDER BY dept_name;

-- compare average salary for each department with manager salary for that department using temp tables
CREATE TEMPORARY TABLE germain_1478.dept_ave_sal AS
SELECT dept_name, AVG(salary) AS avg_salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- join to add department info to employees and only add for current employees
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate() -- current salaries of all current employees
GROUP BY dept_name
ORDER BY dept_name;

SELECT * FROM germain_1478.dept_ave_sal;
DESCRIBE germain_1478.dept_ave_sal;

DROP TABLE germain_1478.dept_ave_sal_vs_manager;

CREATE TEMPORARY TABLE germain_1478.dept_manager_sal AS
SELECT dept_name, salary
FROM dept_manager AS dm
JOIN salaries AS s ON s.emp_no = dm.emp_no AND s.to_date > curdate()
JOIN departments AS d USING(dept_no)
WHERE dm.to_date > curdate()
ORDER BY dept_name;

SELECT * FROM germain_1478.dept_manager_sal;
DESCRIBE germain_1478.dept_manager_sal;

-- join two tables on dept_name
SELECT dept_name, avg_salary AS dept_avg_sal, salary AS man_sal, (salary/avg_salary)*100 AS 'rel%'
FROM germain_1478.dept_ave_sal
JOIN germain_1478.dept_manager_sal USING(dept_name);

# yes, there are 2 departments where the manager makes less than the average salary for that department: Customer Service and Production







