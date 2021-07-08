### THIS FILE WILL BE USED TO TEST QUERIES FOR SQL QUIZ ###
USE employees;

SELECT first_name, count(*)
FROM employees
GROUP BY gender;
-- returns an error since you have a nonaggregated column in the select statment

SELECT SUBSTR("Data Scienterrific", 10, LENGTH("Data Scienterrific"));
-- returns 'nterrific'

-- 17.
SELECT AVG(salary), min(salary), max(salary), sum(salary), std(salary)
FROM salaries;
-- works

-- 21.
SELECT DISTINCT gender FROM employees;

SELECT gender FROM employees GROUP BY gender;

-- 22.
SELECT count(emp_no) FROM employees;

-- 24.
SELECT gender, count(*) FROM employees GROUP BY gender;

SELECT * FROM employees
JOIN dept_manager USING(emp_no);