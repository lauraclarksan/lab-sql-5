-- Lab 5 Unit 2
-- 1. Drop column picture from staff
select * from sakila.staff;
alter table sakila.staff
drop column picture;
select * from sakila.staff;

-- 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly
select * from sakila.customer
where first_name = 'TAMMY';
select * from sakila.staff;

insert into sakila.staff values
(3,'Tammy','Sanders',79,'Tammy.Sanders@sakilacustomer.org',2,1,'Tammy','','2006-02-15 04:57:20');

select * from sakila.staff;

-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well.
select * from sakila.rental; -- I need rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update

-- To get rental_id, it's a unique value, 
select * from sakila.rental
order by rental_id desc
limit 1; -- There's a total of 16049 entries, so will use 16050

-- To get rental_date, we are going to use the current date,
select current_timestamp; -- 2023-12-09 15:15:29

-- To get inventory_id, it's a unique value,
select count(inventory_id) from inventory; -- 4581

-- To get the customer_id and film_id we are going to access the customer and film table,
select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER'; -- 130
select film_id from sakila.film
where title = 'Academy Dinosaur'; -- 1

-- To get return_date, we look at rental_duration for the film,
select rental_duration from sakila.film
where film_id = 1; -- 6 days, 2023-12-15 15:15:29

-- To get staff_id, we are going to access the staff table,
select staff_id from sakila.staff
where first_name = 'Mike' and last_name = 'Hillyer'; -- 1

-- Use same last_update as rental table -- 2006-02-15 21:30:53

-- Now put everything together to insert row in the rental table
-- I need rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update
select * from sakila.rental;
insert into sakila.rental values
(16050,'2023-12-09 15:15:29',4581,130,'2023-12-15 15:15:29',1,'2006-02-15 21:30:53');

select * from sakila.rental
order by rental_id desc
limit 1;

-- 4. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:
-- Check if there are any non-active users
select * from sakila.customer;
select distinct active from sakila.customer; -- I'm gonna assume that active is 1 and non-active is 0
select * from sakila.customer
where active = 0;

-- Create a table backup table as suggested
CREATE TABLE deleted_users (
`customer_id` int UNIQUE NOT NULL,
`email` char(50) DEFAULT NULL,
`date` char(50) DEFAULT NULL,
CONSTRAINT PRIMARY KEY (customer_id)
);

select * from deleted_users;

-- Insert the non active users in the table backup table
select customer_id, email, last_update from sakila.customer
where active = 0;
insert into deleted_users values
('16','SANDRA.MARTIN@sakilacustomer.org','2006-02-15 04:57:20'),
('64','JUDITH.COX@sakilacustomer.org','2006-02-15 04:57:20'),
('124','SHEILA.WELLS@sakilacustomer.org','2006-02-15 04:57:20'),
('169','ERICA.MATTHEWS@sakilacustomer.org','2006-02-15 04:57:20'),
('241','HEIDI.LARSON@sakilacustomer.org','2006-02-15 04:57:20'),
('271','PENNY.NEAL@sakilacustomer.org','2006-02-15 04:57:20'),
('315','KENNETH.GOODEN@sakilacustomer.org','2006-02-15 04:57:20'),
('368','HARRY.ARCE@sakilacustomer.org','2006-02-15 04:57:20'),
('406','NATHAN.RUNYON@sakilacustomer.org','2006-02-15 04:57:20'),
('446','THEODORE.CULP@sakilacustomer.org','2006-02-15 04:57:20'),
('482','MAURICE.CRAWLEY@sakilacustomer.org','2006-02-15 04:57:20'),
('510','BEN.EASTER@sakilacustomer.org','2006-02-15 04:57:20'),
('534','CHRISTIAN.JUNG@sakilacustomer.org','2006-02-15 04:57:20'),
('558','JIMMIE.EGGLESTON@sakilacustomer.org','2006-02-15 04:57:20'),
('592','TERRANCE.ROUSH@sakilacustomer.org','2006-02-15 04:57:20');

select * from deleted_users;

-- Delete the non active users from the table customer
delete from sakila.customer
where active = 0;
