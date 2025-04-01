-- UNION: combine multiple tables with columns into one with aggregating rows
-- select first_name, sales, 'table_name' from table1
-- union
-- select first_name, sales, 'table_name' from table2
-- Rules: 1) Union function will combine the rows with regard to the 1st table's columns.
-- 2) Number of columns must match
-- 3) Data type must match
-- 4) duplicates value will be merged into same one (simply with union)
-- 5) keep both duplicates together without merging (union all)

-- combine the actor and customer table by first name with merging duplicates
select first_name from actor
union -- merging duplicates
select first_name from customer
order by 1;

-- combine the actor and customer table by first name keepting duplicates
select first_name from actor
union all -- keep duplicates
select first_name from customer
order by 1;

-- keep the duplicates from customer and actor table but indicate which name is from which tables
select first_name, 'actor' from actor -- use '' to indicate the table that name attached to
union all -- keep duplicates
select first_name, 'customer' from customer
order by 1;

-- combine actor, customer and staff tables with indicating corresponding names and naming the first column with upper case
select upper(first_name) as upper_case_first_name, 'actor' as origin_tables from actor -- union only focuses on the first table, the order matters
union
select first_name, 'customer' from customer
union
select first_name, 'staff' from staff
order by 1;

-- Subquery: query within a query
-- subquery in where: it can be value that can be filtered within where clause

-- find the record where amount are above average
select *
from payment
where amount > (select avg(amount) from payment);

-- get all of payment from customer called adam
select *
from payment
where customer_id = (select customer_id from customer where first_name = 'ADAM');

-- select all of films where length is longer than the average of all films
select *
from film
where length > (select avg(length) from film);

-- return all of films that are available in inventory in store 2 more than 3 times
select *
from film
where film_id in 
(
select film_id 
from inventory 
where store_id = 2 
group by film_id 
having count(*) > 3
);

-- return all customer's first names and last names that have made a payment on '2020-01-25'
select first_name,
last_name
from customer
where customer_id in
(
select customer_id
from payment
where payment_date between '2020-01-25' and '2020-01-26'
-- where date(payment_date) = '2020-01-25'
);

-- return all customer's first name and email addresses that have spent a more than $30
select first_name,
email
from customer
where customer_id in
(
select customer_id
from payment
group by customer_id
having sum(amount) > 30
);

-- return all customers' first and last names that are from california and have spent more than 100 in total.
select first_name,
last_name
from customer
where address_id in
(
select customer_id
from customer
inner join address
on address.address_id = customer.address_id
where district = 'California'
)
and
customer_id in
(
select customer_id
from payment
group by customer_id
having sum(amount) > 100
);

-- subquery in from clause
-- create a table as subquery and query from the table

-- find out the average life-time spend per customer
select
round(avg(total_amount), 2) as avg_lifetime_spent
from 
(
select customer_id, 
sum(amount) as total_amount
from payment
group by customer_id
);

-- what is average total amount spent per day (average daily revenue)?
select round(avg(total_amount), 2) as avg_daily_revenue
from 
(
select date(payment_date),
sum(amount) as total_amount
from payment
group by date(payment_date)
);

-- subquery in select clause
-- it will create a new column in the existing table with same value in each row with certain value
-- the select subquery has to be the single value so that it can be append to each row

-- attach the average amount for the payment table
select
*,
(
select round(avg(amount), 2) 
from payment
) -- a new info of average for each row
from payment;

-- show all payments together with how much the payment amount is below the maximum payment amount
select
*,
(
select max(amount)
from payment) - amount as difference -- it will return the difference between row amount with max amount
from payment;


-- Correlated subqueries: a correlated subquery is executed once for every row considered by the outer query
-- Filtering rows based on group-level conditions
-- Validating conditions per row based on related data
-- Checking existence or absence of related data (via EXISTS, NOT EXISTS)

-- correlated subquery in where clause

-- Find Employees sales More Than Their city's average
-- select first_name, sales
-- from employees e1
-- where sales > 
-- (
-- select avg(sales)
-- from employees e2
-- where e1.city = e2.city
-- )
-- In this case, we use the same table (employee) where e1 is outer query that is referenced by inner subquery e2
-- it is like group by where we use subquery to group by the same value under one column (inner query) to filter under the same table (outer query)
-- Rules: 1) subquery doesn't work independently.
-- 2) subquery gets eveluated for every single row.


-- show only those payment that have the highest amount per customer
select *
from payment p1
where amount =
(
select max(amount)
from payment p2
where p1.customer_id = p2.customer_id -- we must use customer_id since we need to compare per customer
)
order by 2;

-- show only those movies titles, their associated film_id and replacement_cost with the lowest replacement_costs for in each rating category - also show rating
select title,
film_id, 
replacement_cost,
rating
from film f1
where replacement_cost =
(
select min(replacement_cost)
from film f2
where f1.rating = f2.rating
);

-- show only those movie titles, their associated film_id and the length that have the highest length in each rating category - also show rating
select title,
film_id,
length,
rating
from film f1
where length =
(
select max(length)
from film f2
where f1.rating = f2.rating
);

-- correlated subquery in select clause
-- attach to the additional information by where filtering inside inner query to each group in the outer query

-- Show me all employees whose sales are above the average sales in their city. For each of those employees, also show the minimum sales in their city.
-- select first_name,
-- sales,
-- (
-- select min(sales)
-- from employees e3
-- where e1.city = e3.city
-- )
-- from employees e1
-- where sales >
-- (
-- select avg(sales)
-- from employees e2
-- where e1.city = e2.city
-- )

-- show maximum amount for every customer
select *,
(select max(amount)
from payment p1
where p1.customer_id = p2.customer_id)
from payment p2
order by customer_id;

-- show all the payment plus the total amount for every customer as well as the number of payments of each customer
select *,
(
select sum(amount)
from payment p1
where p1.customer_id = p2.customer_id
),
(
select count(payment_id)
from payment p3
where p3.customer_id = p2.customer_id
)
from payment p2
order by customer_id;

-- show only those films with the highest replacement costs in their rating category plus show the average replacement cost in their rating category
select title,
replacement_cost,
rating,
(
select round(avg(replacement_cost), 2) as avg_replacement_cost
from film f1
where f1.rating = f2.rating
)
from film f2
where replacement_cost = 
(
select max(replacement_cost)
from film f3
where f2.rating = f3.rating
);

-- show only those payments with the highest payment for each customer's first name - including payment_id of that payment.
select first_name, amount, payment_id
from payment p1
inner join customer c
on p1.customer_id = c.customer_id
and amount = 
(
select max(amount)
from payment p2
where p1.customer_id = p2.customer_id
);