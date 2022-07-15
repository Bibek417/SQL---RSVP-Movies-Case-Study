USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT Count(*) FROM director_mapping ;

-- director_mapping table have 3867 rows

SELECT Count(*) FROM  genre ;

-- genre table have 14662 rows

SELECT Count(*) FROM  movie;

-- movie table 7997 rows

SELECT Count(*) FROM  names;

-- names table have 25735 rows

SELECT Count(*) FROM  role_mapping ;

-- role_mapping table have 15615 rows



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
/* movie table have 9 columns as total
	id,title,year,date_published,duration,country,worlwide_gross_income,languages,production_company
*/
SELECT Count(*) FROM movie WHERE id IS NULL ;
-- id is the primary key for movie table so its obvious that its dont have any null value

SELECT Count(*) FROM  movie WHERE title IS NULL ;
 -- title column dont have any null values 
 
 SELECT Count(*) FROM  movie WHERE year IS NULL  ;
 -- year column dont have any null values 
 
SELECT Count(*) FROM  movie WHERE date_published IS NULL  ;
-- date_published column also don't have any null values 

SELECT Count(*) FROM  movie WHERE duration IS NULL  ;
-- duration column don't have any null values 

SELECT Count(*) FROM  movie WHERE country IS NULL  ;
-- country column have  20  null values 

SELECT Count(*) FROM  movie WHERE worlwide_gross_income IS NULL  ;
-- worlwide_gross_income column have 3724 null values 

SELECT Count(*) FROM movie WHERE languages IS NULL  ;
-- languages column have 194 null values 

SELECT Count(*) FROM  movie WHERE production_company IS NULL  ;
-- production_company column have 528 null values 

/* These 4 columns having null values in movie table :-
   country,worlwide_gross_income,languages & production_company
*/ 
 



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year ;   

SELECT month(date_published) AS month_num ,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY month_num 
ORDER BY number_of_movies DESC;

/* From this data highest movies are released in 2017
  and as per month  highest movies are released in march
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(id) AS Number_of_movies,
       year AS Released_year
FROM   movie
WHERE  ( country REGEXP 'usa'
          OR country REGEXP 'india' )
       AND year = 2019; 

/* A total  1059 movies was released  in USA or India in 2019 
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre ;
 -- This data having 13 type of genres 



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(movie_id) AS movies_count
FROM   movie m
       INNER JOIN genre g
               ON g.movie_id = m.id
GROUP  BY g.genre 
ORDER BY movies_count DESC; 

-- Drama genre had highest number of movies produce overall



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH single_genre
     AS (SELECT movie_id,
                Count(movie_id)
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(movie_id) = 1)
SELECT Count(movie_id) AS single_genre_movies
FROM   single_genre; 

-- There a total 3289 movies having single genre 


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
       Avg(m.duration) AS avg_duration 
FROM   movie m
       INNER JOIN genre g
               ON g.movie_id = m.id
GROUP  BY g.genre 
ORDER BY avg_duration; 

/* Genre Action  having highest average duration of 112.8829 mins.
   Genre Horror having lowest average duration  of 92.7243 mins.
   Genre Drama having  average duration  of 106.77 mins.
 */


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT genre,
       Count(movie_id) AS movie_count,
       Rank()
         OVER(
           ORDER BY Count(movie_id) DESC) AS genre_rank
FROM   movie m
       INNER JOIN genre g
               ON g.movie_id = m.id
GROUP  BY g.genre; 

-- Top 3 genre according to movies produced are  Drama , Comedy & Thriller 
-- Genre Thriller have rank 3


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH movies_rating
     AS (SELECT title,
                avg_rating,
                Rank()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id)
SELECT *
FROM   movies_rating
WHERE  movie_rank <= 10;


-- 'Kirket' and 'Love in Kilnerry' movie title having highest average rating 10.00 

-- lets see from those top 10 movies how many movies comes under each genre
WITH movies_rating
     AS (SELECT title,
                avg_rating,
                genre,
                Rank()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN genre g
                        ON g.movie_id = m.id)
SELECT genre,
       Count(genre) AS movies_count
FROM   movies_rating
WHERE  movie_rank <= 10
GROUP  BY genre 
ORDER BY movies_count DESC;


