-- Created cities table question 1-6
CREATE TABLE `cities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(17) DEFAULT NULL,
  `country_code` varchar(3) DEFAULT NULL,
  `district` varchar(20) DEFAULT NULL,
  `population` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

-- Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
-- The CountryCode for America is USA.
SELECT * FROM `cities` WHERE country_code LIKE 'USA' and population > 100000;

-- Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
-- The CountryCode for America is USA.
SELECT cities.name FROM `cities` WHERE country_code LIKE 'USA' and population > 120000;

-- Q3. Query all columns (attributes) for every row in the CITY table.
SELECT * FROM `cities`;

-- Q4. Query all columns for a city in CITY with the ID 1661.
SELECT * FROM `cities` WHERE id = 1661;

-- Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN
SELECT * FROM `cities` WHERE cities.country_code LIKE 'JPN';

-- Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.
SELECT cities.name FROM `cities` WHERE country_code LIKE 'JPN';

-- Created stations table question 7-16
CREATE TABLE `stations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `city` varchar(17) DEFAULT NULL,
  `state_code` varchar(3) DEFAULT NULL,
  `lat` int NOT NULL DEFAULT 0,
  `lng` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

-- Q7. Query a list of CITY and STATE from the STATION table.
SELECT stations.city, stations.state_code FROM `stations`;

-- Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
-- in any order, but exclude duplicates from the answer.
SELECT stations.city FROM stations WHERE stations.id%2 = 0 GROUP BY stations.city ORDER BY stations.city;

-- Q9. Find the difference between the total number of CITY entries in the table and the number of
-- distinct CITY entries in the table.
SELECT (COUNT(stations.city) - COUNT(DISTINCT stations.city)) as diff_no FROM stations;

-- Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
-- respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
-- largest city, choose the one that comes first when ordered alphabetically.
select city, char_length(city) as charactor_count from stations 
 where city = (select min(city) from stations
     where char_length(city) = (select min(char_length(city)) from stations)) 
 or city = (select min(city) from stations
     where char_length(city) = (select max(char_length(city)) from stations))

-- Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result
-- cannot contain duplicates.
SELECT city FROM stations WHERE LEFT(stations.city, 1) IN ('a', 'e', 'i', 'o', 'u') GROUP BY stations.city ORDER BY stations.city;

-- Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot
-- contain duplicates.
SELECT city FROM stations WHERE RIGHT(stations.city, 1) IN ('a', 'e', 'i', 'o', 'u') GROUP BY stations.city ORDER BY stations.city;

-- Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot
-- contain duplicates.
SELECT city FROM stations WHERE LEFT(stations.city, 1) NOT IN ('a', 'e', 'i', 'o', 'u') GROUP BY stations.city ORDER BY stations.city;

-- Q14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
SELECT city FROM stations WHERE RIGHT(stations.city, 1) NOT IN ('a', 'e', 'i', 'o', 'u') GROUP BY stations.city ORDER BY stations.city;

-- Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end
-- with vowels. Your result cannot contain duplicates
SELECT city FROM stations WHERE (LEFT(stations.city, 1) NOT IN ('a', 'e', 'i', 'o', 'u')) OR (RIGHT(stations.city, 1) NOT IN ('a', 'e', 'i', 'o', 'u')) GROUP BY stations.city ORDER BY stations.city;

-- Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with
-- vowels. Your result cannot contain duplicates.
SELECT city FROM stations WHERE (LEFT(stations.city, 1) NOT IN ('a', 'e', 'i', 'o', 'u')) AND (RIGHT(stations.city, 1) NOT IN ('a', 'e', 'i', 'o', 'u')) GROUP BY stations.city ORDER BY stations.city;

-- created table products and sales product question 17

CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) DEFAULT NULL,
  `unit_price` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

