use sakila;

-- 1. Convert the query into a simple stored procedure. Use the following query:

DELIMITER //
CREATE PROCEDURE GetCustomersRentedActionMovies()
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = "Action"
    GROUP BY first_name, last_name, email;
END //
DELIMITER ;
-- procedure call to action 
CALL GetCustomersRentedActionMovies();

-- 2 playing with the previous stored procedure to make it more dynamic.

DELIMITER //
CREATE PROCEDURE GetCustomersRentedMoviesByCategory(IN category_name VARCHAR(255))
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = category_name
    GROUP BY first_name, last_name, email;
END //
DELIMITER ;

-- call to action with the Children category
CALL GetCustomersRentedMoviesByCategory('children');

-- call to action with the Animation category
CALL GetCustomersRentedMoviesByCategory('Animation');

-- call to action with the classics category
CALL GetCustomersRentedMoviesByCategory('Classics');

-- 3. Write a query to check the number of movies released in each movie category

SELECT category.name AS category_name, COUNT(film.film_id) AS num_movies
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category_name;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number.

DELIMITER //
CREATE PROCEDURE GetCategoriesWithMovieCountGreaterThan(IN min_movie_count INT)
BEGIN
    SELECT category.name AS category_name, COUNT(film.film_id) AS num_movies
    FROM category
    JOIN film_category ON category.category_id = film_category.category_id
    JOIN film ON film_category.film_id = film.film_id
    GROUP BY category_name
    HAVING num_movies > min_movie_count;
END //
DELIMITER ;


CALL GetCategoriesWithMovieCountGreaterThan(10);