-- so from those top 10 movies according to average rating 4 movies are comes under genre Drama .

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating ;

-- median rating 7 having 2257 movies as total. 



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company,
       Count(m.id) AS movie_count,
       DENSE_RANK()
         OVER(
           ORDER BY Count(m.id) DESC) AS prod_company_rank
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company;

-- Dream Warrior Pictures and  National Theatre Live are produced the most number of hit movies.





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       Count(id) AS movie_count
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country REGEXP 'usa'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

-- Genre "Drama" have highest movies released on March 2017 in the USA and genre "Family" have lowest .




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title,
       avg_rating,
       genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  title REGEXP '^The'
       AND avg_rating > 8 
ORDER BY avg_rating DESC; 



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT title,
       median_rating,
       genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  title REGEXP '^The'
       AND avg_rating > 8 
ORDER BY median_rating DESC; 



-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(id) AS movies_count
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND median_rating = 8 ; 

-- There a total 361 movies are released between 1 April 2018 and 1 April 2019 which having more then 8 median_rating .





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT Sum(total_votes) AS total_votes
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  languages REGEXP 'German' ;

SELECT Sum(total_votes) AS total_votes
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  languages REGEXP 'Italian' ;

/* German movies have more then  4.4 million views and 
   Italian movies have more then  2.5 million views 
   yes,German movies get more views than Italian movies
*/ 


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT Count(*) AS name_nulls
FROM   names
WHERE  NAME IS NULL;

SELECT Count(*) AS height_nulls
FROM   names
WHERE  height IS NULL;

SELECT Count(*) AS date_of_birth_nulls
FROM   names
WHERE  date_of_birth IS NULL;

SELECT Count(*) AS known_for_movies_nulls
FROM   names
WHERE  known_for_movies IS NULL; 

/* name column dont have any null values 
   height column have 17335 null values 
   date_of_birty column have 13431 null values
   known_for_movies column have 15226 null values
*/





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- lets create a view which having top 3 genres with an average rating > 8.
CREATE VIEW top3_genre AS
SELECT     genre ,
           Rank() OVER(ORDER BY Count(id) DESC ) AS genre_rank
FROM       movie m
INNER JOIN genre g
ON         g.movie_id=m.id
INNER JOIN ratings r
ON         r.movie_id=m.id
WHERE      avg_rating > 8
GROUP BY   g.genre limit 3;

SELECT * FROM top3_genre;
-- top 3 genres are 'Drama','Action','Comedy' 

-- now lets find the top director from these top 3  genre
SELECT name        AS director_name,
       Count(m.id) AS movie_count
FROM   movie m
       INNER JOIN genre g
               ON g.movie_id = m.id
       INNER JOIN director_mapping d
               ON d.movie_id = m.id
       INNER JOIN names n
               ON n.id = d.name_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  g.genre IN (SELECT genre
                   FROM   top3_genre)
       AND r.avg_rating > 8
GROUP  BY n.name
ORDER  BY movie_count DESC
LIMIT  3; 

