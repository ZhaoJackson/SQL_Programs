-- Task 1.1
-- In your company there hasn't been a database table with all the employee information yet. You need to set up the table called employees in the following way:
-- There should be NOT NULL constraints for the following columns:
-- first_name, last_name, job_position, start_date DATE, birth_date DATE
CREATE TABLE employees (
emp_id SERIAL PRIMARY KEY,
first_name TEXT NOT NULL,
last_name TEXT NOT NULL,
job_position TEXT NOT NULL,
salary decimal(8,2),
start_date DATE NOT NULL,
birth_date DATE NOT NULL,
store_id INT REFERENCES store(store_id), -- store_id is an INT column in employee table and references means The values in employees.store_id must match values that already exist in the store table’s store_id column.
department_id INT,
manager_id INT
);

-- Task 1.2
-- Set up an additional table called departments in the following way: Additionally no column should allow nulls.
CREATE TABLE departments (
department_id SERIAL PRIMARY KEY,
department TEXT NOT NULL,
division TEXT NOT NULL);

-- Task 2
-- Alter the employees table in the following way:
-- Set the column department_id to not null.
-- Add a default value of CURRENT_DATE to the column start_date.
-- Add the column end_date with an appropriate data type.
-- Add a constraint called birth_check that doesn't allow birth dates that are in the future.
-- Rename the column job_position to position_title.
ALTER TABLE employees 
ALTER COLUMN department_id SET NOT NULL,
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE,
ADD COLUMN end_date DATE,
ADD CONSTRAINT birth_check CHECK(birth_date < CURRENT_DATE);
ALTER TABLE employees
RENAME job_position TO position_title;

