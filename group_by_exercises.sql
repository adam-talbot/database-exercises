SHOW DATABASES;

USE employees;

SHOW TABLES;

#2. In your script, use DISTINCT to find the unique titles in the titles table. How many unique titles have there ever been? Answer that in a comment in your SQL file.
SELECT DISTINCT title
FROM titles;
-- 7 records returned

-- do same thing using group by
SELECT title
FROM titles
GROUP BY title;

#3. Write a query to to find a list of all unique last names of all employees that start and end with 'E' using GROUP BY.
SELECT last_name
FROM employees
WHERE last_name like 'E%e'
GROUP BY last_name;
-- 5 records returned

#4. Write a query to to find all unique combinations of first and last names of all employees whose last names start and end with 'E'.
SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'E%e'
GROUP BY first_name, last_name;
-- 846 records returned

#5. Write a query to find the unique last names with a 'q' but not 'qu'. Include those names in a comment in your sql code.
SELECT last_name
FROM employees
WHERE last_name LIKE '%q%'
	AND last_name NOT LIKE '%qu%'
GROUP BY last_name;
-- 3 last names returned Chleq, Lindqvist, Qiwen

#6. Add a COUNT() to your results (the query above) to find the number of employees with the same last name.
SELECT last_name, COUNT(*) as number_of_employees_with_this_last_name_all
FROM employees
WHERE last_name LIKE '%q%'
	AND last_name NOT LIKE '%qu%'
GROUP BY last_name;
-- 189, 190, 168

#6v2. Add a COUNT() to your results (the query above) to find the number of employees with the same last name and compare COUNT(*) vs COUNT(last_name)
SELECT last_name, COUNT(last_name) as number_of_employees_with_this_last_name_not_null, COUNT(*) as number_of_employees_with_this_last_name_all
FROM employees
WHERE last_name LIKE '%q%'
	AND last_name NOT LIKE '%qu%'
GROUP BY last_name;
-- No difference which makes sense since if there was a null in the last name column, it wouldn't be included per the WHERE statment

#7. Find all all employees with first names 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.
SELECT first_name, gender, COUNT(*) as total_by_gender
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
GROUP BY first_name, gender;

#8. Using your query that generates a username for all of the employees, generate a count employees for each unique username. Are there any duplicate usernames?
SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)), LOWER(SUBSTR(last_name, 1, 4)), '_', SUBSTR(birth_date, 6, 2), SUBSTR(YEAR(birth_date), 3, 2)) as username, COUNT(*) as count_of_occurrences
FROM employees
GROUP BY username
ORDER BY count_of_occurrences DESC;
-- Yes, there are duplicate usernames since some counts are higher than one and the total number of records is less than total number of employees

#8.bonus. BONUS: How many duplicate usernames are there?
SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)), LOWER(SUBSTR(last_name, 1, 4)), '_', SUBSTR(birth_date, 6, 2), SUBSTR(YEAR(birth_date), 3, 2)) as username, COUNT(*) as count_of_occurrences
FROM employees
GROUP BY username
HAVING count_of_occurrences > 1
ORDER BY count_of_occurrences DESC;
-- 13251 records returned
-- This is counting how many usernames had any duplication, not counting total number of duplications (if there are 6 of the same username, that is 5 duplications but only 1 duplicate)
-- how many duplications vs. how many duplicates

#8.doublebonus. BONUS: How many duplications are there?
#I want to see how many total employees there are and thus how many total usernames there are
SELECT *
FROM employees;
-- 300,024 total employees

-- how many total usernames? to check to make sure code is generating usernames for all employees
SELECT CONCAT(
		LOWER(SUBSTR(first_name, 1, 1)), # lower-case first letter of first name 
		LOWER(SUBSTR(last_name, 1, 4)), # lower-case first four letters of last name
		 '_', # add underscore
		  SUBSTR(birth_date, 6, 2), # month born
		   SUBSTR(YEAR(birth_date), 3, 2) # last 2 digits of year born
		     ) as username, #create alias
		   first_name, last_name, birth_date
FROM employees;
-- 300,024 total usernames

-- How many unique usernames? Using SELECT DISTINCT
SELECT DISTINCT CONCAT(
		LOWER(SUBSTR(first_name, 1, 1)), # lower-case first letter of first name 
		LOWER(SUBSTR(last_name, 1, 4)), # lower-case first four letters of last name
		 '_', # add underscore
		  SUBSTR(birth_date, 6, 2), # month born
		   SUBSTR(YEAR(birth_date), 3, 2) # last 2 digits of year born
		     ) as username #create alias
FROM employees;
-- 285,872 unique usernames

-- How many unique usernames? Using GROUP BY
SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)), LOWER(SUBSTR(last_name, 1, 4)), '_', SUBSTR(birth_date, 6, 2), SUBSTR(YEAR(birth_date), 3, 2)) as username
FROM employees
GROUP BY username;
-- 285,872 unique usernames

-- 300,024 (total employees) - 285,872 (unique usernames) = 14,152 (duplications)
-- total number of employees minus unique number of usernames should equal total number of duplications
-- How to do this simply and programatically? Use COUNT(*) of both queries above to get total number of records and then subract them

-- Return total number of employees
SELECT COUNT(*) as employee_count
FROM employees;

-- Return total amount of unique usernames
(SELECT COUNT(*)                       # Distinct usernames
FROM (
	SELECT
        CONCAT 
        (
            LOWER(SUBSTR(first_name,1,1)),     
            LOWER(SUBSTR(last_name,1,4)),     
            "_",                      
            SUBSTR(birth_date,6,2),     
            SUBSTR(YEAR(birth_date), 3, 2)      
        ) AS username,
    COUNT(lower
    (
        CONCAT 
        (
            LOWER(SUBSTR(first_name,1,1)),     
            LOWER(SUBSTR(last_name,1,4)),     
            "_",                      
            SUBSTR(birth_date,6,2),     
            SUBSTR(YEAR(birth_date), 3, 2)    
        )
    ))
    AS Instance_Count
FROM employees
GROUP BY username      
ORDER BY Instance_Count DESC) AS USERnames);
	