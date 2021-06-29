#1. Use the join_example_db. Select all the records from both the users and roles tables.
USE join_example_db;

SELECT *
FROM users;
-- 6 records

SELECT *
from roles;
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
-- I expect 4 records since there are 4 records in users table
SELECT *
FROM users
RIGHT JOIN roles
ON roles.id = users.role_id;
-- 5 records returned since there were 2 reviewers

#3. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query.
SELECT roles.name, COUNT(*) as number_of_users
FROM roles
RIGHT JOIN users
ON roles.id = users.role_id
GROUP BY roles.name;

#3v2. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query.
SELECT roles.name, COUNT(*) as number_of_users
FROM roles
RIGHT JOIN users
ON users.role_id = roles.id
GROUP BY roles.name;
-- doesnt matter the order of the arguments in the ON statement

#1. Use the employees database.
USE employees;

#2. write a query that shows each department along with the name of the current manager for that department.
SELECT d.dept_name as 'Department Name', CONCAT(e.first_name, ' ', e.last_name) as 'Department Manager' #select columns to be displayed and use aliases to rename
FROM employees AS e #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN dept_manager AS dm #join with inner join to the employees the dept_manager table (associative table) renaming using an alias again
ON dm.emp_no = e.emp_no #we are using column in common emp_no to connect the two tables
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
ON d.dept_no = dm.dept_no #we are using column in common (dept_no) to connect the two tables
WHERE dm.to_date > curdate() #Set condition to make sure we are only getting back current managers
ORDER BY d.dept_name; #order results to match order shown in exercises

#3. Find the name of all departments currently managed by women.
SELECT d.dept_name as 'Department Name', CONCAT(e.first_name, ' ', e.last_name) as 'Department Manager' #select columns to be displayed and use aliases to rename
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
SELECT t.title as 'Title', COUNT(*) as 'Count'
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



