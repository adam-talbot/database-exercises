####### JOIN EXERCISES #######


##### JOIN EXAMPLE DATABASE #####

#1. Use the join_example_db. Select all the records from both the users and roles tables.
USE join_example_db;

SELECT *
FROM users;
-- 6 records

SELECT *
FROM roles;
-- 4 records

#2. Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson. Before you run each query, guess the expected number of results.
-- Inner join
-- I expect 4 results since only 4 records from users table have associated roles
SELECT *
FROM users
JOIN roles
ON roles.id = users.role_id;
-- 4 records returned

-- Left join
-- I expect 6 records since there are 6 records in users table
SELECT *
FROM users
LEFT JOIN roles
ON roles.id = users.role_id;
-- 6 records returned

-- Right join
-- I expect 5 records, 4 for all users with a role and one for commenter even though there isn't a user with that role
SELECT *
FROM users
RIGHT JOIN roles
ON roles.id = users.role_id;
-- 5 records returned since there were 2 reviewers

#3. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query. 
SELECT roles.name, COUNT(users.name) AS number_of_users
FROM roles
LEFT JOIN users
ON roles.id = users.role_id
GROUP BY roles.name;

#3v2. Using opposite table order and opposite join type
SELECT roles.name, COUNT(users.name) AS number_of_users
FROM users
RIGHT JOIN roles
ON users.role_id = roles.id
GROUP BY roles.name;
-- doesnt matter the order of the arguments in the ON statement

##### EMPLOYEES DATABASE #####

#1. Use the employees database.
USE employees;

#2. write a query that shows each department along with the name of the current manager for that department.
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager' #select columns to be displayed and use aliases to rename
FROM employees AS e #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN dept_manager AS dm #join with inner join to the employees the dept_manager table (associative table) renaming using an alias again
ON dm.emp_no = e.emp_no #we are using column in common emp_no to connect the two tables
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
ON d.dept_no = dm.dept_no #we are using column in common (dept_no) to connect the two tables
WHERE dm.to_date > curdate() #Set condition to make sure we are only getting back current managers
ORDER BY d.dept_name; #order results to match order shown in exercises

#2v2. use the USING() in the joins
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager' #select columns to be displayed and use aliases to rename
FROM employees AS e #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN dept_manager AS dm #join with inner join to the employees the dept_manager table (associative table) renaming using an alias again
USING(emp_no) #we are using column in common emp_no to connect the two tables
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
USING (dept_no) #we are using column in common (dept_no) to connect the two tables
WHERE dm.to_date > curdate() #Set condition to make sure we are only getting back current managers
ORDER BY d.dept_name; #order results to match order shown in exercises

#2v3. use the AND statement in the join to only include current managers
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager' #select columns to be displayed and use aliases to rename
FROM employees AS e #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN dept_manager AS dm #join with inner join to the employees the dept_manager table (associative table) renaming using an alias again
ON dm.emp_no = e.emp_no #we are using column in common emp_no to connect the two tables
AND dm.to_date > curdate() #Set condition to make sure we are only getting back current managers
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
ON d.dept_no = dm.dept_no #we are using column in common (dept_no) to connect the two tables
ORDER BY d.dept_name; #order results to match order shown in exercises

#2v4. use the USING() in the joins
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager' #select columns to be displayed and use aliases to rename
FROM employees AS e #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN dept_manager AS dm #join with inner join to the employees the dept_manager table (associative table) renaming using an alias again
USING(emp_no) #we are using column in common emp_no to connect the two tables
AND dm.to_date > curdate() #Set condition to make sure we are only getting back current managers
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
USING (dept_no) #we are using column in common (dept_no) to connect the two tables
WHERE dm.to_date > curdate() #Set condition to make sure we are only getting back current managers
ORDER BY d.dept_name; #order results to match order shown in exercises
## THIS QUERY WILL NOT RUN
## CANNOT USE USING AND AND TOGETHER FOR JOINS
## CAN ONLY USE ON AND AND

#3. Find the name of all departments currently managed by women.
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager' #select columns to be displayed and use aliases to rename
FROM employees AS e #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN dept_manager AS dm #join with inner join to the employees the dept_manager table (associative table) renaming using an alias again
ON dm.emp_no = e.emp_no #we are using column in common emp_no to connect the two tables
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
ON d.dept_no = dm.dept_no #we are using column in common (dept_no) to connect the two tables
WHERE dm.to_date > curdate() AND e.gender = 'F' #Set condition to make sure we are only getting back current managers that are female
ORDER BY d.dept_name; #order results to match order shown in exercises - can reference column name using original name or aliases

#4. Find the current titles of employees currently working in the Customer Service department
-- Tables needed: titles, departments, dept_emp
-- Will link titles to dept_emp using emp_no
-- Will link departments to dept_emp using dept_no
SELECT t.title AS 'Title', COUNT(*) AS 'Count'
FROM dept_emp AS de #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN titles AS t #join with inner join using alias
	ON t.emp_no = de.emp_no #we are using column in common emp_no to connect the two tables
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
	ON d.dept_no = de.dept_no #we are using column in common (dept_no) to connect the two tables
