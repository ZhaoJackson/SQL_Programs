-- Aggregation Function: aggregate values in multiple rows to one value
-- SUM(), AVG(), MIN(), MAX(), COUNT()
-- Once we use aggregation function, we cannot include other columns in the select statement


-- get the sum of the amount
select
sum(amount)
from payment;

-- count # of records from payment
select
count(*)
from payment;

-- use multiple aggregation function
select 
sum(amount),
count(*),
avg(amount)
from payment;

-- round(aggregation function, # of decimal to keep)
select 
round(avg(amount), 2) as average
from payment;

-- practice
-- write a query to see the min, max, avg, and sum of the replacement cost of film
select
min(replacement_cost),
max(replacement_cost),
round(avg(replacement_cost), 2) as average,
sum(replacement_cost)
from film;

-- Grouping data
-- aggregate the records that share the same values under designated column with aggregation function.
-- the columns for grouping should be different from the aggregated columns
-- enable to get picture of how records in the same group with corresponding calculation
-- selected column must be either in aggregated function or group by clause

-- how each customer spend in the payment
select
customer_id, -- using group by can enable the combination of column and aggregation function together. 
sum(amount)
from payment
where customer_id > 3 -- where always comes before group by
group by customer_id
order by 2 desc;


-- which of 2 employees is responsible for more payments without considering 0 amount?
select
staff_id,
sum(amount),
count(payment_id)
from payment
where amount != 0
group by staff_id;

-- group by multiple columns: no limits of how many # of columns to be grouped by
-- which employees that have highest amount of payments with one sepcific customer
select
staff_id,
customer_id,
sum(amount)
from payment
group by staff_id, customer_id
order by 3 desc
limit 1;

-- Date function: date(col) will create a new column based on the timestamp on col
-- which employee had the highest sales amount in a single day?
select 
staff_id,
sum(amount),
date(payment_date)
from payment
group by staff_id, date(payment_date)
order by 2 desc
limit 1;

-- which employee had the most sales in a single day(not counting payment with amount = 0)?
select 
staff_id,
count(*) as num_of_sales,
date(payment_date)
from payment
where amount != 0
group by staff_id, date(payment_date)
order by 2 desc
limit 1;


-- Having clause: filter aggregation function
-- having can make advance filtering for the aggregation result and perform similarly with where clause
-- it only takes place with groupby function and filter groupings by aggregations

-- see sums and customers groupings where sum greater than 200
select 
customer_id,
sum(amount)
from payment
group by customer_id
having sum(amount) > 200;


-- which employee had the most sales in a single day(not counting payment with amount = 0) where the number of sales the greater than 400?
select 
staff_id,
count(*) as num_of_sales,
date(payment_date)
from payment
where amount != 0
group by staff_id, date(payment_date)
having count(*) > 400
order by 2 desc;

-- find what is average payment amount grouped by customer and day - consider only days/customers with more than 1 payment (per customer and day) in 2020, april 28, 29, and 30
select
customer_id,
round(avg(amount), 2) as average,
count(*) as num_of_payment,
date(payment_date)
from payment
where date(payment_date) in ('2020-04-28', '2020-04-29', '2020-04-30')
group by customer_id, date(payment_date)
having count(*) > 1
order by 2 desc;