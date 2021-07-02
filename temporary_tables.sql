####################### TEMPORARY TABLES LESSON FROM CURRICULUM #######################


## TABLE CREATION EXAMPLE ##

# Create a simple temp table with one column of values
CREATE TEMPORARY TABLE my_numbers(
    n INT UNSIGNED NOT NULL 
);

# Insert some data into newly created temp table
INSERT INTO my_numbers(n) VALUES (1), (2), (3), (4), (5);

# Take a look at temp table
SELECT * FROM my_numbers;

# Perform an update to change values in temp table
UPDATE my_numbers SET n = n + 1;

# Take a look at temp table
SELECT * FROM my_numbers;

# Now let's remove some records
DELETE FROM my_numbers WHERE n % 2 = 0;

# Take a look at temp table
SELECT * FROM my_numbers;


## CREATING A TABLE FROM QUERY RESULTS ##

USE employees;

CREATE TEMPORARY TABLE employees_with_departments AS
SELECT emp_no, first_name, last_name, dept_no, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
LIMIT 100;
-- it appears that I don't have necessary access to create temp tables from the employees database
-- "Access denied for user 'germain_1478'@'%' to database 'employees'"

ALTER TABLE employees_with_departments DROP COLUMN dept_no;
ALTER TABLE employees_with_departments ADD email VARCHAR(100);
-- a simple example where we want the email address to be just the first name
UPDATE employees_with_departments
SET email = CONCAT(first_name, '@company.com');


####### EXERCISES #######

USE employees;

#1. Using the example from the lesson, create a temporary table called employees_with_departments that contains first_name, last_name, and dept_name for employees currently with that department.
CREATE TEMPORARY TABLE employees_with_departments AS
SELECT first_name, last_name, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > curdate();

-- this is a test since I don't have access quite yet
SELECT first_name, last_name, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > curdate()
LIMIT 100;

#a. Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
ALTER TABLE employees_with_departments ADD full_name VARCHAR(length(first_name) + length(last_name) + 1); -- extra character added for space

-- test dince I dont have access yet
SELECT (length(first_name) + length(last_name) + 1) FROM employees;

#b. Update the table so that full name column contains the correct data
UPDATE employees_with_departments SET full_name = CONCAT(first_name, ' ', last_name); -- may need to add a space when creating new column to make sure these concats fit

-- test
SELECT concat(first_name, ' ', last_name) FROM employees;

#c. Remove the first_name and last_name columns from the table.
ALTER TABLE employees_with_departments DROP COLUMN first_name, last_name;

#d. What is another way you could have ended up with this same table?
-- just create it with a single query
SELECT dept_name, concat(first_name, ' ', last_name AS full_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE to_date > curdate()
LIMIT 100;


#2. Create a temporary table based on the payment table from the sakila database.
-- WRITE the SQL necessary TO transform the amount COLUMN such that it IS stored AS an INTEGER representing the number of cents of the payment. FOR example, 1.99 should become 199.
SELECT * FROM payment;

CREATE TEMPORARY TABLE payment_amount_integer AS
SELECT payment_id, amount, cast((amount * 100) AS UNSIGNED) AS amount_integer -- CAST data types are different than column data types, must indicate whether INT is SIGNED or UNSIGNED for it to work
FROM payment;

-- test
SELECT payment_id, amount, cast((amount * 100) AS UNSIGNED) AS amount_integer
FROM payment;

-- could also accomplish this by creating the table and then adding the transformed column
CREATE TEMPORARY TABLE payment_amount_integer AS
SELECT payment_id, amount
FROM payment;
-- add column
ALTER TABLE payment_amount_integer ADD amount_integer UNSIGNED;
-- poplulate the newly added column
UPDATE payment_amount_integer SET amount_integer = amount * 100;

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

