SELECT *
FROM customer 
-- 1. List all customers who live in Texas (use JOINs) using 'c' AS alias for 'customer', and 'a' AS alias for 'address'
-- NOTES: working, used AS alias for kicks

SELECT first_name, last_name, a.address_id, district -- everything we are looking for
FROM customer AS c --table we are search from
FULL JOIN address AS a --table we are joining
ON c.customer_id = a.address_id
WHERE district = 'Texas';


-- 2. Get all payments above $6.99 with the Customer's Full Name --PAYMENT TABLE.AMOUNT CUSTOMER TABLE.FIRST_NAME, LAST_NAME, WHERE amount > 6.99
-- NOTES: working, but not pulling names. I am getting NULL in first_name, last_name columns

SELECT customer.first_name, customer.last_name, amount
FROM customer
JOIN payment 
ON customer.customer_id = payment.customer_id  
WHERE amount > 6.99
GROUP BY customer.first_name , customer.last_name, payment.amount;
--new - working but not grouping the customers SUM(total) amount...
SELECT first_name, last_name, payment.amount 
FROM customer 
JOIN payment 
ON customer.customer_id = payment.customer_id 
WHERE customer.customer_id  IN(
	SELECT customer_id 
	FROM payment
	GROUP BY payment.amount, payment.customer_id, customer.customer_id  
	HAVING SUM(amount) > 6.99
);


-- 3. Show all customers names who have made payments over $175(use
-- subqueries)innner query first, outer query
-- subqueries in the FROM cluase are a great way to get an Aggregate of an Aggreegate
-- SELECT *
-- FROM customer_id IN(SELECT customer_id FROM payments WHERE first_name, last_name LIKE (%175&) )

SELECT *
FROM customer 
--old*
--SELECT first_name, last_name, payment.amount, customer.customer_id 
--FROM customer
--JOIN payment 
--ON customer.customer_id = payment.customer_id  
--WHERE amount > 175.00
--GROUP BY first_name, last_name, customer.customer_id, payment.amount;


--NOTES I am getting empty columns
SELECT first_name, last_name, payment.amount
FROM customer
JOIN payment --subQ above AND single payment 
ON customer.customer_id = payment.customer_id 
WHERE payment.amount > 175.00

SELECT first_name, last_name, payment.amount
FROM customer
JOIN payment 
ON customer.customer_id = payment.customer_id 
WHERE customer.customer_id  IN (
	SELECT customer_id
	FROM payment
	GROUP BY payment.amount, payment.customer_id, customer.customer_id 
	HAVING SUM(amount) > 175.00
);

-- 4. List all customers that live in Nepal (use the city table)
-- NOTES: working if there is 1 customer in Nepal

SELECT first_name, last_name, country.country_id, country.country 
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id-- ON is matching 
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country = 'Nepal';


-- 5. Which staff member had the most transactions? 
-- NOTES: need to find column w/ transactions
SELECT first_name, last_name, rental.staff_id , staff.staff_id 
FROM rental
JOIN staff
ON rental.staff_id  = staff.staff_id 
GROUP BY first_name, last_name, rental.staff_id , staff.staff_id;


-- 6. How many movies of each rating are there?
-- NOTES: working but not grouping the amount of films per title(tried this several ways...trying to get total of movies per)
-- need to run a calc - clue 'how many films per rating'
SELECT title, film.film_id, inventory, rating
FROM film
INNER JOIN inventory
ON inventory.film_id = film.film_id 
GROUP BY title, film.film_id, inventory, rating;

-- 7.Show all customers who have made a single payment
-- above $6.99 (Use Subqueries) 
SELECT first_name, last_name, payment.amount
FROM customer
JOIN payment --subQ above AND single payment 
ON customer.customer_id = payment.customer_id 
WHERE payment.amount = 6.99

--NOTES: I tried to create subqueires to get inside, but then I just rearragned the code above and it found what I was looking for
--SELECT first_name, last_name, payment.amount 
--FROM customer 
--JOIN payment 
--ON customer.customer_id = payment.customer_id 
--WHERE customer.customer_id  IN(
--	SELECT customer_id 
--	FROM payment
--	GROUP BY payment.amount, payment.customer_id, customer.customer_id IN(
--		SELECT (amount) = 6.99
--		FROM payment
--		GROUP BY payment.amount, payment.customer_id, customer.customer_id
--		)
--);

-- 8.How many free rentals did our stores give away?
-- NOTES: returns 24, but doesn't list it in its own row...
SELECT payment_id, amount
FROM payment
WHERE amount = 0.00;