CREATE TABLE sales (
  id INT PRIMARY KEY,
  product_id INT DEFAULT NULL,
  buyer_id INT DEFAULT NULL,
  sale_date DATE,
  quantity INT DEFAULT NULL,
  price INT DEFAULT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Q17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
-- between 2019-01-01 and 2019-03-31 inclusive.
SELECT sales.product_id, products.product_name FROM `sales` JOIN products ON products.id = sales.product_id WHERE sales.sale_date >= '2019-01-01' AND sales.sale_date <= '2019-03-31' AND sales.product_id NOT IN (SELECT sales.product_id FROM sales WHERE sales.sale_date > '2019-03-31' OR sales.sale_date < '2019-01-01');

-- created table views for Question-18
CREATE TABLE views (
  article_id INT,
  author_id INT DEFAULT NULL,
  viewer_id INT,
  view_date DATE
);

-- Write an SQL query to find all the authors that viewed at least one of their own articles.
-- Return the result table sorted by id in ascending order.
SELECT views.author_id FROM `views` WHERE views.author_id = views.viewer_id GROUP BY views.author_id ORDER BY views.author_id;

-- created table deliveries for Question-19
CREATE TABLE deliveries (
  delivery_id INT PRIMARY KEY,
  customer_id INT DEFAULT NULL,
  order_date DATE,
  customer_pref_delivery_date DATE
);

-- Q-19. If the customer's preferred delivery date is the same as the order date, then the order is called
-- immediately; otherwise, it is called scheduled.
-- Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decima
SELECT CAST((SUM(IF(deliveries.order_date = deliveries.customer_pref_delivery_date, 1, 0))/COUNT(deliveries.delivery_id) * 100) AS DECIMAL(4,2)) as immediate_percentage FROM `deliveries`;

-- create table ads for question 20
CREATE TABLE ads (
  ad_id INT,
  user_id INT,
  action ENUM('Clicked', 'Viewed', 'Ignored'),
  PRIMARY KEY(ad_id, user_id)
);

--Q-20. Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
-- Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a tie.
SELECT ads.ad_id, CAST(SUM(IF(ads.action = 'Clicked', 1, 0))/(SUM(IF(ads.action = 'Clicked', 1, 0)) + SUM(IF(ads.action = 'Viewed', 1, 0))) * 100 AS DECIMAL(4,2)) as ctr FROM `ads` GROUP BY ads.ad_id;

-- created table employees for Q-21
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  team_id INT DEFAULT NULL
);

-- Q-21. Write an SQL query to find the team size of each of the employees
SELECT emp.employee_id, (select COUNT(employee_id) from employees WHERE employees.team_id = emp.team_id) as team_size FROM employees as emp;

-- Created table for countries and weathers for Q-22
CREATE TABLE countries (
  country_id INT PRIMARY KEY,
  country_name VARCHAR(255) DEFAULT NULL
);

CREATE TABLE weathers (
  country_id INT,
  weather_state INT,
  day DATE,
  PRIMARY KEY(country_id, day)
);

-- Q-22. Write an SQL query to find the type of weather in each country for November 2019.
-- The type of weather is:
-- ● Cold if the average weather_state is less than or equal 15,
-- ● Hot if the average weather_state is greater than or equal to 25, and
-- ● Warm otherwise.
SELECT countries.country_name, IF((SUM(weathers.weather_state)/COUNT(weathers.weather_state)) <= 15, 'Cold', IF((SUM(weathers.weather_state)/COUNT(weathers.weather_state)) <= 25, 'Hot', 'Warm')) as weather_type FROM `weathers` JOIN countries ON weathers.country_id = countries.country_id WHERE DATE_FORMAT(weathers.day, "%c") = 11 GROUP BY weathers.country_id;

-- created table for prices and units_sold for Q-23
CREATE TABLE prices (
  product_id INT,
  start_date DATE,
  end_date DATE,
  price INT,
  PRIMARY KEY(product_id, start_date, end_date)
);

CREATE TABLE units_sold (
  product_id INT,
  purchase_date DATE,
  units INT
);

