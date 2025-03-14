-- String functions (https://www.postgresql.org/docs/current/functions-string.html)
-- length, lower, upper to the specific columns
-- string function will create a new column based on designated column

-- use upper() and lower() to mainipulate email
select
email,
upper(email) as email_upper,
lower(email) as email_lower,
length(email) as email_length -- count # of characters in the email
from customer
where length(email) < 30
order by 4;


-- find customers and output list of these first name and last name in all lower case where either the first name or last name is more than 10 characters.
select
lower(first_name) as first_name_lower,
lower(last_name) as last_name_lower,
lower(email) as email_lower
from customer
where length(first_name) > 10
or length(last_name) > 10;


-- left and right function
-- left(col_name, # of character to extract) used to extract the string part starting from left
-- right(col_name, # of character to extract) used to extract the string part starting from right

-- extract first 2 letter and last letter in each first name of customer
select 
first_name,
left(first_name, 2) as first_two,
right(first_name, 1) as last_one
from customer;


-- We can use nested right and left function to extract only partial letter in the middle of string
-- right(left(col_name, # of character to extract), # of character to extract)
-- left(right(col_name, # of character to extract), # of character to extract)

-- extract 2nd letter of the first name only
select
first_name,
right(left(first_name, 2), 1) as second_letter
from customer;


-- extract the last 5 characters of email address
select 
email,
right(email, 5)
from customer;

-- extract only '.' from email
select
email,
left(right(email, 4), 1) as dot
from customer;


-- concatenate function || : combine different information from multiple strings into one column 
-- partA || partB
-- we can add any text string between the concatenation 'XXX'

-- get the first and last name initials
select 
left(first_name, 1) || '.' || left(last_name, 1) || '.' as initial
from customer;

-- create an anonymized version of email address
select
email,
left(email, 1) || '***' || right(email, 19) as anonymized_email
from customer;

-- position() function
-- find the paricular characters in the string and return the position of that character in each string
-- position('characters to search' in column)
-- character to search is included whenever doing the position function

-- get the position of @ in each email
select
position('@' in email) -- return the position for @ in each email
from customer;

-- position() can be # of characters we want to extract and play with left and right function
-- left(column, position())
-- right(column, position())

-- extract the customer name in each email address
select
email,
left(email, position('@' in email) - 1) -- since @ will be included in position function, then we need to remove it by -1.
from customer;


-- extract first name in each email
select
email,
left(email, position(last_name in email) - 2) -- last name is encoded in each email as a string
from customer;

-- extract first name from email address and concatenate it with last name in form of 'last name, first name'.
select
email,
last_name,
left(email, position('.' in email) - 1) as first_name,
last_name || ', ' ||left(email, position(last_name in email) - 2) as full_name
from customer;

-- Substring (): extract the substring from given string
-- extract the substring from given interval
-- substring(string from start position [for length])
-- string indicates column needed to extract from
-- [for length] is optional to indicate how many character to be extracted. If not included, we will extract the character to the end.

-- extract the substring from position 2 with 3 letters
select
email,
substring(email from 2 for 3) as substring_email
-- substring(email from 2) -- it will extract from position 2 to the end of the string
from customer;


-- substring function can dynamically work with position function to indicate the starting point and length
-- substring(column, from position('.' in email) for 3)

-- get the last name from email address
select 
email,
-- substring(email from position('.' in email) + 1 for length(last_name))
substring(email from position('.' in email) + 1 for position('@' in email) - position('.' in email) - 1) -- alternative way to indicate the length of last name
from customer;


-- create type 1 anonymized form of email address like '"M***.S***@sakilacustomer.org"'
select
email,
left(email, 1) || '***' || substring(email from position('.' in email) for 2) || '***' || right(email, 19)
from customer;

-- create type 2 anonymized form of email address like "***Y.S***@sakilacustomer.org"
select 
email,
'***' || substring(email from position('.' in email) - 1 for 3) || '***' || right(email, 19)
from customer;


-- Extract () to get the date and timestamp (timestamp or date)
-- extract(field from date/time/interval)

-- use extract to only extract the day from the date.
-- date types: 'YYYY-MM-DD' or '2022-11-28'
-- time types (with / without time zone): 'H:M:S +- time zone' or '01:02:03 + 02'
-- timestamp (combination between date and time): 'YYYY-MM-DD H:M:S +- time zone'
-- interval (difference of 2 different dates)

-- EXTRACT timestamp with fields
-- Extracting various date/time components from a timestamp

-- SELECT 
--     EXTRACT(DAY FROM timestamp_column) AS day,
--     EXTRACT(DOW FROM timestamp_column) AS day_of_week,  -- Sunday (0) to Saturday (6)
--     EXTRACT(DOY FROM timestamp_column) AS day_of_year,  -- 1 to 366
--     EXTRACT(HOUR FROM timestamp_column) AS hour,  -- 0-23
--     EXTRACT(MINUTE FROM timestamp_column) AS minute,  -- 0-59
--     EXTRACT(MONTH FROM timestamp_column) AS month,  -- 1-12
--     EXTRACT(QUARTER FROM timestamp_column) AS quarter,  -- Quarter of the year
--     EXTRACT(SECOND FROM timestamp_column) AS second,
--     EXTRACT(WEEK FROM timestamp_column) AS week_iso_8601,  -- ISO 8601 week number
--     EXTRACT(YEAR FROM timestamp_column) AS year  -- Year
-- FROM your_table;

-- find out in which day of month with highest sales
select
count(*),
extract(day from rental_date) as hightest_day
from rental
group by extract(day from rental_date)
order by 1 desc
limit 1;

-- what is the month with the highest total payment amount?
select
extract(month from payment_date) as highest_month,
sum(amount)
from payment
group by highest_month
order by 2 desc
limit 1;

-- what is the day of week with the highest total payment amount?
select
extract(dow from payment_date) as highest_week,
sum(amount)
from payment
group by highest_week
order by 2 desc
limit 1;

-- what is highest amount one customer has spent in a week?
select 
customer_id,
sum(amount),
extract(week from payment_date) as highest_week
from payment
group by customer_id, highest_week
order by 2 desc
limit 1;


-- TO_CHAR: used to get custom formats timestamp / date / numbers
-- get the new column based on time column and extract any time format from there
-- to_char(date / time / interval, format) - the format is flexible but there are common ones lised here: 

-- (https://www.postgresql.org/docs/current/functions-formatting.html)

-- SELECT 
--     TO_CHAR(date / time / interval, 'YYYY-MM-DD HH24:MI:SS') AS formatted_datetime, -- 2025-03-13 14:45:30
--     TO_CHAR(date / time / interval, 'Month DD, YYYY') AS long_date_format, -- March 13, 2025
--     TO_CHAR(date / time / interval, 'Dy, DD Mon YYYY') AS short_date_format, -- Thu, 13 Mar 2025
--     TO_CHAR(date / time / interval, 'HH12:MI:SS AM') AS twelve_hour_time, -- 02:45:30 AM
--     TO_CHAR(date / time / interval, 'YYYY-Q') AS year_quarter, -- 2025-1
--     TO_CHAR(date / time / interval, 'Day') AS full_day_name, -- Thursday
-- 	   TO_CHAR(date / time / interval, 'DD Mon YYYY'); -- 13 Mar 2025


select
*,
extract(month from payment_date),
to_char(payment_date, 'MM-YYYY') as Mon_Date
from payment;


-- we can group by the to_char timestamp column 
select 
sum(amount),
to_char(payment_date, 'Day, Month YYYY') as date_format
from payment
group by date_format
order by 1 desc
limit 5;

-- arrange type 1 timestamp like "Fri, 24/01/2020"
select
sum(amount),
to_char(payment_date, 'Dy, DD/MM/YYYY') as type_1
from payment
group by type_1
order by 1;


-- arrange type 2 timestamp like "May, 2020"
select 
sum(amount),
to_char(payment_date, 'Mon, YYYY') as type_2
from payment
group by type_2
order by 1;

-- arrange type 3 timestamp like "Thu, 02:44"
select 
sum(amount),
to_char(payment_date, 'Dy, HH12:MI') as type_3
from payment
group by type_3
order by 1 desc; 

-- timestamp: used to create a column for current time information

-- get the current date
select current_date;

-- get current timestamp
select current_timestamp;

-- obtain the time interval based on current timestamp against existing time
select
current_timestamp,
rental_date,
current_timestamp - rental_date as time_interval
from rental;

-- get the day interval between rental and return days
select
rental_date,
return_date,
extract(day from return_date - rental_date) as interval
-- to_char(return_date - rental_date, 'HH24')
from rental
where return_date is not null
order by 3 desc;

-- get the # of hours between rental and return days
select
rental_date,
return_date,
extract(day from return_date - rental_date) * 24 +
extract(hour from return_date - rental_date) || ' hours' as interval_hours
from rental
where return_date is not null
order by 3 desc;

-- create a list for the support team of all rental durations of customer with customer_id 35.
select
rental_date,
return_date,
return_date - rental_date as rental_duration
from rental
where customer_id = 35;

-- create list to indicate which customer has the longest average rental duration?
select
customer_id,
avg(return_date - rental_date) as average_rental_duration
from rental
group by customer_id
order by 2 desc
limit 1;