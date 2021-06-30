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



#2. Find all the titles ever held by all current employees with the first name Aamod.
-- start with titles to get all titles ever held - 443,308
select title from titles; 
-- filter by list of emp_nos from dep_emp to get current employees - 371,243
select title
from titles
where emp_no IN (
	select emp_no from dept_emp where to_date > curdate()
);
-- further filter by list of emp_nos from employees with first name desired - 251
select title
from titles
where emp_no IN (
	select emp_no from dept_emp where to_date > curdate()
)
and emp_no IN(
	select emp_no from employees where first_name = "Aamod"
);
-- 251 records returned



#3. How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.
-- start with all employees in employees table - 300,024
select count(*) from employees;
-- filter by list of emp_nos from dept_emp to get employees no longer working for company - 85,108
select count(*)
from employees
where emp_no IN (
	select emp_no from dept_emp where to_date < curdate()
);
-- 85,108 records returned



#4. Find all the current department managers that are female. List their names in a comment in your code.
-- start with all employees that are female
-- filter by list of current department managers using emp_no from dept_man table
select concat(first_name, ' ', last_name) as full_name
from employees
where gender = "F"
and emp_no IN (
	select emp_no from dept_manager where to_date > curdate()
);
-- names: Isamu Legleitner, Karsten Sigstam, Leon DasSarma, Hilary Kambil



#5. Find all the employees who currently have a higher salary than the companies overall, historical average salary
-- start with all current salaries - 240,124
select *
from salaries
where to_date > curdate();
-- what is average historical salary?
select avg(salary) from salaries; -- 63810.7448
-- filter by > average salary using scalar subquery
select *
from salaries
where to_date > curdate()
and salary > (select avg(salary) from salaries);
-- 154,543 records returned (this answer is correct based on inspecting the output)

-- filter by list of emp_nos for salaries that are greater than the average historical salary using a scalar subquery inside of another subquery
select *
from salaries
where to_date > curdate()
and emp_no IN (
	select emp_no from salaries where salary > (select avg(salary) from salaries)
);
-- 154,726 records returned
-- this method is inlcuding salaries that are under the desired threshold, not sure why




