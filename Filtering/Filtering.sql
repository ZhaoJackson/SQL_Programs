-- Where Clause: used to filter data in the output 
-- select col1, col2
-- from table
-- where condition

select *
from payment
where amount = 10.99;

-- get the first and last name with first name with 'ADAM'
select first_name,
last_name
from customer
where first_name = 'ADAM';

-- get the # of the amount that is zero
select 
count(*)
from payment
where amount = 0;

-- How many payment were made by the customer which customer_id = 100
select 
count(*)
from payment
where customer_id = 100;

-- What is the last name of customer with first name 'ERICA'
select last_name
from customer
where first_name = 'ERICA';


-- where operator: >, <, =, is null, is not null

-- how rentals have not been returned yet
select 
count(*)
from rental
where return_date is null;

-- how for a list of all the payment_id with an amount less then or equal to $2, including payment_id and the amount
select
payment_id,
amount
from payment
where amount <= 2
order by amount desc;

-- where clause multiple conditions by AND / OR
-- it is used to connect 2 conditions => AND: both conditions need to be true; OR: either condition needs to true
-- select col1, col2 from table where condition 1 and condition 2

-- AND: both need to be true
select * 
from payment
where amount = 10.99
and customer_id = 426;

-- OR: either need to be true
select *
from payment
where amount = 10.99 
or amount = 9.99;

-- AND function always execute first before OR function
select *
from payment
where amount = 10.99 
or amount = 9.99
and customer_id = 426; -- it automatically executes and function first

-- use () to indicate the order of execution
select *
from payment
where (amount = 10.99 
or amount = 9.99)
and customer_id = 426;


-- ask a list of all payment of customer 322, 346, 354 where amount is either less than $2 or greater than $10
select 
customer_id,
amount
from payment
where (customer_id = 322
or customer_id = 346
or customer_id = 354)
and (amount < 2
or amount > 10)
order by 1 asc, 2 desc;


-- standardize the timezone
ALTER DATABASE greencycles SET timezone TO 'Europe/Berlin'; 

-- between value1 and value2
select *
from payment
where payment_id >= 17000
and payment_id <= 18000;

-- similarly
select *
from payment
where payment_id between 17000
and 18000;


-- use 'date' by between and
select *
from payment
where payment_date between '2020-01-24' and '2020-01-26';

-- timestamp
-- between '2020-01-24 0:00' and '2020-01-26 0:00' indicates the everything after 01-24 and before the midnight on 1-26 where 1-26 will not be included.
-- to include 1-26, we have to use between '2020-01-24 0:00' and '2020-01-26 23:59' or between '2020-01-24 0:00' and '2020-01-27 0:00'

-- how many payments have been made on Janunary 26th and 27th 2020 with an amount between 1.99 and 3.99?
select
count(*)
from payment
where payment_date between '2020-01-26 0:00' and '2020-01-28 0:00'
and amount between 1.99 and 3.99;

-- IN() operator can incldue the multiple values in one column selection

-- search by the particular id value
select *
from customer
where customer_id in (123, 212, 323, 243, 353, 432);

-- search by the name (in '')
select *
from customer
where first_name not in ('LYDIA', 'MATTHEW'); -- not in: negation


-- find payment of those customers (12, 25, 67, 93, 124, 234) with amount 4.99, 7.99 and 9.99 in Jan 2020
select *
from payment
where customer_id in (12, 25, 67, 93, 124, 234)
and amount in (4.99, 7.99, 9.99)
and payment_date between '2020-01-01' and '2020-02-01'
order by 5 desc, 6 asc;

-- like '' clause: used to filter by matching against a patter using wildcards _ to represent single character or % to indicate sequence of characters
-- like clause is case-sensitive
select *
from actor
where first_name like 'A%'; -- indicates filter all record under first_name with first letter with 'A' and rest can be anything

select *
from actor
where first_name like '_A%'; -- filter all record with beginning one single random character and rest can be anything

select *
from actor
where first_name not like '_A%'; -- not like is negation to negate any characteristics other than this one

select *
from film
where description like '%Drama%'
and title like '_T%';

-- how many movies that contain 'Documentary' in the description?
select 
count(*)
from film
where description like '%Documentary%';

-- how many customers are there with a first name that is 3 letters and either an 'X' and 'Y' as the last letter in the last name?
select 
count(*)
from customer
where first_name like '___'
and (last_name like '%X'
or last_name like '%Y');

-- comment

-- single line quote '--'
-- how many customers are there with a first name that is 3 letters and either an 'X' and 'Y' as the last letter in the last name?

-- multiple line quotes '/* ..... */'
/* how many customers are there with a first name 
that is 3 letters and either an 'X' and 'Y' as the last letter in the last name? */

-- alias
select payment_id as payment
from payment;


-- practice
-- how many movies are there contain 'Saga' in the description and where the title either starts with 'A' or ends with 'R'
select 
count (*) as no_of_movies
from film
where description like '%Saga%'
and (title like 'A%'
or title like '%R');

-- list of all customers where first name contains 'ER' and has an 'A' as second letter.
select first_name,
last_name
from customer
where first_name like '%ER%'
and first_name like '_A%'
order by last_name desc;

-- how many payments are there where amount is either 0 or is between 3.99 and 7.99 and in the same time has happened on 2020-05-01
select
count(*)
from payment
where (amount = 0
or amount between 3.99 and 7.99)
and payment_date between '2020-05-01' and '2020-05-02';