--Q-23 Write an SQL query to find the average selling price for each product. average_price should be
-- rounded to 2 decimal places
SELECT temp_sales.product_id, CAST(SUM(temp_sales.total_price)/ SUM(temp_sales.total_product) AS DECIMAL(7,2)) as average_price FROM
(
 SELECT prices.product_id, (SELECT SUM(units_sold.units) FROM units_sold WHERE units_sold.product_id = prices.product_id AND units_sold.purchase_date >= prices.start_date AND units_sold.purchase_date <= prices.end_date) * prices.price as total_price,
(SELECT SUM(units_sold.units) FROM units_sold WHERE units_sold.product_id = prices.product_id AND units_sold.purchase_date >= prices.start_date AND units_sold.purchase_date <= prices.end_date) as total_product
FROM `prices`
) temp_sales GROUP BY temp_sales.product_id;

-- Created table activities for Q-24,Q-25
CREATE TABLE activities (
  player_id INT,
  device_id INT,
  event_date DATE,
  games_played INT,
  PRIMARY KEY(player_id, event_date);
);

-- Q-24. Write an SQL query to report the first login date for each player
SELECT activities.player_id, MIN(activities.event_date) as first_login FROM `activities` GROUP BY player_id;

-- Q-25. Write an SQL query to report the device that is first logged in for each player.
SELECT activities.player_id, activities.device_id, MIN(activities.event_date) as first_login FROM `activities` GROUP BY player_id;


-- Created below tables for Q-26
CREATE TABLE `product` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) DEFAULT NULL,
   product_category varchar(255) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
);

CREATE TABLE `order` (
  `product_id` int NOT NULL,
  `order_date` DATE,
   unit INT
);

-- Q-26. Write an SQL query to get the names of products that have at least 100 units ordered in February 2020 and their amount.
SELECT * from
(SELECT product.product_name, SUM(order.unit) as unit FROM `order` JOIN product ON product.product_id = order.product_id WHERE DATE_FORMAT(order.order_date, "%c") = 2 AND DATE_FORMAT(order.order_date, "%Y") = 2020 GROUP BY order.product_id) temp 
WHERE temp.unit >= 100;

-- Created table for Q-27
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
   mail varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
);

-- Q-27. A valid e-mail has a prefix name and a domain where:
SELECT * FROM `users` WHERE lower(users.mail) REGEXP '[A-Za-z0-9._%+-]+@leetcode\.com';

-- Created table for Q-28
CREATE TABLE `customers_28` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
   country varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
);

CREATE TABLE `products_28` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
   price INT DEFAULT NULL,
  PRIMARY KEY (`product_id`)
);

CREATE TABLE `orders_28` (
  `order_id` int NOT NULL AUTO_INCREMENT,
   customer_id INT,
   product_id INT,
   order_date DATE,
   quantity INT DEFAULT NULL,
  PRIMARY KEY (`order_id`)
);

-- Q-28. Write an SQL query to report the customer_id and customer_name of customers who have spent at
-- least $100 in each month of June and July 2020
select customer_id, name FROM
    (select customer_id, name, COUNT(*) as month_count FROM
    (
    select * from 
        (
        SELECT orders_28.customer_id, customers_28.name, SUM(orders_28.quantity * products_28.price) as total_price, DATE_FORMAT(orders_28.order_date, "%c") as month_no FROM `orders_28`  JOIN products_28 ON products_28.product_id = orders_28.product_id 
        JOIN customers_28 ON customers_28.customer_id = orders_28.customer_id WHERE DATE_FORMAT(orders_28.order_date, "%c") IN (6,7) GROUP BY 	orders_28.customer_id, DATE_FORMAT(orders_28.order_date, "%c"
        )
    ) temp WHERE total_price >= 100
    ) temp_2 GROUP BY customer_id
) as t2 WHERE month_count = 2;

-- Created tables for Q-29.
CREATE TABLE `tv_Programs` (
   program_date DATE,
   content_id INT,
   order_date DATE,
   channel VARCHAR(255),
  PRIMARY KEY (program_date, content_id)
);

CREATE TABLE contents (
  content_id INT,
  title VARCHAR(255),
  Kids_content ENUM('Y', 'N'),
  content_type VARCHAR(155),
  PRIMARY KEY(content_id)
);

-- Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.
-- Return the result table in any order.
SELECT DISTINCT contents.title FROM `tv_Programs` JOIN contents ON contents.content_id = tv_Programs.content_id WHERE DATE_FORMAT(tv_Programs.program_date, "%c")  = 6 AND contents.content_type LIKE 'Movies' AND contents.Kids_content = 'Y';

