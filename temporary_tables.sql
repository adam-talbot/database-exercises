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