WHERE t.to_date > curdate() #make sure this is their current title
 AND de.to_date > curdate() #make sure they are still in this department
  AND d.dept_name = 'Customer Service' #make sure they are in the desired department
GROUP BY t.title #group by needed since we are using count aggregate function
ORDER BY t.title; #order results to match order shown in exercises

#5. Find the current salary of all current managers.
-- Tables needed: departments to get dept_name, employees to get first_name and last_name, dept_emp to connect the two previous, salaries to get salaries, dept_manager to get who the managers are
SELECT dept_name AS 'Department Name', CONCAT(first_name, ' ', last_name) AS "Name", salary AS "Salary"
FROM departments AS d
JOIN dept_emp AS de
USING (dept_no)
JOIN employees AS e
USING (emp_no)
JOIN dept_manager AS dm
USING (emp_no)
JOIN salaries AS s
USING (emp_no)
WHERE de.to_date > curdate()
	AND dm.to_date > curdate()
	AND s.to_date > curdate()
ORDER BY dept_name;

#6. Find the number of current employees in each department.
-- Tables needed: department to get dept_name, dept_emp to get number of employees
SELECT dept_no, dept_name, COUNT(*) AS num_employees
FROM departments AS d
JOIN dept_emp AS de
USING(dept_no)
WHERE to_date > curdate()
GROUP BY dept_no
ORDER BY dept_no;

#7. Which department has the highest average salary? Hint: Use current not historic information.
-- Tables needed: departments to get dept_name, dept_emp to get all employees in department, salaries to get salaries of all employees in department
-- Will use average aggregate function and group by dept_name
SELECT dept_name, AVG(salary) AS average_salary
FROM departments AS d
JOIN dept_emp AS de
USING (dept_no)
JOIN salaries AS s
USING(emp_no)
WHERE de.to_date > curdate()
	AND s.to_date > curdate()
GROUP BY dept_name
ORDER BY average_salary DESC
LIMIT 1;


#8. Who is the highest paid employee in the Marketing department?
-- Tables needed: employees to get first and last name, salaries to get salaries, dept_emp to tie employee to department no, departments to get department name, 
SELECT first_name, last_name
FROM employees AS e
JOIN salaries AS s
USING (emp_no)
JOIN dept_emp AS de
USING (emp_no)
JOIN departments AS d
USING (dept_no)
WHERE dept_name = 'Marketing'
	AND s.to_date > curdate()
	AND de.to_date > curdate()
GROUP BY first_name, last_name
ORDER BY MAX(salary) DESC -- although this works, this aggregate function is not necessary since there should only one current salary per employee
LIMIT 1;

#8v2. finding same result not using group by and aggregate function
SELECT first_name, last_name
FROM employees AS e
JOIN salaries AS s
USING (emp_no)
JOIN dept_emp AS de
USING (emp_no)
JOIN departments AS d
USING (dept_no)
WHERE dept_name = 'Marketing'
	AND s.to_date > curdate()
	AND de.to_date > curdate()
ORDER BY salary DESC
LIMIT 1;

#9. Which current department manager has the highest salary?
-- Tables needed: salaries to get salary, dept_manager to get managers using emp_no, employees to get first and last name, departments to get dept_name
SELECT first_name, last_name, salary, dept_name
FROM salaries AS s
JOIN dept_manager AS dm
USING(emp_no)
JOIN employees AS e
USING(emp_no)
JOIN departments AS d
USING(dept_no)
WHERE s.to_date > curdate()
	AND dm.to_date > curdate()
ORDER BY salary DESC
LIMIT 1;

#10. Bonus Find the names of all current employees, their department name, and their current manager's name.
-- tables needed: employees to get names, dept_emp to make sure they are current employees, departments to get department name, dept_manager to get current manager for each department
SELECT concat(e.first_name, ' ', e.last_name) AS 'Employee Name', dept_name AS 'Department Name', concat(e2.first_name, ' ', e2.last_name) AS 'Manager Name'
FROM employees AS e
JOIN dept_emp AS de ON de.emp_no = e.emp_no AND de.to_date > curdate()
JOIN departments AS d USING(dept_no)
JOIN dept_manager AS dm ON dm.dept_no = de.dept_no AND dm.to_date > curdate()
JOIN employees AS e2 ON e2.emp_no = dm.emp_no;

#11. Bonus Who is the highest paid employee within each department.
-- Ryan's QUICK solution (my version)
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd001'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd002'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd003'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd004'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd005'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd006'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd007'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd008'
ORDER BY salary DESC
LIMIT 1)
UNION
(SELECT concat(first_name, ' ', last_name) AS full_name, dept_name, salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate()
JOIN employees AS e ON e.emp_no = s.emp_no
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
	AND dept_no = 'd009'
ORDER BY salary DESC
LIMIT 1);
