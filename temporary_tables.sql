####################### TEMPORARY TABLES LESSON FROM CURRICULUM #######################

USE germain_1478; -- must use your personal database on the server to have write access and then access other tables using database.table syntax

## TABLE CREATION EXAMPLE ##

# Create a simple temp table with one column of values
CREATE TEMPORARY TABLE my_numbers(
    n INT UNSIGNED NOT NULL 
);

DESCRIBE my_numbers;

# Insert some data into newly created temp table
INSERT INTO my_numbers(n) VALUES (1), (2), (3), (4), (5);

# Take a look at temp table
SELECT * FROM my_numbers;

DROP TABLE my_numbers; -- nukes table, be careful with this one

# Perform an update to change values in temp table - if you do n = 10, all rows will be set to 10, can also use logic to only update certain rows (set n = 2 where n > 1 for example)
UPDATE my_numbers SET n = n + 1;

# Take a look at temp table
SELECT * FROM my_numbers;

# Now let's remove some records - start with a select statement to see which rows you will be deleting, the change SELECT to DELETE (don't need colums after delete statement)
DELETE FROM my_numbers WHERE n % 2 = 0;
-- If there is no WHERE clause after the DELETE, it will delete all rows, be careful here if you have write access

# Take a look at temp table
SELECT * FROM my_numbers;


## CREATING A TABLE FROM QUERY RESULTS ##
USE germain_1478;
SELECT DATABASE();

CREATE TEMPORARY TABLE employees_with_departments AS
SELECT emp_no, first_name, last_name, dept_no, dept_name
FROM employees.employees
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING(dept_no)
LIMIT 100;

SELECT * FROM employees_with_departments; -- worked using approach of being in my database and referencing other database and table directly using db.table syntax

DROP TABLE employees_with_departments;

-- another approach - use db you need and then refer to your personal db when creating the temp table
USE employees;

CREATE TEMPORARY TABLE germain_1478.employees_with_departments AS
SELECT emp_no, first_name, last_name, dept_no, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
LIMIT 100;

SELECT * FROM germain_1478.employees_with_departments; -- this approach also worked

USE germain_1478;
SELECT DATABASE();
SELECT * FROM employees_with_departments;

ALTER TABLE employees_with_departments DROP COLUMN dept_no;
SELECT * FROM employees_with_departments;
ALTER TABLE employees_with_departments ADD email VARCHAR(100);
SELECT * FROM employees_with_departments;
-- a simple example where we want the email address to be just the first name
UPDATE employees_with_departments SET email = CONCAT(first_name, '@company.com');
SELECT * FROM employees_with_departments;





####### EXERCISES #######




USE employees; -- use this table since it will make it easier in terms of typing
DROP TABLE germain_1478.employees_with_departments; -- drop this table so that I can recreate for exercises
SELECT * FROM germain_1478.employees_with_departments; -- verify that it has indeed been dropped

#1. Using the example from the lesson, create a temporary table called employees_with_departments that contains first_name, last_name, and dept_name for employees currently with that department.
CREATE TEMPORARY TABLE germain_1478.employees_with_departments AS
SELECT first_name, last_name, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > curdate();

SELECT * FROM germain_1478.employees_with_departments LIMIT 100; -- take a look at newly created temp table

#a. Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
ALTER TABLE germain_1478.employees_with_departments ADD full_name VARCHAR(30); -- 30 is sum of lengths first_name and last_name (14+16)
SELECT * FROM germain_1478.employees_with_departments LIMIT 100;
DESCRIBE germain_1478.employees_with_departments;

#b. Update the table so that full name column contains the correct data
UPDATE germain_1478.employees_with_departments SET full_name = CONCAT(first_name, ' ', last_name); 
SELECT * FROM germain_1478.employees_with_departments LIMIT 100;

#c. Remove the first_name and last_name columns from the table.
ALTER TABLE germain_1478.employees_with_departments DROP COLUMN first_name, DROP COLUMN last_name;
SELECT * FROM germain_1478.employees_with_departments LIMIT 100;

#d. What is another way you could have ended up with this same table?
-- just create it with a single query
SELECT dept_name, concat(first_name, ' ', last_name) AS full_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > curdate()
LIMIT 100;




#2. Create a temporary table based on the payment table from the sakila database.
-- WRITE the SQL necessary TO transform the amount COLUMN such that it IS stored AS an INTEGER representing the number of cents of the payment. FOR example, 1.99 should become 199.
USE sakila;
SELECT * FROM payment
LIMIT 100;

