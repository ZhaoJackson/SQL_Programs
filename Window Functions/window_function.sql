-- Window Function
-- we can use window function to append a column which shows the aggreagted result for each rows without needing to compile the same group
-- it can preserve the every row's detail with appending its aggregated results
-- it aims to work with aggregations over subsets of data without collapsing rows.

-- correlated subquery in select clause
-- it can filter or reduce rows, often returns a single value or set
-- it can operate the same by appending aggregated result

-- correlated subquery
-- it can group the same customer_id with their price in transaction while preserving each individual row
select
transaction_id,
payment_type,
customer_id,
price_in_transaction,
(
select sum(price_in_transaction)
from sales s2
where s2.customer_id = s1.customer_id
)
from sales s1;

-- window function
-- this will operate the same
select
transaction_id,
payment_type,
customer_id,
price_in_transaction,
sum(price_in_transaction) over(partition by customer_id)
from sales;

-- OVER clause
-- agg(agg_column) over(partition by partition column)
-- it can perform aggregation function for the column based on the other columns to be grouped
-- for partition by, it plays as group by, but it's operated as a window where still preserving all rows without collapsing them in the dataset

-- get each customer's total amount and count each regarding to customer_id
select *,
sum(amount) over(partition by customer_id),
count(*) over(partition by customer_id)
from payment;

