# select employees database
USE employees;

#2. Write a query to to find all employees whose last name starts and ends with 'E'. Use concat() to combine their first and last name together as a single column named full_name.
SELECT CONCAT(first_name, ' ', last_name) as full_name
FROM employees
WHERE last_name LIKE 'E%e';

#3. Convert the names produced in your last query to all uppercase.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) as full_name
FROM employees
WHERE last_name LIKE 'E%e';

#4. Find all employees hired in the 90s and born on Christmas. Use datediff() function to find how many days they have been working at the company (Hint: You will also need to use NOW() or CURDATE()),
SELECT (DATEDIFF(curdate(), hire_date)) as number_of_days_employed
FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%-12-25';

#4v2. Find all employees hired in the 90s and born on Christmas. Use datediff() function to find how many days they have been working at the company (Hint: You will also need to use NOW() or CURDATE()). Add additional columns
SELECT CONCAT(first_name, ' ', last_name) as full_name, birth_date, hire_date, (DATEDIFF(curdate(), hire_date)) as number_of_days_employed
FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%-12-25';
	
#5. Find the smallest and largest current salary from the salaries table.
SELECT MAX(salary) as max_salary, MIN(salary) as min_salary
FROM salaries;

#6. Use your knowledge of built in SQL functions to generate a username for all of the employees. A username should be all lowercase, and consist of the first character of the employees first name, the first 4 characters of the employees last name, an underscore, the month the employee was born, and the last two digits of the year that they were born
SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)), LOWER(SUBSTR(last_name, 1, 4)), '_0', MONTH(birth_date), SUBSTR(YEAR(birth_date), 3, 2)) as username, first_name, last_name, birth_date
FROM employees;