-- CReated tables for Q-30.
CREATE TABLE `npvs` (
   id INT,
   year INT,
   npv INT,
  PRIMARY KEY (id, year)
);

CREATE TABLE `queries` (
   id INT,
   year INT,
  PRIMARY KEY (id, year)
)

-- Q-30. Write an SQL query to find the npv of each query of the Queries table
SELECT queries.id, queries.year, IF(npvs.npv IS NOT NULL, npvs.npv, 0) as npv FROM `queries` LEFT JOIN npvs ON npvs.id = queries.id AND npvs.year = queries.year;

-- Q-31. Write an SQL query to find the npv of each query of the Queries table
SELECT queries.id, queries.year, IF(npvs.npv IS NOT NULL, npvs.npv, 0) as npv FROM `queries` LEFT JOIN npvs ON npvs.id = queries.id AND npvs.year = queries.year;

-- Created tables for Q-32
CREATE TABLE `employee` (
   id INT,
   name VARCHAR(155),
  PRIMARY KEY(id)
);

CREATE TABLE `Employee_uni` (
   id INT,
   unique_id INT,
  PRIMARY KEY(id, unique_id)
);

--Q-32. Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just show null.
SELECT Employee_uni.unique_id, employee.name FROM `employee` LEFT JOIN Employee_uni ON Employee_uni.id = employee.id;

-- created table for Q-33
CREATE TABLE `user` (
   id INT,
   name VARCHAR(155),
  PRIMARY KEY(id)
);

CREATE TABLE `rides` (
   id INT,
   user_id INT,
   distance INT,
  PRIMARY KEY(id)
);

-- Q-33. Write an SQL query to report the distance travelled by each user.
-- Return the result table ordered by travelled_distance in descending order, if two or more users
-- travelled the same distance, order them by their name in ascending order
SELECT user.name, SUM(IF(rides.distance IS NOT NULL, rides.distance, 0)) as travelled_distance FROM `user` LEFT JOIN rides ON rides.user_id = user.id GROUP BY user.id ORDER BY travelled_distance DESC, name asc;

-- Q-34. Write an SQL query to get the names of products that have at least 100 units ordered in February 2020 and their amount.
SELECT * from
(SELECT product.product_name, SUM(order.unit) as unit FROM `order` JOIN product ON product.product_id = order.product_id WHERE DATE_FORMAT(order.order_date, "%c") = 2 AND DATE_FORMAT(order.order_date, "%Y") = 2020 GROUP BY order.product_id) temp 
WHERE temp.unit >= 100;

-- Created tables for Q-35
CREATE TABLE `movies` (
   movie_id INT,
   title VARCHAR(155),
  PRIMARY KEY(movie_id)
);

CREATE TABLE `users_1` (
   user_id INT,
   name VARCHAR(155),
  PRIMARY KEY(user_id)
);

CREATE TABLE `movie_ratings` (
   movie_id INT,
   user_id INT,
   rating INT,
   created_at DATE,
  PRIMARY KEY(movie_id, user_id)
);

-- Q-35 Write an SQL query to:
-- ● Find the name of the user who has rated the greatest number of movies. In case of a tie,
-- return the lexicographically smaller user name.
-- ● Find the movie name with the highest average rating in February 2020. In case of a tie, return
-- the lexicographically smaller movie name
SELECT name from
(SELECT users_1.name, COUNT(movie_ratings.movie_id) as rating_count FROM `movie_ratings` JOIN users_1 ON users_1.user_id = movie_ratings.user_id GROUP BY users_1.user_id ORDER BY rating_count DESC, users_1.name ASC LIMIT 1) temp1
UNION
SELECT title as name FROM 
(SELECT movies.title, AVG(movie_ratings.rating) as avg_rating FROM movie_ratings JOIN movies ON movies.movie_id = movie_ratings.movie_id WHERE DATE_FORMAT(movie_ratings.created_at, "%c") = 2 GROUP BY movie_ratings.movie_id ORDER BY avg_rating DESC, movies.title ASC LIMIT 1
) temp2;

