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

#3. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query. - LOOK AT THIS AGAIN
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

#5. Find the current salary of all current managers.
-- Tables needed: departments to get dept_name, employees to get first_name and last_name, dept_emp to connect the two previous, salaries to get salaries, dept_manager to get who the managers are
SELECT dept_name as 'Department Name', CONCAT(first_name, ' ', last_name) as "Name", salary as "Salary"
FROM departments as d
JOIN dept_emp as de
USING (dept_no)
JOIN employees as e
USING (emp_no)
JOIN dept_manager as dm
USING (emp_no)
JOIN salaries as s
USING (emp_no)
WHERE de.to_date > curdate()
	AND dm.to_date > curdate()
	AND s.to_date > curdate()
ORDER BY dept_name;

#6. Find the number of current employees in each department.
-- Tables needed: department to get dept_name, dept_emp to get number of employees
SELECT dept_no, dept_name, COUNT(*) as num_employees
FROM departments as d
JOIN dept_emp as de
USING(dept_no)
WHERE to_date > curdate()
GROUP BY dept_no
ORDER by dept_no;

#7. Which department has the highest average salary? Hint: Use current not historic information.
-- Tables needed: departments to get dept_name, dept_emp to get all employees in department, salaries to get salaries of all employees in department
-- Will use average aggregate function and group by dept_name
SELECT dept_name, AVG(salary) as average_salary
FROM departments as d
JOIN dept_emp as de
USING (dept_no)
JOIN salaries as s
USING(emp_no)
WHERE de.to_date > curdate()
	AND s.to_date > curdate()
GROUP BY dept_name
ORDER BY average_salary DESC
LIMIT 1;

#8. Who is the highest paid employee in the Marketing department?
-- Tables needed: employees to get first and last name, salaries to get salaries, dept_emp to tie employee to department no, departments to get department name, 
SELECT first_name, last_name
FROM employees as e
JOIN salaries as s
USING (emp_no)
JOIN dept_emp as de
USING (emp_no)
JOIN departments as d
USING (dept_no)
WHERE dept_name = 'Marketing'
	AND s.to_date > curdate()
	AND de.to_date > curdate()
GROUP BY first_name, last_name
ORDER BY MAX(salary) DESC
LIMIT 1;

#8v2. Who is the highest paid employee in the Marketing department?
SELECT first_name, last_name
FROM employees as e
JOIN salaries as s
USING (emp_no)
JOIN dept_emp as de
USING (emp_no)
JOIN departments as d
USING (dept_no)
WHERE dept_name = 'Marketing'
	AND s.to_date > curdate()
	AND de.to_date > curdate()
ORDER BY salary DESC
LIMIT 1;

#9. Which current department manager has the highest salary?
-- Tables needed: salaries to get salary, dept_manager to get managers using emp_no, employees to get first and last name, departments to get dept_name
SELECT first_name, last_name, salary, dept_name
FROM salaries as s
JOIN dept_manager as dm
USING(emp_no)
JOIN employees as e
USING(emp_no)
JOIN departments as d
USING(dept_no)
WHERE s.to_date > curdate()
	AND dm.to_date > curdate()
ORDER BY salary DESC
LIMIT 1;

#10. Bonus Find the names of all current employees, their department name, and their current manager's name.
-- Got this from a classmate, still need to figure out exactly what is going on here
-- Key to this problem is a self join, you can do this by realiasing it
SELECT CONCAT(e.first_name, ' ', e.last_name) AS "Employee Name", 
d.dept_name as "Department Name",
CONCAT(e1.first_name, ' ', e1.last_name) as 'Manager Name'
FROM employees as e
JOIN dept_emp as de
  	ON de.emp_no = e.emp_no
JOIN departments as d
  	ON d.dept_no = de.dept_no
JOIN dept_manager as dm
  	ON dm.dept_no = de.dept_no
JOIN employees as e1
	ON e1.emp_no = dm.emp_no
WHERE de.to_date = '9999-01-01' AND dm.to_date = '9999-01-01' AND dm.dept_no = d.dept_no
LIMIT 10;

#11. Bonus Who is the highest paid employee within each department.
-- Ryan's quick solution
# Bonus Who is the highest paid employee within each department.
# Do you need the answer in 20 minutes?
# Do we need this query to run next year?
# Do you need one code query that we could run any time in the next 20 years?
# If there are only 9 departments, do we need a super squeeky clean solution?
# Quick answer: run 9 queries and stitch the answers together
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd001'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd002'
order by salary DESC
limit 1);

select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd001'
order by salary DESC
limit 1;