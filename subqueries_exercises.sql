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
-- 154,726 records returned (incorrect)
-- this method is inlcuding salaries that are under the desired threshold, not sure why



#6. How many current salaries are within 1 standard deviation of the current highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?
-- start with all salaries

-- find standard deviation (current and current and historic)
select std(salary) from salaries where to_date > curdate(); # standard deviation of current salaries = 17309.95933634675
select std(salary) from salaries; # standard deviation of current and historic salaries = 16904.82828800014

-- find current max salary
select max(salary) from salaries where to_date > curdate(); # = 158,220

-- find number of salaries that are within 1 standard deviation of the max (current and current and historic standard deviation)
select salary from salaries where to_date > curdate() and salary >= ((select max(salary) from salaries where to_date > curdate()) - (select std(salary) from salaries where to_date > curdate())); # 83 salaries are within 1 standard deviation of current salaries (>=~140,910)
select count(*) from salaries where to_date > curdate() and salary >= ((select max(salary) from salaries where to_date > curdate()) - (select std(salary) from salaries where to_date > curdate())); # used count aggregate function to get a total number as output
select salary from salaries where to_date > curdate() and salary >= ((select max(salary) from salaries where to_date > curdate())-(select std(salary) from salaries)); # 78 salaries within 1 standard deviation of current and historical salaries (>=~141,315)
select count(*) from salaries where to_date > curdate() and salary >= ((select max(salary) from salaries where to_date > curdate())-(select std(salary) from salaries)); # used count aggregate function to get a total number as output

-- find total number of all salaries (current and current and historic)
select salary from salaries where to_date > curdate(); # 240,124 total current salaries
select count(*) from salaries where to_date > curdate(); # used count aggregate function to get a total number as output
select salary from salaries; #2,844,047 current and historic salaries
select count(*) from salaries; # used count aggregate function to get a total number as output

-- divide and multipy by 100 to get percentage (current and current and historic)
select ((select count(*) from salaries where to_date > curdate() and salary >= ((select max(salary) from salaries where to_date > curdate()) - (select std(salary) from salaries where to_date > curdate()))) / (select count(*) from salaries where to_date > curdate()))*100 as percentage_of_current_using_current_std; -- using denominator of all current salaries and std of all current salaries
select ((select count(*) from salaries where to_date > curdate() and salary >= ((select max(salary) from salaries where to_date > curdate())-(select std(salary) from salaries)))/(select count(*) from salaries))*100 as percentage_of_current_and_historic_using_current_and_historic_std; -- using denominator of all current and historic salaries and std of all current and historic salaries

-- percentage of current salaries that are within one stardard deviation of current max salary using std of only current salaries  = 0.0346%
-- percentage of current and historic salaries within one standard deviation of current max salary using std of current and historic salaries = 0.0027%




#B1. Find all the department names that currently have female managers.
-- need employees table to get gender
-- need dept_manager to get current department managers
-- need departments to get names of departments
# get emp_no for all current department managers
select * from dept_manager where to_date > curdate();
# check which of these managers are female by checking emp_no from employees
select * from employees where gender = 'F' LIMIT 10;

-- put pieces together to find all dept_no all departments with current female manager
select dept_no from dept_manager
where to_date > curdate()
AND emp_no IN (
	select emp_no from employees where gender = 'F'
);

-- add this as a subquery to pull department names for these dep_nos from departments table
select dept_name from departments
where dept_no IN (
	select dept_no from dept_manager
	where to_date > curdate()
	AND emp_no IN (
	select emp_no from employees where gender = 'F'
				  )		
);
-- Answer: Development, Finance, Human Resources, Research




#B2. 