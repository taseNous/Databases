--Bring all the first and last names and emails of every customer

SELECT first_name, last_name, email
FROM customer;

--Retrieve the distinct rating types the films could have in our database

SELECT DISTINCT rating
FROM film;

--Retrieve the email of the customer Nancy Thomas

SELECT email
FROM customer
WHERE first_name = 'Nancy' and last_name = 'Thomas';

--Give the description for the movie "Outlaw Hanky"

SELECT description
FROM film
WHERE title = 'Outlaw Hanky';

--Retrieve the phone of the customer who lives at '259 Ipoh Drive'

SELECT phone
FROM address
WHERE address = '259 Ipoh Drive';

--What are the customer ids of the first 10 customers who created a payment?

SELECT customer_id
FROM payment
ORDER BY payment_date ASC
LIMIT 10;

--What are the titles of the 5 shortest(in length of runtime) movies?

SELECT title, length
FROM film
ORDER BY length ASC
LIMIT 5;

--How many movies are 50 minutes or less?

SELECT COUNT(*)
FROM film
WHERE length <= 50;

--How many payment transactions were greater than 5.00$?

SELECT count(*)
FROM payment
WHERE amount > 5;

--How many actors have a first name that starts with the letter P?

SELECT COUNT(*)
FROM actor
WHERE first_name LIKE 'P%';

--How many unique districts are our customers from?

SELECT COUNT(DISTINCT district)
FROM address;

--Retrieve the list of names for those distinct districts from the previous question

SELECT DISTINCT district
FROM address;

--How many films have a rating of R and a replacement cost between 5$ and 15$?

SELECT COUNT(*)
FROM film
WHERE rating = 'R' AND replacement_cost BETWEEN 5 AND 15;

--How many films have the word Truman somewhere in the title

SELECT COUNT(*)
FROM film
WHERE title LIKE '%Truman%';

--We have 2 staff members with ids 1 and 2. We want to give a bonus to the staff member that handled the most paymetns.
--How many payments did each staff member handle and who gets the bonus?

SELECT COUNT(staff_id)
FROM payment
GROUP BY staff_id;

--What is the average replacement cost per MPAA rating?

SELECT rating, AVG(replacement_cost)
FROM film
GROUP BY rating;

--What are the customer ids of the top 5 customers by total spend?

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;

--We will assign platinum status to custoemrs that have 40 or more transaction payments. What customer ids are eligible for the status?

SELECT customer_id, COUNT(*)
FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40;

--What are the customer ids of customers who have spent more than 100$ in payment transactions with our staff id member 2?

SELECT customer_id, staff_id, SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id, staff_id
HAVING SUM(amount) > 100;

--Return the customer ids of customers who have spent at least 110$ with the staff member who has an id of 2

SELECT customer_id, staff_id, SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id, staff_id
HAVING SUM(amount) >= 110;

--How many films begin with the letter 'J'?

SELECT COUNT(*)
FROM film
WHERE title LIKE 'J%';

--What customer has the highest customer id number whose name starts with an 'E' and has an address id lower than 500?

SELECT customer_id
FROM customer
WHERE first_name LIKE 'E%' AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1;

--What are the emails of the customers who live in California?

SELECT email
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
WHERE district = 'California';

--Get a list of all the movies 'Nick Wahlberg' has been in

SELECT film.title, actor.first_name, actor.last_name
FROM film
INNER JOIN film_actor ON film_actor.film_id = film.film_id
INNER JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE actor.first_name = 'Nick' AND last_name = 'Wahlberg';

--During which months did paymetns occur? Return the full month name

SELECT DISTINCT(TO_CHAR(payment_DAte, 'MONTH'))
FROM payment;

--How many payments occurred on a Monday?

SELECT COUNT(*)
FROM payment
WHERE EXTRACT(dow FROM payment_date) = 1;

--How can you retrieve all the information from the cd.facilities table?

SELECT *
FROM cd.facilities;

--You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs?

SELECT name, membercost
FROM cd.facilities;

--How can you produce a list of facilities that charge a fee to members?

SELECT *
FROM cd.facilities
WHERE membercost <> 0;

--How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question

SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost <> 0 AND membercost < monthlymaintenance/50;

--How can you produce a list of all facilities with the word 'Tennis' in their name?

SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

--How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

SELECT *
FROM cd.facilities
WHERE facid IN (1,5);

--How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.

SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';

--How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.

SELECT DISTINCT surname
FROM cd.members
ORDER BY surname ASC
LIMIT 10;

--You'd like to get the signup date of your last member. How can you retrieve this information?

SELECT joindate
FROM cd.members
ORDER BY joindate DESC
LIMIT 1;

--Produce a count of the number of facilities that have a cost to guests of 10 or more.

SELECT COUNT(*)
FROM cd.facilities
WHERE guestcost >= 10;

--Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT F.name, SUM(b.SLOTS)
FROM cd.bookings B
INNER JOIN cd.facilities F ON B.facid = F.facid
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY F.name
ORDER BY SUM(b.SLOTS);

--Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and total slots, sorted by facility id.

SELECT F.facid, SUM(b.SLOTS)
FROM cd.bookings B
INNER JOIN cd.facilities F ON B.facid = F.facid
GROUP BY F.facid
HAVING SUM(b.SLOTS) > 1000;

--How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT F.name, B.starttime
FROM cd.bookings B
INNER JOIN cd.facilities F ON B.facid = F.facid
WHERE name LIKE 'Tennis Court _' 
AND B.starttime >= '2012-09-21' AND B.starttime < '2012-09-22';

--How can you produce a list of the start times for bookings by members named 'David Farrell'?

SELECT M.firstname, M.surname, B.starttime
FROM cd.members M 
INNER JOIN cd.bookings B ON B.memid = M.memid
WHERE M.firstname = 'David' AND M.surname = 'Farrell';

--We want to know and compare the various amounts of films we have per movie rating.

SELECT 
SUM(
CASE rating
	WHEN 'R' THEN 1 ELSE 0
	END
) AS r,
SUM(
CASE rating
	WHEN 'PG' THEN 1 ELSE 0
	END
) AS pg,
SUM(
CASE rating
	WHEN 'PG-13' THEN 1 ELSE 0
	END
) AS pg13
FROM film;