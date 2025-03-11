-- Select keyword: select colA, colB from table

select first_name, last_name from actor

-- select * from table: get all info from the table

-- practice
select * 
from address

select 
address, district 
from address 

-- get list of all customers with first name, last name and customer's email address
select 
first_name, 
last_name,
email
from customer

-- order by clause: order results based on column
-- select colA, colB from table order by colA, colB (ASC, DESC)

select first_name, last_name
from actor
order by first_name desc

select *
from payment
order by customer_id asc, amount desc

-- practice
-- order the customer list by last name starting from "Z" and work to "A"
select last_name
from customer
order by last_name desc, first_name desc

-- select distinct col1 from table: we filter the distinct value under columns from the table
-- distinct clause will distinct with all columns combination and taking them as a whole
select 
distinct first_name,
last_name
from actor
order by first_name

select distinct rating, rental_duration from film

-- practice
-- ask different prices taht have been paid from high to low
select distinct
amount
from payment
order by amount desc

-- Limit clause: used to limit # of rows in the output
-- limit is at very end of the query
-- select col1, col2 from table limit n

select distinct
first_name
from actor
order by first_name
limit 4

-- Count() function: used to count # of rows in the given table
-- count(*) = count(col) but keep in mind that null value will not be counted when selecting only 1 column. Generally we will use count(*) to get whole picture
-- select count(*) from table
-- select count(col) from table

select count (distinct first_name) from customer

-- practice
create a list of all the distinct districts customers are from
select distinct district
from address

-- what is the lastest rental date
select rental_date
from rental
order by rental_date desc
limit 1

-- How many films does a company have?
select count(distinct film_id)
from film

-- How many distinct last names of the cutomers are there?
select count(distinct last_name)
from customer





















