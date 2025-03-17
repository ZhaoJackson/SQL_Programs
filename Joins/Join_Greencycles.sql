-- Join: combine information from multiple tables in one query based on the common column
-- Inner Join
-- Outer Join
-- Left Join
-- Right Join 


-- Inner Join: the value will be extracted based on the same values (rows) in the common column and return all other columns
-- only the rows where reference column value is in both tables
-- order of tables does not matter

-- select 
-- tableA.employee, -- we have to refer the table name if we choose the common colum  after select statement
-- sales -- no need to refer to the table if we choose different column.
-- from tableA 
-- inner join tableB 
-- on tableA.employee = tableB.employee -- we have include the common column

-- get the customer_id and first name and last name in the payment table
select pa.customer_id,
first_name,
last_name
from payment pa
inner join customer cu
on pa.customer_id = cu.customer_id;


-- Full Outer join: get all columns and records from both tables
-- it will include all records even for those may not have corresponding values, will be presented as 'null'

-- select 
-- tableA.employee,
-- sales
-- from tableA 
-- full outer join tableB 
-- on tableA.employee = tableB.employee



-- Left Outer Join: it will only include any record in the left table but not in the right table
-- the most used join type for we often want to have one table all of rows included and the other one with only matching ones.

-- select 
-- tableA.employee,
-- sales
-- from tableA 
-- left outer join tableB 
-- on tableA.employee = tableB.employee



-- Right Outer Join: it will only include any record in the right table but not in the left table
-- select 
-- tableA.employee,
-- sales
-- from tableA 
-- right outer join tableB 
-- on tableA.employee = tableB.employee


-- run a phone call campaing on all customers in Texas.
-- what are customers (first_name, last_name, phone number and their district)
select
first_name,
last_name,
phone,
district
from customer c
left join address a
on c.address_id = a.address_id
where a.district = 'Texas';

-- Are there any (old) addresses that are not related to any customers?
select
address
from customer c
right join address a -- include all the address and find the null address in customer
on c.address_id = a.address_id
where c.customer_id is null;

-- Joins on multiple conditions
-- when there are more than one common columns

-- select *
-- from tableA a
-- inner join tableB b
-- on a.first_name = b.first_name
-- and a.last_name = b.last_name

-- when we can make it as 'where' condition
-- select *
-- from tableA a
-- inner join tableB b
-- on a.first_name = b.first_name
-- and a.last_name = 'Jones'

-- Joins on multiple tables: get the result from A and C where we need to B to connect A and C by using different common column
-- we often use inner join for joining multiple tables
-- the order of joined tables doesn't matter

-- select *
-- from sales s
-- inner join city ci
-- on s.city_id = ci.city_id
-- inner join country co
-- on ci.country_id = co.country_id

-- to customize campaigns to customers depending on country they are from
-- which customers are from Brazil
-- get first_name, last_name, email and the country from all customers from Brazil
select
first_name,
last_name,
email
from customer cu
left join address a
on cu.address_id = a.address_id
left join city ci
on a.city_id = ci.city_id
left join country co
on co.country_id = ci.country_id
where country = 'Brazil';


-- Which title has GEORGE LINTON rented the most often?
SELECT first_name, 
last_name, 
title, 
COUNT(*)
FROM customer cu
INNER JOIN rental re
ON cu.customer_id = re.customer_id
INNER JOIN inventory inv
ON inv.inventory_id = re.inventory_id
INNER JOIN film fi
ON fi.film_id = inv.film_id
WHERE first_name = 'GEORGE' and last_name='LINTON'
GROUP BY title, first_name, last_name
ORDER BY 4 DESC;