USE sakila;

-- 1a:

SELECT first_name, last_name FROM actor;

-- 1b:

SELECT CONCAT(first_name, ' ', last_name) AS Full_Name FROM actor;

-- 2a:

SELECT * FROM actor
WHERE first_name IN ('JOE','JOSEPH');

-- 2b:

SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c:

SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;

-- 2d:

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');

-- 3a:

ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_name`;

-- 3b:

ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

-- 4a:

SELECT last_name, COUNT(last_name) AS Count
FROM actor
GROUP BY last_name;

-- 4b:

SELECT last_name, COUNT(last_name) AS 'Count'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- 4c:

UPDATE actor set first_name='HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

-- 4d:

SET SQL_SAFE_UPDATES = 0;
UPDATE actor set first_name='GROUCHO'
WHERE first_name='HARPO';

-- 5a:

SHOW CREATE TABLE address;

CREATE TABLE IF NOT EXISTS `address` (
   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   `address` varchar(50) NOT NULL,
   `address2` varchar(50) DEFAULT NULL,
   `district` varchar(20) NOT NULL,
   `city_id` smallint(5) unsigned NOT NULL,
   `postal_code` varchar(10) DEFAULT NULL,
   `phone` varchar(20) NOT NULL,
   `location` geometry NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location` (`location`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;
 
 -- 6a:
 
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;

-- 6b:

SELECT * FROM payment;
SELECT 
	staff.first_name, 
    staff.last_name, 
    SUM(payment.amount) AS 'Total Payment'
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY payment.staff_id;

-- 6c:

SELECT
	film.title,
    COUNT(film_actor.actor_id) AS 'Number of Actors'
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;

-- 6d:

SELECT
	film.title,
    COUNT(inventory.inventory_id) AS 'Stock Count'
FROM film
INNER JOIN inventory ON film.film_id=inventory.film_id
GROUP BY inventory.film_id
HAVING film.title ='Hunchback Impossible';

-- 6e:

SELECT
	customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS 'Total Paid'
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id;

-- 7a:

SELECT
	title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%';

-- 7b:

SELECT
	first_name,
    last_name
FROM actor
WHERE actor_id IN(
	SELECT
		actor_id
	FROM film_actor
	WHERE film_id IN(
		SELECT
			film_id
		FROM film
		WHERE title ='Alone Trip'
)
);

-- 7c:

SELECT
	customer.customer_id,
	customer.first_name,
    customer.last_name,
    customer.email
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country = 'Canada';

-- 7d:

SELECT
	title
FROM film
INNER JOIN film_category ON film.film_id=film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- 7e:

SELECT
	film.title,
    COUNT(rental.rental_id) AS 'Total Rentals'
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f:

SELECT
	store.store_id,
	address.address,
    SUM(payment.amount) AS 'Total Payments'
FROM payment
INNER JOIN store ON payment.staff_id = store.manager_staff_id
INNER JOIN address ON address.address_id = store.address_id
GROUP BY store.store_id;

-- 7g:

SELECT
	store.store_id,
    city.city,
    country.country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country On city.country_id = country.country_id;

-- 7h:

SELECT * FROM inventory;

SELECT 
	category.name,
    SUM(payment.amount) AS Total_Revenue
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON inventory.film_id = film_category.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8a:

CREATE VIEW Top_Five_Categories AS
SELECT 
	category.name,
    SUM(payment.amount) AS Total_Revenue
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON inventory.film_id = film_category.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8b:

SELECT * FROM Top_Five_Categories;

-- 8c:

DROP VIEW `sakila`.`top_five_categories`;