-- Q-36. Write an SQL query to report the distance travelled by each user.
-- Return the result table ordered by travelled_distance in descending order, if two or more users
-- travelled the same distance, order them by their name in ascending order.
SELECT user.name, SUM(IF(rides.distance IS NOT NULL, rides.distance, 0)) as total_distance FROM user LEFT JOIN rides ON rides.user_id = user.id GROUP BY user.id ORDER BY total_distance DESC, name ASC;

-- Q-37.Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just show null.
SELECT Employee_uni.unique_id, employee.name FROM `employee` LEFT JOIN Employee_uni ON Employee_uni.id = employee.id;

-- Created table for Q-38.
CREATE TABLE `departments` (
   id INT,
   name VARCHAR(155),
  PRIMARY KEY(user_id)
);

CREATE TABLE `students` (
   id INT,
   name VARCHAR(155),
   department_id INT,
  PRIMARY KEY(id)
);

-- Q-38. Write an SQL query to find the id and the name of all students who are enrolled in departments that no longer exist.
SELECT students.id, students.name FROM `students` WHERE NOT EXISTS(SELECT students.department_id FROM departments WHERE departments.id = students.department_id);

-- created table for Q-39
CREATE TABLE `calls` (
   from_id INT,
   to_id INT,
   duration INT
);
-- Q-39 Write an SQL query to report the number of calls and the total call duration between each pair of
-- distinct persons (person1, person2) where person1 < person2.
SELECT from_id as person_1, to_id as person_2, COUNT(from_id) as call_count, SUM(duration) as total_duration FROM `calls` GROUP BY (from_id + to_id);

-- Q-40.
SELECT temp_sales.product_id, CAST(SUM(temp_sales.total_price)/ SUM(temp_sales.total_product) AS DECIMAL(7,2)) as average_price FROM
(
 SELECT prices.product_id, (SELECT SUM(units_sold.units) FROM units_sold WHERE units_sold.product_id = prices.product_id AND units_sold.purchase_date >= prices.start_date AND units_sold.purchase_date <= prices.end_date) * prices.price as total_price,
(SELECT SUM(units_sold.units) FROM units_sold WHERE units_sold.product_id = prices.product_id AND units_sold.purchase_date >= prices.start_date AND units_sold.purchase_date <= prices.end_date) as total_product
FROM `prices`
) temp_sales GROUP BY temp_sales.product_id;

-- Q-41.
CREATE TABLE `warehouse` (
   name VARCHAR(155),
   product_id INT,
   units INT
);

CREATE TABLE `products_41` ( product_id INT, product_name VARCHAR(155), width INT, length INT, height INT, PRIMARY KEY(product_id) );

-- Q-41.Write an SQL query to report the number of cubic feet of volume the inventory occupies in each warehouse.
SELECT warehouse.name, SUM(products_41.length * products_41.width * products_41.height * warehouse.units) as total_volume FROM `warehouse` JOIN products_41 ON products_41.product_id = warehouse.product_id GROUP BY warehouse.name;

-- Q-42
CREATE TABLE sales_42 (
  sale_date DATE,
  fruit ENUM('apples', 'oranges'),
  sold_num INT,
  PRIMARY KEY(sale_date, fruit)
);

-- Q-42. Write an SQL query to report the difference between the number of apples and oranges sold each day. Return the result table ordered by sale_date.
SELECT sales_42.sale_date, SUM(IF(fruit = 'apples', sold_num, 0)) - SUM(IF(fruit = 'oranges', sold_num, 0)) as diff  FROM `sales_42` GROUP BY sale_date;

-- Q-43. Write an SQL query to report the fraction of players that logged in again on the day after the day they
-- first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
-- that logged in for at least two consecutive days starting from their first login date, then divide that
-- number by the total number of players.
WITH CTE AS (
 SELECT player_id, min(event_date) as event_start_date from Activity group by player_id 
)
SELECT round((count(distinct c.player_id) / (select count(distinct player_id) from activity)),2)as fraction FROM
CTE c JOIN Activity a on c.player_id = a.player_id and datediff(c.event_start_date, a.event_date) = -1;

