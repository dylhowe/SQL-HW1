use sakila;

SET SQL_SAFE_UPDATES = 0;

#1a. Display the first and last names of all actors from the table actor.

select 
	first_name
	,last_name
from 
	actor;


#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

select 
	first_name
	,last_name
    ,CONCAT_WS('', first_name, ' ', last_name) AS 'Actor Name'
from 
	actor;

    
#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
	#What is one query would you use to obtain this information?

select 
	actor_id
    ,first_name
    ,last_name
from 
	actor
where 
	first_name = "JOE";


#2b. Find all actors whose last name contain the letters GEN:

select 
	* 
from 
	actor
where 
	last_name like '%GEN%';


#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select 
	last_name
	,first_name
from
	actor
where
	last_name like '%LI%';


#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select 
	country_id
    ,country
from 
	country
where
	country in ("Afghanistan", "Bangladesh", "China");


#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
	#so create a column in the table actor named description and use the data type BLOB:

alter table actor
add
	description blob;

    
#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

alter table actor
drop column 
	description;
    

#4a. List the last names of actors, as well as how many actors have that last name.

select
	last_name
    ,count(last_name)
from
	actor
group by
	last_name;
    

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select
	last_name
    ,count(last_name)
from
	actor
group by
	last_name
having
	count(last_name) > 1;
    
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

update 
	actor
set 
	first_name = "HARPO"
where 
	first_name = "GROUCHO" 
    and
    last_name = "WILLIAMS";
    

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
	#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
    
update 
	actor
set
	first_name = "GROUCHO"
where
	first_name = "HARPO";
    
    
#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

show create table address;


#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select
	first_name
    ,last_name
    ,address
from
	staff join (address) 
    on staff.address_id = address.address_id;
    

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select
	first_name
    ,sum(amount)
from
	staff join (payment) 
    on staff.staff_id = payment.staff_id
where
	payment_date like '%2005-08%'
group by first_name;


#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

select
	title
    ,count(actor_id)
from 
	film inner join (film_actor) on film.film_id = film_actor.film_id
group by 
	film_actor.film_id;
    
    
#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select
	title
    ,count(inventory.film_id) as 'copies_available'
from 
	inventory join film on inventory.film_id = film.film_id
where
	title = "HUNCHBACK IMPOSSIBLE"
group by title;


#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
	#List the customers alphabetically by last name:

select
	last_name
    ,first_name
    ,count(amount) as total_paid
from 
	customer join (payment) on customer.customer_id = payment.customer_id
group by 
	customer.customer_id
order by
	last_name asc;
    

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
	#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
	#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
    
select
	title
from 
	film
where
	title like 'K%' or
    title like 'Q%'
    and language_id = 
		(select language_id from language where name = 'English');
     
     
#7b. Use subqueries to display all actors who appear in the film Alone Trip

select
	first_name
    ,last_name
from
	actor
where
	actor_id in 
		(select actor_id 
        from film_actor 
        where film_id =
			(select film_id 
            from film 
            where title = "ALONE TRIP"));
            
            
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
	#Use joins to retrieve this information.
        
select
	first_name
    ,last_name
    ,email
from
	customer join (address) on customer.address_id = address.address_id
    join (city) on address.city_id = city.city_id
    join (country) on city.country_id = country.country_id
where
	country = 'Canada';
    

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
	#Identify all movies categorized as family films.

select
	title
from
	film join (film_category) on film.film_id = film_category.film_id
    join (category) on film_category.category_id = category.category_id
where
	name = 'family'
    
    
#7e. Display the most frequently rented movies in descending order.

select
	title
    ,count(title) as 'number of rentals'
from
	rental join (inventory) on rental.inventory_id = inventory.inventory_id
    join (film) on inventory.film_id = film.film_id
group by 
	title
order by
	count(title) desc;
    
#7f. Write a query to display how much business, in dollars, each store brought in.

select
	store.store_id
    ,sum(amount) as 'total_sales'
from
	payment join (staff) on payment.staff_id = staff.staff_id
    join (store) on staff.store_id = store.store_id
group by
	store.store_id;


#7g. Write a query to display for each store its store ID, city, and country.
select
	store_id
    ,city
    ,country
from
	store join (address) on store.address_id = address.address_id
    join (city) on address.city_id = city.city_id
    join (country) on city.country_id = country.country_id;
    
#7h. List the top five genres in gross revenue in descending order. 
	#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
    
select
	name
	,sum(amount) as 'gross_revenue'
from 
	payment join (rental) on payment.rental_id = rental.rental_id
    join (inventory) on rental.inventory_id = inventory.inventory_id
    join (film_category) on inventory.film_id = film_category.film_id
    join (category) on film_category.category_id = category.category_id
group by
	name
order by
	sum(amount) desc;
    
    
#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
    
create view	top_grossing_genres as
select
	name
	,sum(amount) as 'gross_revenue'
from 
	payment join (rental) on payment.rental_id = rental.rental_id
    join (inventory) on rental.inventory_id = inventory.inventory_id
    join (film_category) on inventory.film_id = film_category.film_id
    join (category) on film_category.category_id = category.category_id
group by
	name
order by
	sum(amount) desc
limit 5;


#8b. How would you display the view that you created in 8a?

select * from top_grossing_genres;


#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view top_grossing_genres;


	
	



    



