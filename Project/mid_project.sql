-- Question 1:
-- Level: Simple
-- Topic: DISTINCT
-- Task: Create a list of all the different (distinct) replacement costs of the films.
-- Question: What's the lowest replacement cost? - 9.99

select
distinct(replacement_cost)
from film
order by 1
limit 1;

-- Question 2:
-- Level: Moderate
-- Topic: CASE + GROUP BY
-- Task: Write a query that gives an overview of how many films have replacements costs in the following cost ranges
-- low: 9.99 - 19.99
-- medium: 20.00 - 24.99
-- high: 25.00 - 29.99
-- Question: How many films have a replacement cost in the "low" group? - 514

select
case
when replacement_cost between 9.99 and 19.99 then 'Low'
when replacement_cost between 20.00 and 24.99 then 'Medium'
when replacement_cost between 25.00 and 29.99 then 'High'
end as category,
count(*)
from film
group by category;

-- Question 3:
-- Level: Moderate
-- Topic: JOIN
-- Task: Create a list of the film titles including their title, length, and category name ordered descendingly by length. 
-- and Filter the results to only the movies in the category 'Drama' or 'Sports'.
-- Question: In which category is the longest film and how long is it? - Sports with 184

select
title,
length,
name
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category c
on fc.category_id = c.category_id
where name = 'Drama' or 
name = 'Sports'
order by length desc
limit 1;

-- Question 4:
-- Level: Moderate
-- Topic: JOIN & GROUP BY
-- Task: Create an overview of how many movies (titles) there are in each category (name).
-- Question: Which category (name) is the most common among the films? - Sports with 74 titles

select
name,
count(*) as num_of_titles
from film f
inner join film_category fc
on f.film_id = fc.film_id
inner join category c
on fc.category_id = c.category_id
group by name
order by 2 desc
limit 1;

-- Question 5:
-- Level: Moderate
-- Topic: JOIN & GROUP BY
-- Task: Create an overview of the actors' first and last names and in how many movies they appear in.
-- Question: Which actor is part of most movies? - Susan Davis with 54 movies

select
first_name,
last_name,
count(*)
from actor a
inner join film_actor fa
on a.actor_id = fa.actor_id
inner join film f
on fa.film_id = f.film_id
group by first_name, last_name
order by 3 desc
limit 1;

-- Question 6:
-- Level: Moderate
-- Topic: LEFT JOIN & FILTERING
-- Task: Create an overview of the addresses that are not associated to any customer.
-- Question: How many addresses are that? - 4

select
address
from address a
left join customer c
on a.address_id = c.address_id
where customer_id is null;

-- Question 7:
-- Level: Moderate
-- Topic: JOIN & GROUP BY
-- Task: Create the overview of the sales to determine the from which city 
-- (we are interested in the city in which the customer lives, not where the store is) most sales occur.
-- Question: What city is that and how much is the amount? - Cape Coral with 221.55

select
city,
sum(amount) as total_sales
from city c
inner join address a
on c.city_id = a.city_id
inner join customer cs
on a.address_id = cs.address_id
inner join payment p
on cs.customer_id = p.customer_id
group by city
order by 2 desc;

-- Question 8:
-- Level: Moderate to difficult
-- Topic: JOIN & GROUP BY
-- Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".
-- Question: Which country, city has the least sales? - United States, Tallahassee with 50.85

select
country || ', ' || city as "country with city",
sum(amount)
from country ct
inner join city c
on ct.country_id = c.country_id
inner join address a
on c.city_id = a.city_id
inner join customer cs
on a.address_id = cs.address_id
inner join payment p
on cs.customer_id = p.customer_id
group by country, city
order by 2;

-- Question 9:
-- Level: Difficult
-- Topic: Uncorrelated subquery
-- Task: Create a list with the average of the sales amount each staff_id has per customer.
-- Question: Which staff_id makes on average more revenue per customer? - staff_id 2 with 56.64

select
staff_id,
round(avg(total_amount), 2) as avg_sales
from
(
select
customer_id,
staff_id,
sum(amount) as total_amount
from payment
group by customer_id, staff_id
)
group by staff_id;

-- Question 10:
-- Level: Difficult to very difficult
-- Topic: EXTRACT + Uncorrelated subquery
-- Task: Create a query that shows average daily revenue of all Sundays.
-- Question: What is the daily average revenue of all Sundays? -- 1410.65

select
round(avg(total_amount), 2) as avg_sunday_sales
from
(
select
date(payment_date) as date,
sum(amount) as total_amount
from payment
where extract(dow from payment_date) = 0
group by date(payment_date)
);

-- Question 11:
-- Level: Difficult to very difficult
-- Topic: Correlated subquery
-- Task: Create a list of movies - with their length and their replacement cost 
-- that are longer than the average length in each replacement cost group.
-- Question: Which two movies are the shortest on that list and how long are they?

select
title,
replacement_cost,
length
from film f2
where length >
(
select
avg(length)
from film f1
where f1.replacement_cost = f2.replacement_cost
)
order by 3
limit 2;

-- Question 12:
-- Level: Very difficult
-- Topic: Uncorrelated subquery
-- Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.
-- Question: Which district has the highest average customer lifetime value? -- Saint-Denis with 216.54

select
district,
round(avg(total_amount), 2) as avg_lifetime_value
from 
(
select
district,
c.customer_id,
sum(amount) as total_amount
from address a
inner join customer c
on a.address_id = c.address_id
inner join payment p
on c.customer_id = p.customer_id
group by district, c.customer_id
)
group by district
order by 2 desc;

-- Question 13:
-- Level: Very difficult
-- Topic: Correlated query
-- Task: Create a list that shows all payments including the payment_id, amount, and the film category (name) plus the total amount that was made in this category. 
-- Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.
-- Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'? - total revenue is 4375.85 with lowest payment_id 16055

select
payment_id,
amount,
name,
(
select sum(amount) as total_revenue
from payment p
left join rental r
on r.rental_id = p.rental_id
left join inventory i
on i.inventory_id = r.inventory_id
left join film f
on f.film_id = i.film_id
left join film_category fc
on fc.film_id = f.film_id
left join category c1
on c1.category_id = fc.category_id
where c1.name = c2.name
)
from payment p
left join rental r
on r.rental_id = p.rental_id
left join inventory i
on i.inventory_id = r.inventory_id
left join film f
on f.film_id = i.film_id
left join film_category fc
on fc.film_id = f.film_id
left join category c2
on c2.category_id = fc.category_id
where name = 'Action'
order by 4;

-- Question 14:
-- Level: Extremely difficult
-- Topic: Correlated and uncorrelated subqueries (nested)
-- Task: Create a list with the top overall revenue of a film title (sum of amount per title) for each category (name).
-- Question: Which is the top-performing film in the animation category? - Dogma Family with revenue 178.7

select
title,
name,
sum(amount) as total_revenue
from payment p
left join rental r
on r.rental_id = p.rental_id
left join inventory i
on i.inventory_id = r.inventory_id
left join film f
on f.film_id = i.film_id
left join film_category fc
on fc.film_id = f.film_id
left join category c1
on c1.category_id = fc.category_id
group by title, name
having sum(amount) = 
(
select
max(total_revenue)
from
(
select
title,
name,
sum(amount) as total_revenue
from payment p
left join rental r
on r.rental_id = p.rental_id
left join inventory i
on i.inventory_id = r.inventory_id
left join film f
on f.film_id = i.film_id
left join film_category fc
on fc.film_id = f.film_id
left join category c2
on c2.category_id = fc.category_id
group by title, name
) as subquery
where c1.name = subquery.name
);