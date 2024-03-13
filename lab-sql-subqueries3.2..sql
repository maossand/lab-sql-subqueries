## Write SQL queries to perform the following tasks using the Sakila database:

USE sakila;

## 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT * 
FROM 
	(SELECT * from film where film.title = "Hunchback Impossible") as hunchtable;

## We see that film_id for Hunchback is 439

SELECT COUNT(*) as "Hunchback Impossible Copies"
FROM 
	(SELECT * from inventory where inventory.film_id = 439) as hunchtable;

## 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT film.title, film.length
FROM sakila.film
WHERE film.length > (SELECT AVG(length) FROM sakila.film);

## 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT *
FROM film_actor
LEFT JOIN actor
	USING (actor_id)
LEFT JOIN film
	USING (film_id)
WHERE film.title = "Alone Trip"
ORDER BY last_name;

## Bonus:

## 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT title as "Film", release_year as "Release Year", name as "Category"
FROM film
LEFT JOIN film_category
	ON film.film_id = film_category.film_id
LEFT JOIN category
	ON film_category.category_id = category.category_id
WHERE category.name = "Family"
ORDER BY film.title; 

## 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT customer.last_name, customer.first_name, customer.email
FROM sakila.customer
LEFT JOIN sakila.address
	ON customer.address_id = address.address_id
LEFT JOIN sakila.city
	ON address.city_id = city.city_id
LEFT JOIN sakila.country
	ON city.country_id = country.country_id
WHERE country.country = "Canada";

## 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT film_id, title
FROM film_actor
LEFT JOIN film
	USING (film_id)
WHERE actor_id = 107
ORDER BY title;

	##count in film_actor the distint values for actor_id

SELECT actor_id, COUNT(*) as number_of_films
FROM film_actor
GROUP BY actor_id
ORDER BY number_of_films DESC
LIMIT 1;

	##actor_id = 107

## 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

	##find the films

SELECT title as "films rented by the most profitable customer"
FROM inventory
LEFT JOIN sakila.film
	USING (film_id)
LEFT JOIN sakila.rental
	USING (inventory_id)
WHERE customer_id=526
ORDER BY title;

	##find the customer:

SELECT payment.customer_id, SUM(payment.amount) as total_paid
FROM payment
GROUP BY payment.customer_id
ORDER BY total_paid DESC;

	##customer_id=526

## 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING total_amount > (
	##we need to group the amount spent by each customer, then calculate the average
    ##in this step I struggled because I was trying to use WHERE and not HAVING. "The issue with your query is that 	you're trying to use an aggregate function (SUM) in the WHERE clause, which is not allowed directly. Instead, you should use the HAVING clause for conditions involving aggregate functions."
    ## also, using directly "total_amount" in the first row doesn't work it needs to be added with AS
SELECT AVG(total_amount) AS avg_paid FROM (
SELECT customer_id, SUM(amount) as total_amount
FROM payment
GROUP BY customer_id) AS derived_table);

	##we get the avg_paid = 112.531820