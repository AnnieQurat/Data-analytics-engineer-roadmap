-- 01 SELECT, WHERE, DISTINCT, GROUP BY, LIMIT
-- Practice questions from SQLBolt and interview-style practice sets.

-- Q1: Unique wine varieties tasted by 'Roger Voss' that have a value in region_1.
SELECT DISTINCT variety
FROM winemag_p2
WHERE taster_name = 'Roger Voss'
  AND region_1 IS NOT NULL;

-- Q2: How many times does each artist appear in the Spotify worldwide rankings?
SELECT
    artist,
    COUNT(*) AS artist_count
FROM spotify_worldwide_daily_song_ranking
GROUP BY artist;

-- Q3: How many times did each song rank #1 (every day in every region counts)?
-- Note: COUNT(*) counts the rows. SUM(position) only worked because every
-- position here is 1, so it is the wrong tool even though the numbers match.
SELECT
    trackname,
    COUNT(*) AS times_ranked_first
FROM spotify_worldwide_daily_song_ranking
WHERE position = 1
GROUP BY trackname;

-- Q4: Total sales revenue of two salespeople as a single number (no GROUP BY needed).
SELECT SUM(sales_revenue) AS total_revenue
FROM sales_performance
WHERE salesperson IN ('Samantha', 'Lisa');

-- Q5: The hour of the single ride with the highest gasoline cost.
SELECT hour
FROM lyft_rides
ORDER BY gasoline_cost DESC
LIMIT 1;

-- Q6: Longest time an employee has been at the studio.
SELECT MAX(Years_employed) AS max_years_employed
FROM employees;

-- Q7: Lowest, average and highest age of athletes across all Olympics.
SELECT
    MIN(age) AS min_age,
    AVG(age) AS avg_age,
    MAX(age) AS max_age
FROM olympics_athletes_events;

-- Q8: Pagination: movie titles in alphabetical order, rows 6 to 10.
SELECT title
FROM movies
ORDER BY title ASC
LIMIT 5 OFFSET 5;

-- Q9: Movies released in an even-numbered year.
SELECT title, year
FROM movies
WHERE year % 2 = 0;

-- Q10: For each status, how many assets? Only show statuses with more than 1 asset.
-- HAVING filters groups after aggregation, WHERE filters rows before it.
SELECT
    status,
    COUNT(*) AS assets_per_status
FROM assets
GROUP BY status
HAVING COUNT(*) > 1;
