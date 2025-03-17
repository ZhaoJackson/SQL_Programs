-- Tag monday and July special and special deal
select
total_amount,
to_char(book_date, 'Dy') as day,
to_char(book_date, 'Mon') as month,
case
when to_char(book_date, 'Dy') = 'Mon' then 'Monday Special'
when to_char(book_date, 'Mon') = 'Jul' then 'July Special'
when total_amount * 1.4 < 30000 then 'Special Deal'
else 'No special at all'
end as classification
from bookings;


-- classify the departure interval
select
count(*) as flights,
case
when actual_departure is null then 'No Departure Time'
when actual_departure - scheduled_departure < '00.05' then 'On Time'
when actual_departure - scheduled_departure < '01.00' then 'A Little Bit Late'
else 'Very Late'
end as is_late
from flights
group by is_late;


-- find how many tickets you have sold in the following categories
-- low price ticket: total_amount < 20000
-- mid price ticket: total_amount between 20000 and 150000
-- high price ticket: total_amount >= 150000
select
count(*),
case
when total_amount < 20000 then 'Low Price Ticket'
when total_amount < 150000 then 'Mid Price Ticket'
else 'High Price Ticket'
end as categories
from bookings
group by categories;


-- find out how many flights are scheduled for departure in the following seasons
-- winter: December, January, Feburary
-- spring: March, April, May
-- summer: June, July, August
select
count(*) as flights,
case
when to_char(scheduled_departure, 'Mon') in ('Dec', 'Jan', 'Feb') then 'Winter'
when to_char(scheduled_departure, 'Mon') in ('Mar', 'Apr', 'May') then 'Spring'
when to_char(scheduled_departure, 'Mon') in ('Jun', 'Jul', 'Aug') then 'Summer'
else 'Fall'
-- alternatively
-- WHEN EXTRACT(MONTH FROM scheduled_departure) IN (12, 1, 2) THEN 'Winter'
-- WHEN EXTRACT(MONTH FROM scheduled_departure) IN (3, 4, 5) THEN 'Spring'
-- WHEN EXTRACT(MONTH FROM scheduled_departure) IN (6, 7, 8) THEN 'Summer'
-- ELSE 'Fall'
end as seasons
from flights
group by seasons;



-- Coalesce(first_col, second_col): return first value of a list of values which is not null 
-- for any null value in the first value of list, it will be replaced by the corresponding 2nd value of next list

select
coalesce(actual_arrival, scheduled_arrival) -- any missing value in actual_arrival will be replaced by the value in that row in scheduled_arrival.
from flights;

-- we also can replace with a fixed value for any null value in the first column
-- make sure the format of data are the same
select
coalesce(actual_arrival, '1970-01-01 0:00') -- any missing value in actual_arrival will be replaced by '1970-01-01 0:00'.
from flights;

-- Cast: change the datatype of a column
-- cast(value / column as data type)
select
cast(scheduled_arrival as varchar)
from flights;

select
cast(scheduled_arrival as date)
from flights;

-- indicate the null value in arrival interval as 'Not arrived'
-- combine coalesce with cast
select
coalesce(cast(actual_arrival - scheduled_arrival as varchar), 'Not Arrived')
from flights;

-- change the number into integer
select
cast(ticket_no as bigint)
from tickets;


-- replace(): rearrange the structure of the text
-- clean the data when there is space in between
-- replace text from a string in a column with another text
-- replace(column, old_text, new_text)

-- remove the space in the passenger_id
select
cast(replace(passenger_id, ' ', '') as bigint)
from tickets;

-- replace PG with FL in flight_no
select
replace(flight_no, 'PG', 'FL')
from
flights;









