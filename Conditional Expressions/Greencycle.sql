-- Math functions and Operators (https://www.postgresql.org/docs/current/functions-math.html)
-- a + b
-- a - b
-- a * b
-- a / b: the result is truncated without decimal value if a is integer (9 / 4 = 2)
-- a / b will retain decimal place only when a is a float (9.0 / 4 = 2.25000)
-- a % b: remainder of a / b
-- a ^ b

-- abs(x): Absolute values on abs(-7) = 7
-- round(x, d): round x to d decimal places (round(2.2224, 2)) = 2.22
-- ceiling(x): round x up to integer: ceiling(4.3542) = 5
-- floor(x): round x down to interger: floor(4,3542) = 4

-- add rental rate by 10%
select
film_id,
rental_rate,
round(rental_rate * 1.1, 2) as new_rental_rate
from film;

-- create a list of films including relation of rental rate / replacement cost where the rental rate is less than 4% of replacement cost
select
film_id,
rental_rate,
replacement_cost,
round(rental_rate / replacement_cost * 100, 2) as percentage
from film
where rental_rate / replacement_cost * 100 < 4
order by 4;

-- Case when statement
-- it goes through a set of conditions returns a value if a condition is met

-- case
-- when condition1 then result1 -- when the first condition is met, the result1 will be given
-- when condition2 then result2
-- when condition3 then result3
-- else result -- optional: when all the condtions are failed, it will return result as else.
-- end

-- categorize the amount
-- it will create another column based on column to be classified
select 
amount,
case
when amount < 2 then 'Low Amount' -- when amount is less than 2
when amount < 5 then 'Medium Amount' -- when amount is between 2 and 5
else 'High Amount'
end as categories
from payment;

-- create tier list in the following way:
-- rating is 'PG' or 'PG-13' or length is more than 210 min: 'Great rating or long (tier1)'
-- Description contains 'Drama' and length is more than 90min: 'Long Drama(tier2)'
-- Description contains 'Drama' and length is not more than 90min: 'Short Drama(tier3)'
-- Rental_rate less than $1: 'Very Cheap(tier 4)'
-- how can you filter to only those movies that appear in one of these 4 tiers?
select
rating,
length,
description,
rental_rate,
case
when rating in ('PG', 'PG-13') or length > 210 then 'Great rating or long (tier1)'
when description like '%Drama%' and length > 90 then 'Long Drama (tier2)'
when description like '%Drama%' and length < 90 then 'Short Drama (tier3)'
when rental_rate < 1 then 'Very Cheap (tier4)'
end as list
from film
where -- we have to do it again instead of justing using alias after 'where' clause
case
when rating in ('PG', 'PG-13') or length > 210 then 'Great rating or long (tier1)'
when description like '%Drama%' and length > 90 then 'Long Drama (tier2)'
when description like '%Drama%' and length < 90 then 'Short Drama (tier3)'
when rental_rate < 1 then 'Very Cheap (tier4)'
end is not null; -- since we only need to show the movies in those 4 tiers, we need to exclude the rest of null value



-- case when & sum
-- we can count the categories with different cases into '1' or '0' so that we can use sum() to count each categories
-- we apply case when into sum() function so we need to keep in mind of using group by
select
sum(case
when rating in ('PG', 'G') then 1
else 0
end) as no_of_ratings_with_g_or_pg
from film;

-- table pivot format -- using sum(case when)
-- to make the alias upper case, we must use "", where "" will enable to match the exact same thing
select
rating,
count(*)
from film
group by rating; -- it is normal table

-- pivot table by using sum(case when)
select
sum(case when rating = 'G' then 1 else 0 end) as "G",
sum(case when rating = 'PG-13' then 1 else 0 end) as "PG-13",
sum(case when rating = 'R' then 1 else 0 end) as "R",
sum(case when rating = 'NC-17' then 1 else 0 end) as "NC-17",
sum(case when rating = 'PG' then 1 else 0 end) as "PG"
from film;


-- label the return date as 'Not_returned'
select
coalesce(cast(return_date as varchar), 'Not Returned') as labeled
from rental;






























