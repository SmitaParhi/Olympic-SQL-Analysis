CREATE DATABASE olympic;

USE olympic;

SELECT*FROM olympic_events;


-- 1. How many olympics games have been held? 
SELECT COUNT(DISTINCT games)  FROM olympic_events;


-- 2. List down all Olympics games held so far. 
SELECT DISTINCT year,season,city FROM olympic_events
ORDER BY year;


-- 3. Mention the total no of nations who participated in each olympics game? 
SELECT games,COUNT(DISTINCT region)
FROM olympics_history oh
JOIN noc_regions nr ON nr.noc=oh.noc
GROUP BY 1;


-- 4. Which year saw the highest and lowest no of countries participating in olympics 
WITH cte AS(
	SELECT games,COUNT(DISTINCT region) AS count_country
FROM olympics_history oh
JOIN noc_regions nr ON nr.noc=oh.noc
GROUP BY 1)

SELECT DISTINCT
CONCAT(FIRST_VALUE(games) OVER(ORDER BY count_country DESC),'-',
FIRST_VALUE(count_country) OVER(ORDER BY count_country DESC)) AS highest_country,
CONCAT(FIRST_VALUE(games) OVER(ORDER BY count_country),'-',
FIRST_VALUE(count_country) OVER(ORDER BY count_country)) AS lowest_country
FROM cte;


-- 5. Identify the sport which was played in all summer olympics. 
SELECT sport,COUNT(DISTINCT games) FROM oh
GROUP BY sport
HAVING COUNT(DISTINCT games)=(SELECT COUNT(DISTINCT games) FROM oh
WHERE games LIKE '%summer%');


-- 6. Fetch the total no of sports played in each olympic games. 
SELECT games,COUNT(DISTINCT sport)
FROM oh
GROUP BY 1
ORDER BY 2 DESC;


-- 7. write an sql query to find in which sport or event india has won the highest medal.
select year,event,count(medal)
from olympic_events
where Team = 'india'
and Medal <> 'na'
group by year,event 
order by count(medal) desc;


-- 8. identify the sport or event which was played most consecutively in the summer olympic games.
select event, count(Event)
from olympic_events
where Season = 'summer'
group by event
order by count(Event) desc;


-- 9. which player has won maximum number of gold.
select name, 
sum(gold)
from 
(
select*,
case medal when 'gold' then 1 else 0 end as gold
from olympic_events) innerT
group by name 
order by sum(gold) desc;


-- 10. which sport has maximum events.

  select sport, count(*)
   from olympic_events
   group by sport
   order by count(*) desc;
       
       
-- 11. which year has the maximum events.
select year, count(event)
from olympic_events
group by year 
order by count(event) desc;


-- 12. Find the average number of medals won by each country.
SELECT participant_details.country, AVG(medals.total_medal) AS avg_medals 
FROM participant_details, medals 
GROUP BY participant_details.country;
 

--  13. Display the countries and the number of gold medals they have won in decreasing order.
SELECT participant_details.country, SUM(medals.gold_medal) AS Total_goldMedals 
FROM participant_details, medals 
GROUP BY participant_details.country 
ORDER BY COUNT(medals.gold_medal) DESC;


--  14. Display the list of people and the medals they have won in descending order, grouped by their country.
SELECT participant_details.name, SUM(medals.total_medal) AS Total_Medals 
FROM participant_details, medals 
GROUP BY participant_details.country 
ORDER BY SUM(medals.total_medal) DESC;


--  15. Display the list of people with the medals they have won according to their their age.
SELECT participant_details.name, participant_details.age , SUM(medals.total_medal) AS Total_Medals 
FROM participant_details, medals 
GROUP BY participant_details.name 
ORDER BY participant_details.age DESC;


--  16. Which country has won the most number of medals (cumulative).
SELECT participant_details.country, SUM(medals.total_medal) AS Total_Medals 
FROM participant_details, medals 
GROUP BY participant_details.country 
ORDER BY SUM(medals.total_medal) DESC LIMIT 5;
