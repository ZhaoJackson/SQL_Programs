-- get list where category they sell most tickets on how many people choose seats in the category (Business, Economy, Comfort)?
select
count(*),
s.fare_conditions as fare_conditions
from boarding_passes b
inner join flights f
on b.flight_id = f.flight_id
inner join seats s
on s.seat_no = b.seat_no
and f.aircraft_code = s.aircraft_code -- make sure to include all the common columns
group by fare_conditions;


-- find the ticket that doesn't have boarding pass issued
-- alternative way for left/right join by getting all information about the null value where the other common column are not.
select
t.ticket_no
from boarding_passes b 
full outer join tickets t
on b.ticket_no = t.ticket_no
where b.ticket_no is null;

-- find all aircrafts that have not been used in any flights
select
a.aircraft_code
from aircrafts_data a
left join flights f
on a.aircraft_code = f.aircraft_code
where f.flight_id is null; -- we need to find the null fight id where we include all aircraft_code

-- find out what flight company's most popular seats are and find which seat has been chosen most frequently
-- make sure all seats are included even if they have never been booked.
-- select
-- *
-- from flights -- flight_id, flight_no, aircraft_code

-- select
-- *
-- from seats -- aircraft_code, seat_no

-- select
-- *
-- from bookings -- book_ref

-- select
-- *
-- from tickets -- ticket_no, book_ref

-- select
-- *
-- from ticket_flights -- ticket_no, flight_id, fare_condition

select
s.seat_no,
count(*)
from seats s
left join boarding_passes bp
on s.seat_no = bp.seat_no
group by s.seat_no 
order by 2 desc;

-- try to find which line (A, B, ...., H) has been chosen most frequently.
select
right(s.seat_no, 1),
count(*)
from seats s
left join boarding_passes bp
on s.seat_no = bp.seat_no
group by right(s.seat_no, 1) 
order by 2 desc;

-- find out the aircraft that is never used in the flight
select *
from flights f
right join aircrafts_data a
on a.aircraft_code = f.aircraft_code
where f.aircraft_code is null;



-- find out how much a specific seats costs in average.
select
seat_no,
round(avg(amount), 2) as average_price
from ticket_flights tf
join boarding_passes bp
on tf.ticket_no = bp.ticket_no
and bp.flight_id = tf.flight_id
group by seat_no
order by 2 desc;

-- for every single ticket, including passenger_name, get scheduled departure
select t.ticket_no, 
passenger_name,
scheduled_departure
from ticket_flights tf
inner join tickets t
on t.ticket_no = tf.ticket_no
inner join flights f
on f.flight_id = tf.flight_id;


-- Which passenger (passenger_name) has spent most amount in their bookings (total_amount)?
-- select *
-- from tickets -- ticket_no

-- select *
-- from bookings -- book_ref

select passenger_name,
sum(total_amount)
from tickets t
inner join bookings b
on t.book_ref = b.book_ref
group by passenger_name
order by 2 desc
limit 1;

-- Which fare_condition has ALEKSANDR IVANOV used the most?
-- select * from ticket_flights -- ticket_no, flight_id, fare_conditions, amount
-- select * from tickets -- ticket_no, book_ref, passenger_name

select fare_conditions,
count(fare_conditions)
from ticket_flights tf
inner join tickets t
on tf.ticket_no = t.ticket_no
and passenger_name = 'ALEKSANDR IVANOV'
group by fare_conditions
order by 1 desc
limit 1;