## Part-01: Rentals by Customer-Geography
# Part-01, ques-01 --- Contribution of Countries & Cities (in hierarchy) by rental amount
select sum(payment.amount) as rental_amount,city.city,country.country from 
country 
inner join city on city.country_id=country.country_id
inner join address on address.city_id=city.city_id
inner join customer on customer.address_id=address.address_id
inner join payment on payment.customer_id=customer.customer_id
group by country,city;

# Part-01, ques-02 --- Rental amounts by countries for PG & PG-13 rated films 
select sum(payment.amount) as rental_amount,country.country from 
film 
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join customer on  customer.customer_id= payment.customer_id 
inner join address on address.address_id= customer.address_id
inner join city on city.city_id= address.city_id
inner join country on country.country_id=city.country_id
where film.rating in ("PG","PG-13")
group by country
order by rental_amount desc ;

# Part-01, ques-03 --- Top 20 cities by number of customers who rented
select count(rental.customer_id) as No_of_Customers,c.city from
city as c
inner join address on address.city_id= c.city_id
inner join customer on customer.address_id= address.address_id
inner join rental on rental.customer_id=customer.customer_id
group by c.city
order by count(rental.customer_id) desc
limit 20;

# Part-01, ques-04 --- Top 20 cities by number of films rented 
select city.city, count(rental.rental_id) as No_of_films_rented from
customer as c
inner join address on address.address_id= c.address_id
inner join city on city.city_id= address.city_id
inner join rental on rental.customer_id=c.customer_id
group by city.city
order by count(rental.rental_id) desc
limit 20;

# Part-01, ques-05 --- Rank cities by average rental cost
select avg(payment.amount) as Average_rental_Amount,city.city from 
film 
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join customer on  customer.customer_id= payment.customer_id 
inner join address on address.address_id= customer.address_id
inner join city on city.city_id= address.city_id
inner join country on country.country_id=city.country_id
group by city
order by Average_rental_Amount desc;

## Rentals by Film Category
# Part-02, ques-01 -- Film categories by rental amount (ranked) & rental quantity
select category.name, sum(payment.amount) as Rental_Amount, count(rental.rental_id) as Rental_Quantity from
film 
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
group by category.name
order by Rental_Amount desc;

# Part-02, ques-02 -- Film categories by rental amount (ranked) 
select category.name, sum(payment.amount) as Rental_Amount from
film 
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
group by category.name
order by Rental_Amount desc;

# part-02, ques-03 -- Film categories by average rental amount (ranked) 
select category.name, avg(payment.amount) as Rental_Amount, dense_rank() over(order by avg(payment.amount) desc) as d_rank 
from film 
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
group by category.name;

# part-02, ques-04 -- Contribution of Film Categories by number of customers
select  category.name, count(distinct(customer.customer_id)) as No_of_Customers from
film 
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join customer on customer.customer_id=rental.customer_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
group by category.name
order by No_of_Customers desc;

# part-02, ques-05 -- Contribution of Film Categories by rental amount 
select  category.name, sum(payment.amount) as Rental_Amount , dense_rank() over(order by sum(payment.amount) desc) as d_rank
from film 
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
group by category.name;

## Rentals by Film
# part-03, ques-01 --- List Films with rental amount, rental quantity, rating, rental rate, replacement cost and category name 
select film.title, payment.amount as rental_amount, count(rental.rental_id) as rental_quantity, rating, rental_rate, replacement_cost, category.name from
film
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
group by rental_amount,rating,rental_rate, replacement_cost, category.name
order by rental_quantity asc ;

# part-03, ques-02 --- List top 10 Films by rental amount (ranked) 
select film.title, sum(payment.amount) as rental_amount, dense_rank() over(order by sum(payment.amount) desc) as d_rank from
film
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
group by film.film_id
limit 10;

# part-03, ques-03 --- List top 20 Films by number of customers (ranked)
select film.title, count(rental.customer_id) as No_of_Customers from
film
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
group by film.film_id
order by No_of_Customers desc
limit 20;

