-- see all databases
SHOW DATABASES;

-- 1. select employees database
USE employees;

-- take a look at table named employees
SELECT *
FROM employees;

-- 2. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' using IN. Enter a comment with the number of records returned
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya');
-- returned 709 records

-- 3. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN
SELECT *
FROM employees
WHERE first_name = 'Irena' 
	OR first_name = 'Vidya' 
	OR first_name = 'Maya';
-- returned 709 records, same as Q2

-- 4. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN
SELECT *
FROM employees
WHERE (first_name = 'Irena' 
	OR first_name = 'Vidya' 
	OR first_name = 'Maya')
		AND gender = 'M';
-- 441 records returned

-- 5. Find all current or previous employees whose last name starts with 'E'
SELECT *
FROM employees
WHERE last_name LIKE 'E%';
-- 7,330 records returned

-- 6. Find all current or previous employees whose last name starts or ends with 'E'
SELECT *
FROM employees
WHERE last_name LIKE 'E%'
	OR last_name LIKE '%E';
-- 30723 records returned
-- How many employees have a last name that ends with E, but does not start with E?
-- 30723 - 7330 = 23,393

-- 7. Find all current or previous employees employees whose last name starts and ends with 'E'
SELECT *
FROM employees
WHERE last_name LIKE 'E%'
	AND last_name LIKE '%E';
-- 899 records returned
-- How many employees' last names end with E, regardless of whether they start with E?
SELECT *
FROM employees
WHERE last_name LIKE '%E';
-- 24,292
-- 899 (starts and ends with E) + 23,393 (ends with E but does not start with E) = 24,292 (ends with E regardless of whether they start with E)

-- 8. Find all current or previous employees hired in the 90s
SELECT *
FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1999-12-31';
-- 135,214 records returned

-- 9. Find all current or previous employees born on Christmas.
SELECT *
FROM employees
WHERE birth_date LIKE '%-12-25';
-- 842 records returned

-- 10. Find all current or previous employees hired in the 90s and born on Christmas
SELECT *
FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1999-12-31'
	AND birth_date LIKE '%-12-25';
-- 362 records returned

-- 11. Find all current or previous employees with a 'q' in their last name
SELECT *
FROM employees
WHERE last_name LIKE '%q%';
-- 1,873 records returned

-- 12. Find all current or previous employees with a 'q' in their last name but not 'qu'
SELECT *
FROM employees
WHERE last_name LIKE '%q%'
	AND last_name NOT LIKE '%qu%';
-- 547 records returned