CREATE TEMPORARY TABLE germain_1478.payment_amount_integer AS
SELECT payment_id, amount, cast((amount * 100) AS UNSIGNED) AS amount_integer -- CAST data types are different than column data types
FROM payment;

SELECT * FROM germain_1478.payment_amount_integer;

-- could also accomplish this by creating the table and then adding the transformed column
DROP TABLE germain_1478.payment_amount_integer; -- drop so I can recreate

CREATE TEMPORARY TABLE germain_1478.payment_amount_integer AS
SELECT payment_id, amount
FROM payment;

SELECT * FROM germain_1478.payment_amount_integer; -- see whats going on
DESCRIBE germain_1478.payment_amount_integer;

-- add column
ALTER TABLE germain_1478.payment_amount_integer ADD amount_integer INT UNSIGNED;
SELECT * FROM germain_1478.payment_amount_integer;
DESCRIBE germain_1478.payment_amount_integer;

-- poplulate the newly added column
UPDATE germain_1478.payment_amount_integer SET amount_integer = amount * 100;
SELECT * FROM germain_1478.payment_amount_integer;





#3. Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department right now to work for? The worst?

-- step 1 - find current average pay for each department
-- will need salaries, will need dept_emp to connect salaries to dept via emp_no, will need departments to get dept_name via dept_no from dept_emp
SELECT * FROM salaries WHERE to_date > curdate(); -- all curent salaries - 240,124
-- first join to connect salaries to dept_no
SELECT * 
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- make sure I am only joining from dept_emp for current employees to prevent adding duplications with incorrect salary numbers - 240,124
WHERE s.to_date > curdate();
-- second join to connect dept_no to dept_name
SELECT * 
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- make sure I am only joining from dept_emp for current employees to prevent adding duplications with incorrect salary numbers - 240,124
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate();
-- use group by and aggregate function to get average salary for each department
SELECT dept_name, AVG(salary) AS average_salary
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- make sure I am only joining from dept_emp for current employees to prevent adding duplications with incorrect salary numbers - 240,124
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
GROUP BY dept_name
ORDER BY average_salary DESC;

-- step 2 - find overall, historic average pay (this will be a scalar)
-- will need salary table only to just grab average pay of all salaries ever paid
SELECT AVG(salary) FROM salaries; -- 63,810.7448

-- step 3 - find z score
-- z score = (average salary of department - historical average) / standard deviation
-- should we use standard deviation of current salaries or historical salaries (current and historic)?
-- since we are mixing current dataw (for department averages) and historical data (for overall average) it is not clear which would make more sense, so I will use both and compare results
-- find standard deviation of historical salaries 
SELECT std(salary) FROM salaries;
-- find standard deviation of current salaries
SELECT std(salary) FROM salaries WHERE to_date > curdate();

-- step 4 - create a table with departments and zscores
-- use historical std first
-- use group by and aggregate function to get average salary for each department
SELECT dept_name, (((AVG(salary))-(SELECT AVG(salary) FROM salaries))/(SELECT std(salary) FROM salaries)) AS z_score
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- make sure I am only joining from dept_emp for current employees to prevent adding duplications with incorrect salary numbers - 240,124
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
GROUP BY dept_name
ORDER BY z_score DESC;
-- this looks weird since there are no negative values, meaning all averages are above the mean, likely due to using historical average (inflation?)

-- do same thing using current std
SELECT dept_name, (((AVG(salary))-(SELECT AVG(salary) FROM salaries))/(SELECT std(salary) FROM salaries WHERE to_date > curdate())) AS z_score
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- make sure I am only joining from dept_emp for current employees to prevent adding duplications with incorrect salary numbers - 240,124
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
GROUP BY dept_name
ORDER BY z_score DESC;

-- do one more using current average salary and current std
SELECT dept_name, (((AVG(salary))-(SELECT AVG(salary) FROM salaries WHERE to_date > curdate()))/(SELECT std(salary) FROM salaries WHERE to_date > curdate())) AS z_score
FROM salaries AS s
JOIN dept_emp AS de ON de.emp_no = s.emp_no AND de.to_date > curdate() -- make sure I am only joining from dept_emp for current employees to prevent adding duplications with incorrect salary numbers - 240,124
JOIN departments AS d USING(dept_no)
WHERE s.to_date > curdate()
GROUP BY dept_name
ORDER BY z_score DESC;
-- this shows variation based on current salaries, therefore there are negative z scores

