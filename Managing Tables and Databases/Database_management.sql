-- Managing Tables
-- Data Definition: mainly dealing with database objects and table properties
-- 1. Create and manage database, tables, and schemas
-- 2. Alter the database, objects, structures, and names
-- 3. Drop the objects 

-- Data Manipulation: mainly dealing with data itself
-- 1. Insert data
-- 2. Update rows in table
-- 3. Delete rows in table

-- 1. Data types
-- 2. Constraints
-- 3. Primary keys and Foreign keys
-- 4. Views


-- Creating and defining database
create database <database_name>;
create database companyx 
	with encoding = 'UTF8';
comment on database companyx is 'That is our database';


-- Create a database called "customer" and then drop that same database again.
-- Write both commands together in the solution.
-- Use ";" to declare the end of the commands.
create database customer;
drop database customer;

-- Data types (https://www.postgresql.org/docs/current/datatype.html)
-- 1. numeric
-- INT
-- SMALLINT
-- BIGINT
-- NUMERIC(precision, scale) -- precision (# count of digits) and scale (count of decimal places) -- 24.99 > numeric(4, 2)
-- SERIAL (auto-incrementing by 1) > for ID columns

-- 2. Strings
-- character varying (variable-length with limit)
-- text (variable unlimited length)

-- 3. Date/Time

-- 4. Other
-- Boolean: either true or false or Null
-- enum: user-defined (create type rating as enum ('G', 'PG', [...]))
-- array: stores a list of values in one column and can use index to retrieve specific one

-- Constraints
-- 1. defined when table is created

-- 2. used to define rules for the data in a table
-- not null: ensures that a column cannot have a null value
-- unique: ensures that all values in a column are different
-- default: set a default value for a column if no value is specified
-- Primary Key: a combination of a NOT NULL and UNIQUE; Uniquely identifies each row in a table
-- Referneces: ensures referential integrity (only values of another column can be used)
-- Check: ensures that values in a column satifies a specific condition

-- 3. set constraints in the tables
-- primary key (column[name1, name2, ......])
-- unique(column[name1, name2, ......])
-- check(search_condition)

-- Primary key: one or multiple columns that uniquely identify each row in a table and each row is not null
-- Foreign key: a column (or multiple) that refers to the primary in another table
-- Referenced table (parent table): a table that holds primary key
-- Referencing table (child table): a table that holds foregin key
-- For exmaple, the customer_id is PK in customer table so any other customer_id in payment table are referred as FK and payment table is referencing table (child table)

select *
from customer c
inner join payment p
on c.customer_id = p.customer_id;

-- foreign key doesn't need to be unqiue
-- primary key and foreign key are usually the columns to join tables -- c.customer_id = p.customer_id
-- can be created also in the table creation process

-- create table
create table <table_name> (column_name1 type [constraint], column_name1 type [constraint], ......)

create table company_z(
staff_id serial primary key, -- auto-increment each id by 1
name varchar(50) not null,
unique(name, staff_id)
);

-- create a director table
create table director(
director_id serial primary key,
director_account_name varchar(20) unique,
first_name varchar(50),
last_name varchar(50) default 'Not Sepcified',
address_id int references address(address_id) -- make sure the address_id as FK in director is linked with address_id in referenced table
);

-- Create a table called online_sales with the following columns:
-- transaction_id
-- customer_id
-- film_id
-- amount
-- promotion_code

-- Transaction_id shoul be the primary key.
-- The columns customer_id and film_id should be foreign keys to the relevant tables.
-- The amount column can contain values from 0.00 to 999.99 - nulls should not be allowed.
-- The column promotion_code contains a promotion code of at maximum 10 characters. If there is no value you should set the default value 'None'.

-- Create that table and choose appropriate data types and constraints!

-- Questions for this assignment
-- What data type you think is appropriate for the transaction_id column?

create table online_sales(
transaction_id serial primary key,
customer_id int references customer(customer_id),
film_id int references film(film_id),
amount numeric(5, 2) not null,
promotion_code varchar(10) default 'None');

-- insert table
-- insert into <table> values (value1, value2, .....) -- each values goes to the each columns on specific row

insert into online_sales
values (1, 269, 13, 10.99, 'BUNDLE2022');

-- we can also specify which column to insert
insert into online_sales
(customer_id, film_id, amount) -- specify the column name
values (269, 13, 10.99)

-- we can add multiple rows by adding more arraies of data
insert into online_sales
(customer_id, film_id, amount) -- specify the column name
values (269, 13, 10.99), (270, 12, 22.99), .......

INSERT INTO online_sales (customer_id, film_id,amount,promotion_code)
VALUES 
(124,65,14.99,'PROMO2022'),
(225,231,12.99,'JULYPROMO'),
(119,53,15.99,'SUMMERDEAL'); 


-- alter table
-- add or delete columns
-- add or drop constraints
-- rename columns
-- alter data types

-- 1. Drop column
alter table <table_name> alter_action
alter table <table_name> drop column <column_name>
alter table staff drop column if exist first_name -- <if exist> can prevent error message

-- 2. define datatype under the column
-- alter table staff
add column date_of_birth date -- define datatype

-- 3. Type
-- change the column data type
alter column <column_name> type new_type

-- example:
alter table staff
alter column address_id type smallint

-- 4. Rename
-- rename the column name
-- it has to be operated individually
alter table staff
rename column first_name to name

-- rename table name
alter table <old_name>
rename to <new_name>

-- 5. Default
-- set a default value for the column
alter table <table_name>
alter column <column_name> set default <value>

-- example
-- set default value as 1 in store_id
alter table staff
alter column store_id set default 1

-- 6. NOT NULL
-- set column without null value
alter table <table_name>
alter column <column_name> set not null

-- 7.table constraint
alter table <table_name>
add constraint <constraint_name> unique (column1, column2, ......)

-- 8. Primary key
-- adding PK in the table
alter table <table_name>
add primary key (column1, column2, .....)


-- create director table
create table director(
director_id serial primary key,
director_account_name varchar(20) unique,
first_name varchar(50),
last_name varchar(50) default 'Not Specified',
date_of_birth date,
address_id int references address(address_id)
)

-- question 1: director_account_name to varchar(30)
alter table director
alter column director_account_name type varchar(30)

-- question 2: drop the default on last_name
alter table director
alter column last_name drop default

-- question 3: add the constraint not null to last name
alter table director
alter column last_name set not null

-- question 4: add the column email of data type varchar(40)
alter table director
add column email set varchar(40)

-- question 5: rename the director_account_name to account_name 
alter table director
rename column director_account_name to account_name

-- question 6: rename the table from director to directors
alter table director
rename to directors

-- Drop and Truncate

-- 1. Drop table to delete entire table
drop table <table_name>

-- 2. Drop schema to delete object
drop schema <schema_name>

-- 3. delect all data in the table 
truncate table <table_name> -- truncate only follows with table

-- Create table
CREATE TABLE emp_table 
(
emp_id SERIAL PRIMARY KEY,
emp_name TEXT
)

-- SELECT table
SELECT * FROM emp_table

-- Drop table
drop table emp_table

-- Insert rows
INSERT INTO emp_table
VALUES
(1,'Frank'),
(2,'Maria')

-- SELECT table
SELECT * FROM emp_table

-- Truncate table
truncate table emp_table


-- Check constraint
-- limits value range that can be placed in a column
-- create table <table_name>(
-- <column_name> type check (condition)
-- )

create table director(
name text check (length(name) > 1)
)

create table director(
name text constraint name_length check (length(name) > 1) -- assign a constraint with name 
)
-- default constraint name: <table>_<column>_check
-- <table> comes from table name created -- here will be dirctor
-- <column> comes from column under check condition -- here will be name

-- add check constraint to the table
alter table <table_name>
add constraint date_check check(start_date < end_date)

-- drop constraint
alter table<table_name>
drop constraint date_check

-- rename constraint
alter table<table_name>
rename constraint date_check to data_constraint

-- practice
-- create a table called songs with following columns
create table songs(
song_id serial primary key,
song_name varchar(30) set not null,
genre varchar(30) default 'Not Defined',
price numeric(4,2),
release_date date
)
select * from songs

-- 1. During creation add the default 'Not Defined' to the genre
genre varchar(30) default 'Not Defined'

-- 2. Add the not null constraint to the song_name column
song_name varchar(30) set not null

-- 3. Add the constraint with default name to ensure the price is at least 1.99
alter table songs
add constraint price_check check (price < 1.99)

-- 4. add the constraint date_check to ensure the release date is between today and 01-01-1950
alter table songs
add constraint date_check check (release_date between '01-01-1950' and '04-28-2025')

-- 5. try to insert a row
insert into songs
values (4, 'SQL song', 'Not defined', 0.99, '2022-01-07')

-- 6. Modify the constraint to be able have 0.99 allowed as the lowest possible price
alter table songs
drop constraint price_check,
add constraint price_check_new check (price >= 0.99)

-- 7. try again to insert the row
insert into songs
values (4, 'SQL song', 'Not defined', 0.99, '2022-01-07')