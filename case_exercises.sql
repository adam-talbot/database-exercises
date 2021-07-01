USE employees;

#1. Write a query that returns all employees (emp_no), their department number, their start date, their end date, and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.
-- assuming that the question is asking for start and end date for each employees time in each department, this can all be answered from the dept_emp table
-- start date could be from and to date for time in each department (not likely), time with each salary (no), hire date to last date of last role?
select emp_no, dept_no, from_date, to_date, to_date > curdate() as is_current_employee from current_dept_emp; -- not sure what data is in current_dept_emp table compared to dept_emp and dept_emp_latest_date
select emp_no, dept_no, from_date, to_date, to_date > curdate() as is_current_employee from dept_emp; -- all employees, multiple records for employees that changed departments
select emp_no, if (max(to_date) > now(), TRUE, FALSE) is_current_employee from dept_emp group by emp_no; -- only gets max to date, but doesn't show all necessary columns

-- step 1 - get latest department for all current and former employees from dept_emp table
select emp_no, max(to_date) as end_date
from dept_emp as de
group by emp_no;
-- step 2 - join these columns to dept_emp using inner join to get dept_no and only bringing over records where to_date is from latest department
select *
from dept_emp as de
join (select emp_no, max(to_date) as end_date from dept_emp group by emp_no) as latest_dept on latest_dept.emp_no = de.emp_no and de.to_date = latest_dept.end_date;
-- join employees table to get start date
select *
from dept_emp as de
join (select emp_no, max(to_date) as end_date from dept_emp group by emp_no) as latest_dept on latest_dept.emp_no = de.emp_no and de.to_date = latest_dept.end_date
join employees as e on e.emp_no = de.emp_no;
-- select columns that I want
select e.emp_no, dept_no, hire_date as start_date, end_date, end_date > curdate() as is_current_employee
from dept_emp as de
join (select emp_no, max(to_date) as end_date from dept_emp group by emp_no) as latest_dept on latest_dept.emp_no = de.emp_no and de.to_date = latest_dept.end_date
join employees as e on e.emp_no = de.emp_no;



-- classmates code to decifer
SELECT de.emp_no,
    MAX(dnum.dept_no) as "Department Number",
    Min(de.from_date) as "Start Date", MAX(de.to_date) as "End Date",
    IF (MAX(de.to_date) > NOW(), TRUE, FALSE) is_current_employee
FROM dept_emp as de
LEFT join (SELECT dept_no, emp_no FROM dept_emp
WHERE to_date = (SELECT MAX(to_date) FROM dept_emp)) as dnum using (emp_no)
GROUP BY emp_no;

#2. Write a query that returns all employee names (previous and current), and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.
select last_name,
	case
		when substring(last_name, 1, 1) >= 'A' and substring(last_name, 1, 1) <= 'H' then 'A-H'
		when substring(last_name, 1, 1) >= 'I' and substring(last_name, 1, 1) <= 'Q' then 'I-Q'
		when substring(last_name, 1, 1) >= 'R' and substring(last_name, 1, 1) <= 'Z' then 'R-Z'
		else 'Other'
		end as 'alpha_group'
from employees;

-- take it to next level and count number of employees in each alpha group
select
	case
		when substring(last_name, 1, 1) >= "A" and substring(last_name, 1, 1) <= 'H' then "A-H"
		when substring(last_name, 1, 1) >= "I" and substring(last_name, 1, 1) <= 'Q' then "I-Q"
		when substring(last_name, 1, 1) >= "R" and substring(last_name, 1, 1) <= 'Z' then "R-Z"
		else 'Other'
		end as alpha_group,
	count(*) as count
from employees
group by alpha_group;

#3. How many employees (current or previous) were born in each decade?
select
	case
		when birth_date like '195%' then '50s'
		when birth_date like '196%' then '60s'
		else "Other"
		end as decade_born,
		count(*) as count
from employees
group by decade_born;

# better solution but not using case
select concat(substring(birth_date,3,1), "0's") as decade, count(*) as count
from employees
group by decade;




# B1. What is the current average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?

-- break down into steps
-- step one - get all current salaries
select *
from salaries as s
where s.to_date > curdate();
limit 30;
-- step 2 - get all data needed together via joins - need salary info from salaries, need department number from dept_emp, need department name from departments
select *
from salaries as s
join dept_emp using(emp_no)
join departments using(dept_no)
where s.to_date > curdate()
limit 30;
-- step 3 - split up into groups in new column using case statement
select *,
	case
	  when dept_name in ('Customer Service') then 'Customer Service'
       when dept_name in ('Finance', 'Human Resources') then 'Finance & HR'
       when dept_name in ('Sales', 'Marketing') then 'Sales & Marketing'
       when dept_name in ('Production', 'Quality Management') then 'Prod & QM'
       when dept_name in ('Research', 'Development') then 'R&D'
       else "Other"
       end as dept_group
from salaries as s
join dept_emp using(emp_no)
join departments using(dept_no)
where s.to_date > curdate()
limit 30;
-- step 4 - add group by to get average salaries for each department group (same logic as using count just different aggregate function)
select
	case
	  when dept_name in ('Customer Service') then 'Customer Service'
      when dept_name in ('Finance', 'Human Resources') then 'Finance & HR'
      when dept_name in ('Sales', 'Marketing') then 'Sales & Marketing'
      when dept_name in ('Production', 'Quality Management') then 'Prod & QM'
      when dept_name in ('Research', 'Development') then 'R&D'
       else "Other"
       end as dept_group,
       avg(salary) as avg_salary
from salaries as s
join dept_emp using(emp_no)
join departments using(dept_no)
where s.to_date > curdate()
group by dept_group
order by avg_salary desc;

		