/* 'James Mangold' is the top director amoung those top genres. 
 followed by 'Joe Russo' and  'Anthony Russo'
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT      n.NAME AS actor_name ,
       Count(m.id) AS movie_count
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
       INNER JOIN role_mapping o
               ON o.movie_id = m.id
       INNER JOIN names n
               ON n.id = o.name_id
WHERE  o.category = 'actor'
       AND median_rating >= 8
GROUP  BY n.NAME
ORDER  BY movie_count DESC;
 
--  'Mammootty' and ''Mohanlal' are the top two actors whose movies have a median rating >= 8


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
       Sum(total_votes)  AS vote_count,
       Rank()
         OVER(
           ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
GROUP  BY production_company; 

-- 'Marvel Studios' is highest voted  production company 
-- TOP 3 production companys are 'Marvel Studios' , 'Twentieth Century Fox' and 'Warner Bros.'


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_summery
     AS (SELECT NAME                                                       AS actor_rank,
                Sum(total_votes)                                           AS total_votes,
                Count(m.id)                                                AS movie_count,
                Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS actor_avg_rating
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping o
                        ON o.movie_id = m.id
                INNER JOIN names n
                        ON n.id = o.name_id
         WHERE  country = 'india'
                AND category = 'actor' 
         GROUP  BY NAME
         HAVING movie_count >= 5)
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM   actor_summery; 

-- 'Vijay Sethupathi' is the top actor according to weighted average based on votes 
-- followed by 'Fahadh Faasil' , 'Yogi Babu'  and 'Joju George'


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_summery AS
(
           SELECT     NAME                                                       AS actress_name,
                      Sum(total_votes)                                           AS total_votes,
                      Count(m.id)                                                AS movie_count,
                      Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS actress_avg_rating
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id = r.movie_id
           INNER JOIN role_mapping o
           ON         o.movie_id = m.id
           INNER JOIN names n
           ON         n.id = o.name_id
           WHERE      country = 'india'
           AND        category = 'actress'
           AND        languages regexp 'HINDI'
           GROUP BY   NAME
           HAVING     count(m.id) >= 3)
SELECT   *,
         rank() OVER( ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM     actor_summery ;

-- 'Taapsee Pannu' is the top actress in Hindi movies released in India 
-- followed by 'Kriti Sanon' , 'Divya Dutta' ,  'Shraddha Kapoor' , 'Kriti Kharbanda'


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT id,
       title,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS movie_type
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  genre REGEXP 'Thriller'
GROUP  BY id
ORDER  BY avg_rating DESC ; 








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH avg_duration_summery
     AS (SELECT genre,
                Avg(duration) AS avg_duration
         FROM   movie m
                inner join genre g
                        ON m.id = g.movie_id
         GROUP  BY genre
         ORDER  BY genre)
SELECT *,
       SUM(avg_duration)
         over(
           ORDER BY avg_duration DESC ROWS unbounded preceding) AS running_total_duration,
       Avg(avg_duration)
         over(
           ORDER BY avg_duration DESC ROWS unbounded preceding) AS moving_avg_duration
FROM   avg_duration_summery;

-- Action movies have highest average duration of 112.88 min . 
-- horror and Sci-Fi movies having lowest average duration of 97.94 and 92.72 respectively .




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)movie

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- lets make a view on  Top 3 Genres based on most number of movies

CREATE VIEW top_3_genres AS
SELECT     genre ,
           Count(id)                             AS movie_count ,
           Rank() OVER(ORDER BY Count(id) DESC ) AS genre_rank
FROM       movie m
INNER JOIN genre g
ON         g.movie_id=m.id
GROUP BY   g.genre limit 3;

-- lets see what are the top 5 movies from each year 
   
WITH summery AS
(
           SELECT     * ,        -- we have to modify worlwide_gross_income column for better analysis
                      CASE
                                 WHEN worlwide_gross_income regexp 'INR' THEN cast(replace(worlwide_gross_income,'INR','') AS decimal )
                                 WHEN worlwide_gross_income regexp '$' THEN cast(replace(worlwide_gross_income,'$' ,'') AS    decimal)
                                 ELSE 0
                      END AS worlwide_gross_income_converted
           FROM       movie m
           INNER JOIN genre g
           ON         g.movie_id=m.id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top_3_genres) ) , ranking_summery AS
(
         SELECT   genre,
                  year,
				  title AS movie_name ,
                  worlwide_gross_income ,
                  dense_rank() OVER(partition BY year ORDER BY worlwide_gross_income_converted DESC) AS movie_rank
         FROM     summery )
SELECT *
FROM   ranking_summery
WHERE  movie_rank <= 5; 

/*  Top five highest-grossing movies in year 2017 are 
		 -'The Fate of the Furious'
		 -'Despicable Me 3'
         -'Jumanji: Welcome to the Jungle'
         -'Zhan lang II'
		 -'Guardians of the Galaxy Vol. 2'
	Top five highest-grossing movies in year 2018 are 
         -'The Villain'
         -'Bohemian Rhapsody'
         -'Venom'
         -'Mission: Impossible - Fallout'
         -'Deadpool 2'
    Top five highest-grossing movies in year 2019 are 
         -'Avengers: Endgame'
         -'The Lion King'
         -'Toy Story 4'
         -'Joker'
         -'Ne Zha zhi mo tong jiang shi'
*/ 

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     production_company ,
           Count(id)                                  AS movie_count,
           Dense_rank() OVER(ORDER BY Count(id) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         r.movie_id=m.id
WHERE      languages regexp ','
AND        median_rating >= 8
GROUP BY   production_company
HAVING     production_company IS NOT NULL ;

/* 'Star Cinema' and 'Twentieth Century Fox' are top two production houses that 
  have produced the highest number of hits  among multilingual movies */




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT NAME                           AS actress_name,
       Sum(total_votes)               AS total_votes,
       Count(m.id)                    AS movie_count,
       Round(Avg(avg_rating), 2)      AS actress_avg_rating,
       Dense_rank()
         OVER(
           ORDER BY Count(m.id) DESC) AS actress_rank
FROM   movie m
       INNER JOIN genre g
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON r.movie_id = m.id
       INNER JOIN role_mapping o
               ON o.movie_id = m.id
       INNER JOIN names n
               ON n.id = o.name_id
WHERE  avg_rating > 8
       AND genre = 'drama'
       AND category = 'actress'
GROUP  BY NAME; 


/* 'Parvathy Thiruvothu' ,'Susan Brown' , 'Amanda Lawrence' , 'Denise Gough' 
	are the top 3 actresses based on number of Super Hit movies in drama genre  */


-- lets see who are the top actors in drama genre

SELECT NAME                           AS actor_name,
       Sum(total_votes)               AS total_votes,
       Count(m.id)                    AS movie_count,
       Round(Avg(avg_rating), 2)      AS actor_avg_rating,
       Rank()
         OVER(
           ORDER BY Count(m.id) DESC) AS actress_rank
FROM   movie m
       INNER JOIN genre g
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON r.movie_id = m.id
       INNER JOIN role_mapping o
               ON o.movie_id = m.id
       INNER JOIN names n
               ON n.id = o.name_id
WHERE  avg_rating > 8
       AND genre = 'drama'
       AND category = 'actor'
GROUP  BY NAME; 

-- 'Andrew Garfield' is top actor  based on number of Super Hit movies  in drama genre .

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- lets see who are the top 9 directors and make a view 
CREATE view top9_directors
AS
  SELECT name        AS director_name,
         Count(m.id) AS movies_count
  FROM   names n
         INNER JOIN director_mapping d
                 ON d.name_id = n.id
         INNER JOIN movie m
                 ON m.id = d.movie_id
  GROUP  BY name
  ORDER  BY movies_count DESC
  LIMIT  9; 

 -- lets analyse those top9 directors details 
WITH total_summery
     AS (SELECT n.id AS director_id,
                NAME AS director_name,
                m.id AS film_id,
                avg_rating,
                total_votes,
                duration,
                date_published
         FROM   names n
                INNER JOIN director_mapping d
                        ON d.name_id = n.id
                INNER JOIN movie m
                        ON m.id = d.movie_id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  NAME IN (SELECT director_name
                         FROM   top9_directors)),
     next_published_date_summery
     AS (SELECT *,
                Lead(date_published, 1)
                  OVER(
                    partition BY director_id
                    ORDER BY date_published) AS next_published_date
         FROM   total_summery),
     date_difference_summery
     AS (SELECT *,
                Datediff(next_published_date, date_published) AS days_difference
         FROM   next_published_date_summery)
SELECT director_id,
       director_name,
       Count(film_id)              AS number_of_movies,
       Round(Avg(days_difference)) AS avg_inter_movie_days,
       Round(Avg(avg_rating), 2)   AS avg_rating,
       Sum(total_votes)            AS total_votes,
       Min(avg_rating)             AS min_rating,
       Max(avg_rating)             AS max_rating,
       Sum(duration)               AS total_duration
FROM   date_difference_summery
GROUP  BY director_id
ORDER  BY number_of_movies DESC,
          director_name ASC; 

/* - from the top 9 directors director 'Steven Soderbergh' having highest average rating 6.48 and highest votes also .
   - Director 'Özgür Bakar' directing 4 movies and having lowest average inter movie duration 112 .
   - Director 'A.L. Vijay' and 'Andrew Jones' directing most number of movies. 
*/