-- Task 3.1
-- Insert the following values into the employees table.
-- There will be most likely an error when you try to insert the values.
-- So, try to insert the values and then fix the error.
-- Columns: (emp_id,first_name,last_name,position_title,salary,start_date,birth_date,store_id,department_id,manager_id,end_date)
-- values will be shown as follows
INSERT INTO employees -- insert into table_name values ()
VALUES
(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
(6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
(7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
(8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
(9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
(10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,'2013-04-14'),
(11,'Carlyn','Stripp','Customer Support',3060.00,'2013-09-06','1981-09-05',1,5,3,NULL),
(12,'Reuben','McRorie','Software Engineer',7119.00,'1995-12-31','1958-08-15',1,5,6,NULL),
(13,'Gates','Raison','Marketing Specialist',3910.00,'2013-07-18','1986-06-24',1,3,3,NULL),
(14,'Jordanna','Raitt','Marketing Specialist',5844.00,'2011-10-23','1993-03-16',2,3,3,NULL),
(15,'Guendolen','Motton','BI Consultant',8330.00,'2011-01-10','1980-10-22',2,3,6,NULL),
(16,'Doria','Turbat','Senior SQL Analyst',9278.00,'2010-08-15','1983-01-11',1,1,6,NULL),
(17,'Cort','Bewlie','Project Manager',5463.00,'2013-05-26','1986-10-05',1,5,3,NULL),
(18,'Margarita','Eaden','SQL Analyst',5977.00,'2014-09-24','1978-10-08',2,1,6,'2020-03-16'),
(19,'Hetty','Kingaby','SQL Analyst',7541.00,'2009-08-17','1999-04-25',1,2,6,NULL),
(20,'Lief','Robardley','SQL Analyst',8981.00,'2002-10-23','1971-01-25',2,3,6,'2016-07-01'),
(21,'Zaneta','Carlozzi','Working Student',1525.00,'2006-08-29','1995-04-16',1,3,6,'2012-02-19'),
(22,'Giana','Matz','Working Student',1036.00,'2016-03-18','1987-09-25',1,3,6,NULL),
(23,'Hamil','Evershed','Web Developper',3088.00,'2022-02-03','2012-03-30',1,4,2,NULL),
(24,'Lowe','Diamant','Web Developper',6418.00,'2018-12-31','2002-09-07',1,4,2,NULL),
(25,'Jack','Franklin','SQL Analyst',6771.00,'2013-05-18','2005-10-04',1,2,2,NULL),
(26,'Jessica','Brown','SQL Analyst',8566.00,'2003-10-23','1965-01-29',1,1,2,NULL);

-- Task 3.2
-- Insert the following values into the departments table with values showing as follows
INSERT INTO departments
VALUES 
(1, 'Analytics','IT'),
(2, 'Finance','Administration'),
(3, 'Sales','Sales'),
(4, 'Website','IT'),
(5, 'Back Office','Administration');

-- Task 4.1
-- Jack Franklin gets promoted to 'Senior SQL Analyst' and the salary raises to 7200.
-- Update the rows name accordingly.
update employees
set position_title = 'Senior SQL Analyst'
where emp_id = 25; -- use unique values that represents 'Jack Franklin'

update employees
set salary = 7200
where emp_id = 25; 

-- Task 4.2
-- The responsible people decided to rename the position_title Customer Support to Customer Specialist.
-- Update the column name accordingly.
update employees
set position_title = 'Customer Specialist'
where position_title = 'Customer Support'; 

-- Task 4.3
-- All SQL Analysts including Senior SQL Analysts get a raise of 6%.
-- Upate the salaries accordingly.
update employees
set salary = salary * 1.06 -- raise by 6%
where position_title like '%SQL Analysts'; -- indicate all SQL analyst

-- Task 4.4
-- What is the average salary of a SQL Analyst in the company (excluding Senior SQL Analyst)?
select
round(avg (salary), 2)
from employees
where position_title = 'SQL Analyst';

-- Task 5.1
-- Write a query that adds a column called manager that contains first_name and last_name (in one column) in the data output.
-- Secondly, add a column called is_active with 'false' if the employee has left the company already, otherwise the value is 'true'.
select
emp.*,
case
when emp.end_date is null then 'true' -- true if have left
else 'false' -- false if not left company
end as is_active, -- add a column 'is_active'
mng.first_name || ' ' || mng.last_name as manager -- add a column with first_name and last_name concatenation
from employees emp
left join employees mng -- self join
on emp.manager_id = mng.emp_id;

-- Task 5.2
-- Create a view called v_employees_info from that previous query.
create view v_employees_info
as -- create view view_name as query
select
emp.*,
case
when emp.end_date is null then 'true'
else 'false'
end as is_active,
mng.first_name || ' ' || mng.last_name as manager
from employees emp
left join employees mng -- self join
on emp.manager_id = mng.emp_id;

-- Task 6
-- Write a query that returns the average salaries for each positions with appropriate roundings.
select
position_title,
round(avg(salary), 2)
from v_employees_info
group by position_title
order by 2;

-- Task 7
-- Write a query that returns the average salaries per division.
select
division,
round(avg(salary), 2)
from employees e
left join departments d
on e.department_id = d.department_id
group by division
order by 2;

-- Task 8.1
-- Write a query that returns the following: emp_id, first_name, last_name, position_title, salary
-- and a column that returns the average salary for every position_title.
-- Order the results by the emp_id.
select
emp_id,
first_name,
last_name,
position_title,
salary,
round(avg(salary) over(partition by position_title), 2) as avg_position_salary -- use over(partition by col_name) to set window function for each position title
from employees
order by 1;

-- Task 8.2
-- How many people earn less than there avg_position_salary?
-- Write a query that answers that question.
-- Ideally, the output just shows that number directly.
select
count(*) as num_employees_below_avg
from
(
select
emp_id,
salary,
round(avg(salary) over(partition by position_title), 2) as avg_position_salary
-- For each row (employee), calculate the average salary of everyone with the same job_position.
from employees
) subquery -- subquery for temporary table where we can get average salary for each position 
where salary < avg_position_salary; -- Keeps only employees whose salary is below the average salary of their job position.

-- Task 9:
-- Write a query that returns a running total of the salary development by the start_date.
-- In your calculation, you can assume their salary has not changed over time, 
-- and you can disregard the fact that people have left the company (write the query as if they were still working for the company).
select
emp_id,
salary,
start_date,
sum(salary) over(order by start_date) as running_total_of_salary -- cumulative total salary cost over time.
-- sum(salary) over(order by start_date) takes current employee's salary and add it to all previous salaries in order of start date. 
from employees;

-- Task 10:
-- Create the same running total but now also consider the fact that people were leaving the company.
select
start_date,
sum(salary) over(order by start_date) -- start_date as date of event either exit or hire
-- go through rows order by start_date and keep running total of salary over time
-- positive salary rows increase total (hires)
-- negative salary rows decrease total (exits)
from(

select
emp_id,
salary,
start_date
from employees -- set hire event where salary is added to the company total from this date

union -- provide single timeline of salary events

select
emp_id,
-salary, -- substract their pay from the total
end_date
from v_employees_info
where is_active = 'false' -- set exit event where salary is substracted from running total from this date
order by start_date
) subquery;

-- Task 11.1
-- Write a query that outputs only the top earner per position_title including first_name and position_title and their salary.
select
first_name,
position_title,
salary
from employees e1 -- Outer query (e1) → look at each employee row.
where salary = ( -- correlated subquery: it depends on values from outer query
select
max(salary) -- find maximum salary in that position
from employees e2 -- for each employee row in e1, look at all employees e2 with same position_title
where e1.position_title = e2.position_title -- Compares the current employee’s salary (e1.salary) with the maximum salary for their position. 
-- Compare: If the current employee’s salary equals that max, then keep them.
);

-- Task 11.2
-- Add also the average salary per position_title.
select
first_name,
position_title,
salary,
(
select
round(avg(salary), 2) as avg_in_position
from employees e3
where e1.position_title = e3.position_title -- For each row in the outer query (e1), find all employees (e3) with the same position.
)
from employees e1 -- get each top earner and add one more column for average salary of their position
where salary = (
select
max(salary)
from employees e2
where e1.position_title = e2.position_title -- Ensures we only keep employees whose salary is equal to the maximum salary in their job position.
);

-- Task 11.3
-- Remove those employees from the output of the previous query that has the same salary as the average of their position_title.
-- These are the people that are the only ones with their position_title.
select
first_name,
position_title,
salary,
(
select
round(avg(salary), 2) as avg_in_position
from employees e3
where e1.position_title = e3.position_title
)
from employees e1

where salary = (
select
max(salary)
from employees e2
where e1.position_title = e2.position_title -- keep top earner in each position title
)

and

salary <> (
select
round(avg(salary), 2) as avg_in_position
from employees e3
where e1.position_title = e3.position_title -- remove rows where employee's salary = average salary of their position
-- since average = salary when only one value exists
);

-- Task 12
-- Write a query that returns all meaningful aggregations of sum of salary, number of employees, average salary
-- grouped by all meaningful combinations of division, department, position_title.
select
division,
department,
position_title,
sum(salary),
count(*),
round(avg(salary), 2)
from employees
natural join departments -- returns all meaningful aggregations
group by
rollup(
division,
department,
position_title
)
order by 1, 2, 3

-- Task 13
-- Write a query that returns all employees (emp_id) including their position_title, department, their salary, and the rank of that salary partitioned by department.
-- The highest salary per division should have rank 1.
select
emp_id,
position_title,
department,
salary,
rank() over(partition by department order by salary desc)
-- PARTITION BY department: restart the ranking for each department separately.
-- ORDER BY salary DESC: within each department, order employees by salary, highest first.
-- RANK(): assign ranks based on that ordering.
from employees
natural left join departments

-- Task 14
-- Write a query that returns only the top earner of each department including
-- their emp_id, position_title, department, and their salary.
select
*
from (
select
emp_id,
position_title,
department,
salary,
rank() over(partition by department order by salary desc)
from employees
natural left join departments
) subquery -- gives a rank to each employee within their department.
where rank = 1 -- apply outer query to only those rows where rank = 1