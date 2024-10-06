-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE  netflix
(
 show_id VARCHAR(6),	
 type    VARCHAR(10),	
 title	  VARCHAR(150),
 director	VARCHAR(208),
 casts	   VARCHAR(1000),
 country	 VARCHAR(150),
 date_added	  VARCHAR(50),
 release_year	INT,
 rating          VARCHAR(10),
 duration         VARCHAR(15),	
 listed_in	        VARCHAR(100),
 description        VARCHAR(250)

);
select * FROM netflix;



select  COUNT(*) as total_content
FROM netflix;


select  DISTINCT type
FROM netflix;

select * from netflix;

-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows

SELECT 
      type,
	  count(*) as total_content
	  FROM netflix
	  group by type;


2. Find the most common rating for movies and TV shows
SELECT
     type,
	 rating
FROM
(
SELECT 
   type,
   rating,
   count(*),
      RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) AS ranking
	   FROM netflix
	   group by 1,2
	   ) as t1
	WHERE
	   ranking = 1;
	  -- order by 1, 3 desc;



3. List all movies released in a specific year (e.g., 2020)
select* from netflix
WHERE type = 'Movie'
 AND
 release_year = 2020



4. Find the top 5 countries with the most content on Netflix

SELECT 
   UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
     COUNT(show_id) as total_content
	 from netflix
	 group by 1
	 order by 2 desc
	 limit 5

SELECT
      UNNEST(STRING_TO_ARRAY(country,',')) as new_country
FROM netflix


5. Identify the longest movie

select * from netflix
WHERE
     type = 'Movie'
	 AND
	 duration = (select max(duration) FROM netflix)

	 
6. Find content added in the last 5 years

select * from netflix
where 
     to_date(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'

select current_date -interval '5 years'



7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director ilike '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons

select * from netflix
where
     type = 'TV Show'
	 duration >= 5 sessions


9. Count the number of content items in each genre

select 
      unnest(string_to_array(listed_in,',')) as genre,
	  count(show_id)
from netflix
group by 1
	

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!


total content 333/972
select
      EXTRACT(YEAR from  to_date(date_added,'Month DD,YYYY'))as year,
   count(*),
  round(
 count(*)::numeric/(select count(*) from netflix WHERE country = 'India'),2)::numeric * 100 as avg_content_per_year
from netflix
where country = 'India'
group by 1
limit 5



11. List all movies that are documentaries

select * from netflix
WHERE 
     listed_in LIKE '%Documentaries%'



12. Find all content without a director

select * from netflix
where 
     director IS NULL


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
WHERE
     casts ILIKE '%Salman Khan%'
	 AND
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
--show_id,
--casts,
UNNEST(string_to_array(casts,',')) as actors,
COUNT(*) as total_content
from netflix
where country ilike '%india'
GROUP BY 1
order by 2 desc
limit 10



15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

WITH new_table
AS
(
select *,
        CASE
		WHEN
		    description ILIKE '%kill%'
	        OR
	        description ILIKE '%violence' THEN 'Bad_Content'
			ELSE 'Good Content'
		END category	
from netflix
)
SELECT
      category,
	  COUNT(*) as total_content
	  FROM new_table
	  GROUP BY 1

	  
WHERE 
     description ILIKE '%kill%'
	 OR
	 description ILIKE '%violence'