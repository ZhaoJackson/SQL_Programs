-- update
-- update <table> set <column> = value -- change the column values

-- Update all values under genre into 'Country Music'
update songs
set genre = 'Country Music';
select * from songs;

-- Update the specific rows under the column
update songs
set genre = 'Pop Music'
where song_id = 4; -- use PK as filter
select * from songs;

-- change the last name of first customer to 'BROWN'
select * from customer;

update customer
set last_name = 'BROWN'
where customer_id = 1;

select * from customer
order by customer_id;

-- set the email address to lower case
select * from customer;

update customer
set email = lower(email);

select * from customer
order by customer_id;

-- update all rental prices that are 0.99 to 1.99
select * from film; -- find the rental rate (same as rental price)

update film
set rental_rate = 1.99
where rental_rate = 0.99;

select * from film
order by rental_rate;

-- customer table needs to be altered
-- 1. add column initials (datatype varchar(10))
alter table customer
add column initials varchar(10);

-- 2. update values to the actual initials for example Frank Smith should be F.S.
update customer
set initials = left(first_name, 1) || '.' || left(last_name, 1) || '.';

select * from customer;

-- Delete
-- command to delete the certain rows in the table
-- delete from <table> where condition

delete from songs
where song_id = 4 -- delete the row in the table songs where the rows have song_id = 4

-- delete the mutiple rows with multiple conditions
delete from songs
where song_id in (3, 4)
returning song_id -- returning indicates which rows that we want to see that have been deleted

-- Create a table in songs
drop table songs;

CREATE TABLE songs (
    song_id SERIAL PRIMARY KEY,
    song_name VARCHAR(100),
    genre VARCHAR(50),
    price DECIMAL(5, 2),
    release_date DATE
);

-- Insert the rows in the table songs
insert into songs (
song_name, genre, price, release_date
)
values
('Have a take with Data', 'chill out', 5.99, '2022-01-06'),
('Tame the Data', 'Classical', 4.99, '2022-01-06');

select * from songs;

-- delete the genre 'chill out' in table songs
delete from songs
where genre = 'chill out';

select * from songs;

-- delete rows in the payment table with payment_id 17064 and 17067
select * from payment;

delete from payment
where payment_id in ('17064', '17067');

select * from payment;

-- create table ... as
-- create a new table based on the selecting query in the existing table

-- create a new table which includes customer_id and initials in customer table where first name starting "C"
create table customer_anonymous
as
select customer_id, initials
from customer
where first_name like 'C%';

select * from customer_anonymous;

-- create a new table from customer, address and city tables
create table customer_address
as
select first_name, last_name, email, address, city
from customer c
left join address a
on c.address_id = a.address_id
left join city ci
on ci.city_id = a.city_id;

select * from customer_address

-- create a table from customer and payment table where concatenate first and last names and get the total amount for each customer

create table customer_spendings
as
select 
first_name || ' ' || last_name as name,
sum(amount) as total_amount
from customer c
left join payment p
on c.customer_id = p.customer_id
group by first_name || ' ' || last_name

select * from customer_spendings
order by total_amount

-- Create view
-- since create a table will physically store in the dataset which will take lots of space
-- creating a view will not take any space and storage in the database but still grant the view for later reference
-- creating a view will grant the later access to the view table without taking any space in the storage

create view customer_anonymous -- the table will not be stored in the dataset but still can be accessed for later query
as
select customer_id, initials
from customer
where first_name like 'C%';

select * from customer_anonymous;

-- create view table for customer_spending
-- make sure it will only appear in the Views but not in the tables under datasets
drop table customer_spendings;

create view customer_spendings
as
select 
first_name || ' ' || last_name as name,
sum(amount) as total_amount
from customer c
left join payment p
on c.customer_id = p.customer_id
group by first_name || ' ' || last_name;

select * from customer_spendings
order by total_amount;

-- Create a view called films_category that shows a list of the film titles including their title, length and category name ordered descendingly by the length.
-- Filter the results to only the movies in the category 'Action' and 'Comedy'.

create view films_category
as
select title, length, name
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on fc.category_id = c.category_id
where name in ('Action', 'Comedy')
order by length desc;

select * from films_category;

-- create materialized view
-- to solve the problem where the table will not be updated if data in the underlying tables changes
-- we combine the benefit the create table and view where data is stored phycially
-- data is stored physically and performance is ensured
-- we can update the data by refresh MV by 'refresh materialized view <view_name>'

create materialized view mv_film_category
as
select title, length, name
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on fc.category_id = c.category_id
where name in ('Action', 'Comedy')
order by length desc;

select * from mv_film_category;

-- update the length for title 'SATURN NAME'
update film
set length = 192
where title = 'SATURN NAME'

-- the materialized view can be also updated by using refreshing command 
refresh materialized view mv_film_category; -- the udpate in the original table will be reflected to the mv table

select * from mv_film_category

-- Managing views 
-- we can alter and drop the view and materialized view
-- we can also create and replace the view to modify the entire view

-- drop view and MV
drop view customer_anonymous

drop materialized view customer_anonymous

-- alter view and MV by renaming
-- rename the view's name 
alter view customer_anonymous
rename to v_customer_info

-- rename view's column
alter view v_customer_info
rename column name to cutomer_name

-- create or replace the view: it will enable 2 options where if the view will be created if there isn't yet or be replaced with newly created query
-- only works with standard view, not MV
create or replace view v_customer_info
as new_query

-- In this challenge, we use again the view v_customer_info that we have previously created:

CREATE VIEW v_customer_info
AS
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id;

-- 1) Rename the view to v_customer_information.
alter view v_customer_info
rename to v_customer_information;

-- 2) Rename the customer_id column to c_id.
alter view v_customer_information
rename column customer_id to c_id;

-- 3) Add also the initial column as the last column to the view by replacing the view.
drop view v_customer_information;

create or replace view v_customer_information
as
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country,
	concat(left(cu.first_name, 1) || '.' || left(cu.last_name, 1) || '.') as initials
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id;

select * from v_customer_information;


-- Import and Export the external table
-- creat a table
CREATE TABLE sales (
transaction_id SERIAL PRIMARY KEY,
customer_id INT,
payment_type VARCHAR(20),
creditcard_no VARCHAR(20),
cost DECIMAL(5,2),
quantity INT,
price DECIMAL(5,2));

select * from sales

-- we will need to import the data from csv file to there

-- Import
-- 1. define the file path (/Users/jacksonzhao/Desktop/SQL_Programs/View & Data Manipulation/Fact_sales.csv)

-- 2. click the table created in the database and choose 'import and export' and clike import

-- 3. import the data and past the file path and choose header to skip the column titles

-- 4. refresh will show the data imported

-- Export
-- 1. click the table created in the database and choose 'import and export' and clike export

-- 2. define the file path to export to (/Users/jacksonzhao/Desktop/SQL_Programs/View & Data Manipulation/Sales.csv)

-- 3. export the data and past the file path and choose header and use UTF8

-- 4. the data will be send to the file folder