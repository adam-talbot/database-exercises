################### SUB-QUERY EXERCISES ########################
-- Use employees db
USE employees;

#1. Find all the current employees with the same hire date as employee 101010 using a sub-query.
select *
from employees
where emp_no IN (
	select emp_no from dept_emp where to_date > curdate()
)
and hire_date = (
	select hire_date from employees where emp_no = '101010'
);
-- 55 records returned