-- Q-44
CREATE TABLE `employee_45` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
   department varchar(255) DEFAULT NULL,
   manager_id INT,
  PRIMARY KEY (`id`)
);

-- Q-44 Write an SQL query to report the managers with at least five direct reports. Return the result table in any orde
SELECT employee_45.name from 
(SELECT emp.manager_id, COUNT(emp.manager_id) FROM `employee_45` as emp WHERE (select COUNT(manager_id) FROM employee_45 WHERE emp.manager_id = employee_45.manager_id) >= 5 GROUP BY manager_id) as temp join employee_45 ON employee_45.id = temp.manager_id;

-- Q-45
CREATE TABLE `students_45` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `student_name` varchar(255) DEFAULT NULL,
   gender varchar(255) DEFAULT NULL,
   dept_id INT,
  PRIMARY KEY (`student_id`)
);

CREATE TABLE `departments_45` ( `dept_id` int NOT NULL AUTO_INCREMENT, `dept_name` varchar(255) DEFAULT NULL, PRIMARY KEY (`dept_id`) );

-- Q-45. Write an SQL query to report the respective department name and number of students majoring in
-- each department for all departments in the Department table (even ones with no current students).
-- Return the result table ordered by student_number in descending order. In case of a tie, order them by
-- dept_name alphabetically.
SELECT departments_45.dept_name, COUNT(students_45.student_id) as student_number FROM `departments_45` LEFT JOIN students_45 ON students_45.dept_id = departments_45.dept_id GROUP BY departments_45.dept_id;

-- Q46.
CREATE TABLE `customer_46` (
  `customer_id` int,
  `product_key` INT
);

CREATE TABLE `product_46` (
  `product_key` INT
);

-- Q-46..Write an SQL query that reports the most experienced employees in each project. In case of a tie,
-- report all employees with the maximum number of experience years.
-- Return the result table in any order.
SELECT customer_46.customer_id FROM  `customer_46` WHERE (SELECT GROUP_CONCAT(cus.product_key) FROM customer_46 as cus WHERE cus.customer_id = customer_46.customer_id) = (SELECT GROUP_CONCAT(product_46.product_key) FROM product_46) GROUP BY customer_46.customer_id;

-- Q-47. Write an SQL query that reports the most experienced employees in each project. In case of a tie,
-- report all employees with the maximum number of experience years.
select * from
( select p.project_id, e.employee_id,e.experience_years, Rank() over (partition by project_id order by experience_years desc ) as rank_experience from Project p join employee e on p.employee_id = e.employee_id
) where rank_experience=1;

-- Q-48. Write an SQL query that reports the books that have sold less than 10 copies in the last year,
-- excluding books that have been available for less than one month from today. Assume today is 2019-06-23.
SELECT b.book_id, b.NAME 
FROM books AS b LEFT JOIN orders AS o ON b.book_id = o.book_id AND dispatch_date BETWEEN '2018-06-23' AND '2019-6-23' WHERE Datediff('2019-06-23', b.available_from) > 30 
GROUP BY book_id HAVING Sum(IFNULL(o.quantity, 0)) < 10 ORDER  BY NULL;

-- Q-49. Write a SQL query to find the highest grade with its corresponding course for each student. In case of
-- a tie, you should find the course with the smallest course_id.
select student_id, min(course_id) as course_id, grade from Enrollments where (student_id, grade) in (
 select student_id, max(grade) from Enrollments group by student_id)
group by student_id;

-- Q-50. Write an SQL query to find the winner in each group.
-- Return the result table in any order.
select group_id, player_id from (
	select p.group_id, ps.player_id, sum(ps.score) as score
	from Players p,
	    (
            select first_player as player_id, first_score as score
            from Matches
            union all
            select second_player, second_score
            from Matches
	    ) ps
	where p.player_id = ps.player_id
	group by ps.player_id
	order by group_id, score desc, player_id
	-- limit 1 -- by default, groupby will pick the first one i.e. max score player here
) top_scores
group by group_id;