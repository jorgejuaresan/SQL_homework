## QUERY LIST FOR ALL THE EXCERSICE HOMEWORK. EVERY EXCERSICE START WIHT THE NUMBER

USE sakila;

# 1.a Display first and second name
SELECT
first_name,
last_name
FROM actor;

# 1.b Display first and second name togueter in a new column
SELECT
CONCAT(first_name," ",last_name) AS Actor_Name
FROM actor
ORDER BY 1 ASC

# 2.a Display data where first name is JOE
SELECT
actor_id,
first_name,
last_name
FROM actor
WHERE first_name LIKE '%JOE%'

# 2.b Display data where last name contain the letters GEN
SELECT
actor_id,
first_name,
last_name
FROM actor
WHERE last_name LIKE '%GEN%'

# 2.c Display data where last name contain the letters "LI" and 
#order by last and first name
SELECT
last_name,
first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY 1,2 ASC

# 2.D Display data country_ID and country where countries are : 
#Afghanistan, Bangladesh, and China
SELECT
country_id,
country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
ORDER BY 1,2

# 3.a Create a column with blob format call description
ALTER TABLE actor ADD 
description BLOB #SUB_TYPE TEXT CHARACTER SET WIN1252

# 3.b Delete column call description
ALTER TABLE actor 
DROP COLUMN description

# 4.a List the last name and count how many actors has the last name
SELECT
last_name,
COUNT(last_name) AS registros 
FROM actor
GROUP BY last_name
ORDER BY registros DESC

# 4.b List the last name and count how many actors has the last name. Show those 
#that ara shared at least two actors
SELECT
last_name,
COUNT(last_name) AS registros 
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1
ORDER BY registros DESC

# 4.c Fix the name of the actor Harpo Williams
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS'

# 4.d Fix the name of the actor Harpo Williams
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS'

# 5.a Address -- Missing --

# 6.a Display the first and last name as well as the address, of each staff member.
SELECT 
a.first_name,
a.last_name,
b.address
FROM staff AS a
LEFT JOIN address AS b
ON a.address_id = b.address_id 
GROUP BY 1,2,3

# 6.b Display the total amount rung up by staff member in August, 2005
SELECT 
a.first_name,
a.last_name,
SUM(b.amount) AS total_amount
FROM staff AS a
LEFT JOIN payment AS b
ON a.staff_id = b.staff_id
WHERE b.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY 1,2

# 6.c Display each film and the number of actors who are list for that film.
#Use : film_actor and film 
SELECT
a.title,
COUNT(b.film_id) AS Num_actors
FROM film AS a
LEFT JOIN film_actor AS b
ON a.film_id = b.film_id
GROUP BY title ASC

# 6.d The number of copies of the film Hunchback Impossible.
SELECT
a.title,
COUNT(b.film_id) AS num_copies
FROM film AS a
LEFT JOIN inventory AS b
ON a.film_id = b.film_id
WHERE a.title = 'Hunchback Impossible'
GROUP BY 1

#6.e List the customers alphabetically by last name. USE payment and custumer
SELECT
a.first_name,
a.last_name,
SUM(b.amount) AS total_paid
FROM customer AS a
LEFT JOIN payment AS b
ON a.customer_id = b.customer_id
GROUP BY 1,2
ORDER BY 2 ASC

# 7.a Show films starting with the letters K and Q whose language is English
#language
SELECT
title
FROM film AS a
LEFT JOIN language AS b
ON a.language_id = b.language_id
WHERE title LIKE 'Q%'
UNION ALL
SELECT
title
FROM film AS a
LEFT JOIN language AS b
ON a.language_id = b.language_id
WHERE title LIKE 'K%'
GROUP BY title

# 7.b A subquery to display all actors who appear in the film Alone Trip --No complete--
SELECT
first_name,
last_name
FROM actor AS a
LEFT JOIN film_actor AS b
ON a.actor_id = b.actor_id
LEFT JOIN film AS c
ON b.film_id = c.film_id
WHERE c.title = 'Alone Trip'
GROUP BY 1,2