# part-03, ques-04 --- List Films with the word “punk” in title with rental amount and number of customers
select film.title, sum(payment.amount), count(rental.customer_id) as No_of_Customers from
film
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
where film.title LIKE '%punk%'
group by film.title
order by No_of_Customers desc;

# part-03, ques-05 --- Contribution by rental amount for films with a documentary category 
select  film.title, sum(payment.amount) as Rental_Amount from 
film
inner join inventory on inventory.film_id=film.film_id
inner join rental on rental.inventory_id=inventory.inventory_id
inner join payment on payment.rental_id=rental.rental_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
where category.name = 'Documentary'
group by film.film_id
order by Rental_Amount desc;

## Rentals by Customer(Last Name, First Name)

# part-04, ques-01 -- List Customers (Last name, First Name) with rental amount, rental quantity, active status, country and city
select concat(c.first_name,',',c.last_name) as Name, payment.amount, active, country, city from
customer as c
inner join address on address.address_id= c.address_id
inner join city on city.city_id= address.city_id
inner join country on country.country_id=city.country_id
inner join rental on rental.customer_id=c.customer_id
inner join payment on payment.rental_id=rental.rental_id
group by c.customer_id;

# part-04, ques-02 -- List top 10 Customers (Last name, First Name) by rental amount (ranked) for PG & PG-13 rated films
select concat(c.first_name,',',c.last_name) as Name, sum(payment.amount) from
customer as c
inner join address on address.address_id= c.address_id
inner join city on city.city_id= address.city_id
inner join country on country.country_id=city.country_id
inner join rental on rental.customer_id=c.customer_id
inner join payment on payment.rental_id=rental.rental_id
inner join inventory on inventory.inventory_id=rental.inventory_id
inner join film on inventory.film_id=film.film_id
where film.rating in ("PG","PG-13")
group by c.customer_id
order by sum(payment.amount) desc
limit 10;

# part-04, ques-03 -- Contribution by rental amount for customers from France, Italy or Germany 
select sum(payment.amount) as Rental_Amount,country.country from
customer as c
inner join address on address.address_id= c.address_id
inner join city on city.city_id= address.city_id
inner join country on country.country_id=city.country_id
inner join rental on rental.customer_id=c.customer_id
inner join payment on payment.rental_id=rental.rental_id
where country.country in ("France","Italy","Germany")
group by  country;

# part-04, ques-04 -- List top 20 Customers (Last name, First Name) by rental amount (ranked) for comedy films
select concat(c.first_name,',',c.last_name) as Name, sum(payment.amount) from
customer as c
inner join address on address.address_id= c.address_id
inner join city on city.city_id= address.city_id
inner join country on country.country_id=city.country_id
inner join rental on rental.customer_id=c.customer_id
inner join payment on payment.rental_id=rental.rental_id
inner join inventory on inventory.inventory_id=rental.inventory_id
inner join film on inventory.film_id=film.film_id
inner join film_category on film_category.film_id=film.film_id
inner join category on category.category_id=film_category.category_id
where category.name = 'Comedy'
group by c.customer_id
order by sum(payment.amount) desc
limit 20;

# part-04, ques-05 -- List top 10 Customers (Last name, First Name) from China by rental amount (ranked) for films that have
# replacement costs greater than $24 
select concat(c.first_name,',',c.last_name) as Name, sum(payment.amount) as Rental_amount from
customer as c
inner join address on address.address_id= c.address_id
inner join city on city.city_id= address.city_id
inner join country on country.country_id=city.country_id
inner join rental on rental.customer_id=c.customer_id
inner join payment on payment.rental_id=rental.rental_id
inner join inventory on inventory.inventory_id=rental.inventory_id
inner join film on inventory.film_id=film.film_id
where country.country in ("China") and film.replacement_cost >24
group by c.customer_id
order by sum(payment.amount) desc
limit 10;