-- get the total number of trasaction for whole table (total # of rows)
select *,
count(*) over()
from payment;

-- get the total average amount and append for each row
select *,
round(avg(amount) over (), 2)
from payment;

-- write a query that returns the list of movies including 
-- film_id, title, length, category, average length of movies in that category

select 
f.film_id, 
title, 
length, 
name,
round(avg(length) over(partition by name), 2) as avg_length
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on fc.category_id = c.category_id
order by 1;

-- write a query that returns all payment details including number of payment that were made by this customer and that amount
select *,
count(*) over(partition by customer_id, amount) as num_of_payment
from payment
order by 1;

-- use over(order by()) to increment each value for each row 
-- it can increment each value based on summation of previous ones regarding to the column under order by clause
select *,
sum(amount) over(order by payment_date)
from payment;

-- we can combine partition and order by together
-- for each group under partition by, its value can be incremented with order by
-- when moving to the next group under partition by, its value can be started over and incremented within that group
select *,
sum(amount) over(partition by customer_id order by payment_id)
from payment
order by 2;

-- write a query that returns running total of how late the flights are (difference between actual_arrival and scheduled arrival) order by flight_id 
-- including departure airport
select 
flight_id,
departure_airport,
actual_arrival - scheduled_arrival as difference,
sum(actual_arrival - scheduled_arrival) over(order by flight_id)
from flights
where actual_arrival is not null;

-- calculate the same running total but partition by departure airport
select 
departure_airport,
actual_arrival - scheduled_arrival as difference,
sum(actual_arrival - scheduled_arrival) over(partition by departure_airport order by flight_id)
from flights
where actual_arrival is not null;


-- Rank()
-- create a ranking for each partition
-- it assigns a ranking number to each row within a partition, based on the ordering of values.
select
f.title,
c.name,
f.length,
rank() over(order by length desc) -- the problem is that the next rank will start based on its index number where the rank will change to its length index if goes to next one
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on c.category_id = fc.category_id;

-- Dense_rank()
-- it enables the ranking changes logically rather than following its index number
select
f.title,
c.name,
f.length,
dense_rank() over(order by length desc) -- once the ranking goes to the next one, it will only increment by 1 rather than change rank based on its index number
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on c.category_id = fc.category_id;

-- Dense_rank() over(partition by order by)
-- it enable to have different partitions and have ranking inside each partition
select
f.title,
c.name,
f.length,
dense_rank() over(partition by name order by length desc) -- it allows to rank each length within each name parition
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on c.category_id = fc.category_id;

-- window function cannot be processed under where clause
-- we have to build a subquery for window function in order to filter its condition

-- list the rank regarding length for each category name and sort the rank 2
select *
from
(
select
f.title,
c.name,
f.length,
dense_rank() over(partition by name order by length desc) as rank
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on c.category_id = fc.category_id) a
where rank = 2;

-- write a query that returns customers' name, the country and how many payments they have
select
first_name || ' ' || last_name as name,
country,
count(payment_id)
from customer c
left join payment p
on c.customer_id = p.customer_id
left join address a
on c.address_id = a.address_id
left join city ci
on ci.city_id = a.city_id
left join country co
on ci.country_id = co.country_id
group by first_name || ' ' || last_name, country;

-- create a ranking of the top customers with most sales for each country and filter results to only top 3 customers per country
select *
from
(
select
first_name || ' ' || last_name as name,
country,
count(*),
dense_rank() over(partition by country order by count(*) desc) as rank
from customer c
left join payment p
on c.customer_id = p.customer_id
left join address a
on c.address_id = a.address_id
left join city ci
on ci.city_id = a.city_id
left join country co
on ci.country_id = co.country_id
group by first_name || ' ' || last_name, country
) a
where rank between 1 and 3;

-- First_value(column): append the first value within that partition with specified column
select
first_name || ' ' || last_name as name,
country,
count(payment_id),
first_value(country) over(partition by country order by count(*) desc) as first_value_country,
first_value(count(*)) over(partition by country order by count(*) desc) as first_value,
count(*) - first_value(count(*)) over(partition by country order by count(*) desc) as difference
from customer c
left join payment p
on c.customer_id = p.customer_id
left join address a
on c.address_id = a.address_id
left join city ci
on ci.city_id = a.city_id
left join country co
on ci.country_id = co.country_id
group by first_name || ' ' || last_name, country;

-- Lead & Lag
-- lead gives you access to a following row’s value — it lets you look ahead in your result set without using joins or subqueries.
-- lead(column) over(partition by column order by column)
-- lead() will generate null if there is no lead in following rows
select
first_name || ' ' || last_name as name,
country,
count(payment_id),
lead(country) over(partition by country order by count(*) desc) as next_country,
lead(count(*)) over(partition by country order by count(*) desc) as next_count
from customer c
left join payment p
on c.customer_id = p.customer_id
left join address a
on c.address_id = a.address_id
left join city ci
on ci.city_id = a.city_id
left join country co
on ci.country_id = co.country_id
group by first_name || ' ' || last_name, country;

-- lag allows you to look back at a previous row’s value in your result set without a self-join
select
first_name || ' ' || last_name as name,
country,
count(payment_id),
lag(country) over(partition by country order by count(*) desc) as previous_country,
lag(count(*)) over(partition by country order by count(*) desc) as previous_count
from customer c
left join payment p
on c.customer_id = p.customer_id
left join address a
on c.address_id = a.address_id
left join city ci
on ci.city_id = a.city_id
left join country co
on ci.country_id = co.country_id
group by first_name || ' ' || last_name, country;

-- write a query that returns revenue of day and revenue of the previous day
select
sum(amount),
to_char(payment_date, 'YYYY-MM-DD') as day,
lag(sum(amount)) over(order by to_char(payment_date, 'YYYY-MM-DD')) as previous_amount,
sum(amount) - lag(sum(amount)) over(order by to_char(payment_date, 'YYYY-MM-DD')) as difference_amount
from payment
group by to_char(payment_date, 'YYYY-MM-DD');

-- get the percentage growth compared to the previous day
select
sum(amount),
to_char(payment_date, 'YYYY-MM-DD') as day,
lag(sum(amount)) over(order by to_char(payment_date, 'YYYY-MM-DD')) as previous_amount,
sum(amount) - lag(sum(amount)) over(order by to_char(payment_date, 'YYYY-MM-DD')) as difference_amount,
round((sum(amount) - lag(sum(amount)) over(order by to_char(payment_date, 'YYYY-MM-DD')))
/ 
lag(sum(amount)) over(order by to_char(payment_date, 'YYYY-MM-DD')), 2)
from payment
group by to_char(payment_date, 'YYYY-MM-DD');