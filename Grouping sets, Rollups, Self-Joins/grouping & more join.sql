-- Create grouping in different query together into one
-- combine this A
select
staff_id,
sum(amount)
from payment
group by staff_id;

-- and this B
select
to_char(payment_date, 'Month') as month,
sum(amount)
from payment
group by to_char(payment_date, 'Month');

-- we can use UNION to create a common column to group by

select
null as month, -- create a common column for B
staff_id,
sum(amount)
from payment
group by staff_id

union

select
to_char(payment_date, 'Month') as month,
null as staff_id, -- create a common column for A
sum(amount)
from payment
group by to_char(payment_date, 'Month');

-- Grouping sets
-- group multiple columns
select
to_char(payment_date, 'Month') as month,
staff_id,
sum(amount)
from payment
group by
grouping sets (
(staff_id),
(month),
(staff_id, month)
)
order by 1, 2;

-- write a query that returns sum of amount for each customer (first and last name) and each staff_id. Also add overall revenue per customer
select
first_name,
last_name,
staff_id,
sum(amount)
from customer c
left join payment p
on c.customer_id = p.customer_id
group by
grouping sets(
(first_name, last_name),
(first_name, last_name, staff_id)
);

-- write a query that calculates now the share of revenue each staff_id makes per customer
select
first_name,
last_name,
staff_id,
sum(amount) as total,
round(100 * sum(amount) / first_value(sum(amount)) over (partition by first_name, last_name order by sum(amount) desc), 2) as percentage
from customer c
left join payment p
on c.customer_id = p.customer_id
group by
grouping sets(
(first_name, last_name),
(first_name, last_name, staff_id)
);

-- Cube & Rollup (subclause under groupby clause)
-- group by rollup(col1, col2, col3)
-- columns under rollup will be ranking from large to small

-- group by
-- grouping sets(
-- (col1, col2, col3),
-- (col1, col2),
-- (col1)
-- )

-- equal to

-- group by
-- rollup(
-- col1, col2, col3
-- )

-- create a hierachy in payment table in date
select 
'Q' || to_char(payment_date, 'Q') as quarter,
extract(month from payment_date) as month,
date(payment_date),
sum(amount)
from payment
group by
rollup -- need to pay attention of the data ranking from large to small)
(
'Q' || to_char(payment_date, 'Q'),
extract(month from payment_date),
date(payment_date)
)
order by 1, 2, 3;

-- write a query thatb calculates a booking amount rollup for hierarchy of quarter, month, week in the month and day
select
extract (quarter from book_date) as quarter,
extract (month from book_date) as month,
to_char(book_date, 'w') as week_in_month,
date(book_date),
sum(total_amount)
from bookings
group by
rollup
(
extract (quarter from book_date),
extract (month from book_date),
to_char(book_date, 'w'),
date(book_date)
)
order by 1, 2, 3, 4;

-- CUBE function
-- group by
-- cube(col1, col2, col3)
-- cube function can enable all possible combination of the columns under groupby function

-- group by
-- grouping sets(
-- (col1, col2, col3),
-- (col1, col2),
-- (col1, col3),
-- (col2, col3),
-- (col1),
-- (col2),
-- (col3),
-- ()
-- )

-- equal to

-- group by
-- cube(
-- col1, col2, col3
-- )

-- what are the totals per customer, per staff ID, per day
-- obtain all possible subtotals without considering hierarchy ordering
select 
customer_id,
staff_id,
date(payment_date),
sum(amount)
from payment
group by
cube(
customer_id,
staff_id,
date(payment_date)
)
order by 1, 2, 3;

-- Write a query that returns all grouping sets in all combinations of customer_id, date and title with the aggregation of the payment amount.
SELECT 
p.customer_id,
DATE(payment_date),
title,
SUM(amount) as total
FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
GROUP BY 
CUBE(
p.customer_id,
DATE(payment_date),
title
)
ORDER BY 1,2,3;

-- self join (use the same table twice)
-- we want to find the referencing column to the target column in the same table
-- select 
-- t1.col1,
-- t2.col1,
-- from table1 t1
-- left join table1 t2
-- on t1.col1 = t2.col2

-- create a table
CREATE TABLE employee (
	employee_id INT,
	name VARCHAR (50),
	manager_id INT
);

INSERT INTO employee 
VALUES
	(1, 'Liam Smith', NULL),
	(2, 'Oliver Brown', 1),
	(3, 'Elijah Jones', 1),
	(4, 'William Miller', 1),
	(5, 'James Davis', 2),
	(6, 'Olivia Hernandez', 2),
	(7, 'Emma Lopez', 2),
	(8, 'Sophia Andersen', 2),
	(9, 'Mia Lee', 3),
	(10, 'Ava Robinson', 3);

-- self join manager of the previous employee's manager
select
emp.employee_id,
emp.name as employee,
mng.name as manager,
mng2.name as manager_of_manager
from employee emp
left join employee mng
on emp.manager_id = mng.employee_id
left join employee mng2
on mng.manager_id = mng2.employee_id;


-- find all the pairs of films with the same length (attention: need to prevent the same title twice in the table)
select
f1.title,
f2.title,
f2.length
from film f1
left join film f2
on f1.length = f2.length
where f1.title <> f2.title
order by length desc;

-- cross join (cartesian product in  multiple tables without common columns)
-- it can get all possible combination of rows (will not eliminate the duplicate rows)
-- select
-- t1.col1,
-- t2.col1
-- from table1 t1
-- cross join table2 t2 -- (no common columns in 2 tables)

select
staff_id,
store.store_id,
last_name,
store.store_id * staff_id
from staff
cross join store;

-- natural join (no need to indicate the common columns)
-- working as normal join
-- automatically join using columns with the same column name
select 
first_name,
last_name,
sum(amount)
from payment
natural inner join customer
group by first_name, last_name;

-- natural join will automatically join 2 table with any common columns in common
-- last_update and address_id appear in both tables, and there is no match in the 2 tables
select *
from customer 
natural inner join address -- there is no value for 2 table when using natural join