# 7.c E-mail campaign in Canada
SELECT
a.email
FROM customer AS a
LEFT JOIN address AS b
ON a.address_id = b.address_id
LEFT JOIN city AS c
ON b.city_id = c.city_id
LEFT JOIN country AS d
ON c.country_id = c.country_id
WHERE country = 'Canada'
GROUP BY 1

# 7.d Family film  
SELECT
a.title
FROM film AS a
LEFT JOIN film_category AS b
ON a.film_id = b.film_id
LEFT JOIN category AS c
ON b.category_id = c.category_id
WHERE c.name = 'Family'

#7.e Display the most frequely rented movies in desc order
SELECT
a.title,
COUNT(rental_id) AS Total_Rent
FROM film AS a
LEFT JOIN inventory AS b
ON a.film_id = b.film_id
LEFT JOIN rental AS c
ON b.inventory_id = c.inventory_id
GROUP BY 1
ORDER BY Total_Rent DESC

# 7.f how much business, in dollars, each store brought in. ###A AYUDA ####  
SELECT
a.store_id,
COUNT(d.rental_id) * d.amount AS Total_rent
FROM store AS a
JOIN inventory AS b
ON a.store_id = b.store_id
JOIN rental AS c
ON b.inventory_id = c.inventory_id
JOIN payment AS d
ON c.rental_id = d.rental_id
GROUP BY 1

# 7.g Display each store_id_city_country 
SELECT 
a.store_id,
b.city_id,
c.country_id
FROM store AS a
LEFT JOIN address AS b
ON a.address_id = b.address_id
LEFT JOIN city AS c
ON b.city_id = c.city_id
AND country_id
GROUP BY 1,2,3

# 7.h List top 5 genres in gross revenue
# category, film_category_inventory, payment and rental
SELECT
a.name,
COUNT(d.rental_id) * e.amount AS Total_rent
FROM category AS a
JOIN film_category AS b
ON a.category_id = b.category_id
JOIN inventory AS c
ON b.film_id = c.film_id
JOIN rental AS d
ON c.inventory_id = d.inventory_id
JOIN payment AS e
ON d.rental_id = e.rental_id
GROUP BY 1
ORDER BY Total_rent DESC
LIMIT 5

# 8.a Create a view for the top 5 categories 
CREATE VIEW 'top 5' as
SELECT  x.name, SUM(x.FrequencyofRent) as TotalRents
FROM    (SELECT tb4.film_id, tb4.title,  tb4.FrequencyofRent, ct.category_id, ct.name
                FROM(SELECT tb3.film_id, tb3.title, SUM(tb3.TotalRents) AS FrequencyofRent
                      FROM    (SELECT tb2.film_id, tb2.title, tb2.inventory_id, COUNT(tb2.rental_id) as TotalRents
                                FROM    (SELECT tb1.film_id, tb1.title, tb1.inventory_id, tb1.rental_id
                                        FROM    (SELECT fm.film_id, fm.title, tb.inventory_id, tb.rental_id
                                                FROM film fm    
                                                    LEFT JOIN (SELECT inv.inventory_id, inv.film_id, rt.rental_id
                                                                FROM  inventory inv
                                                                    LEFT JOIN rental rt ON inv.inventory_id=rt.inventory_id) tb
                                                        ON fm.film_id=tb.film_id) tb1
                                        WHERE tb1.rental_id is NOT NULL)tb2
                                GROUP BY tb2.inventory_id) tb3
                       GROUP BY tb3.film_id)tb4,
                       film_category fc,
                       category ct
                WHERE  fc.film_id=tb4.film_id  AND
                       fc.category_id=ct.category_id)x
GROUP BY x.name
ORDER BY TotalRents DESC
LIMIT 5

# 8.b Display a view for the top 5 categories 
SELECT * FROM 'top 5'

# 8.c Drop a view for the top 5 categories 
DROP VIEW 'top 5';