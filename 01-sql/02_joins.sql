-- 02 Joins: INNER, LEFT, self join, orphan rows

-- Q1: INNER JOIN: movie titles with domestic and international sales.
SELECT
    m.Title,
    b.Domestic_sales,
    b.International_sales
FROM movies m
INNER JOIN boxoffice b
    ON m.ID = b.Movie_id;

-- Q2: Combined sales in millions of dollars, for every movie (LEFT JOIN keeps movies without box office data).
SELECT
    Movies.Title,
    (Boxoffice.Domestic_sales + Boxoffice.International_sales) / 1000000 AS combined_sales_millions
FROM Movies
LEFT JOIN Boxoffice
    ON Movies.Id = Boxoffice.Movie_id;

-- Q3: Ratings as a percentage.
SELECT
    Movies.Title,
    Boxoffice.Rating * 10 AS percentage_rating
FROM Movies
LEFT JOIN Boxoffice
    ON Movies.Id = Boxoffice.Movie_id;

-- Q4: LEFT JOIN: every building, with the roles of the employees who work there.
SELECT DISTINCT
    Buildings.Building_name,
    Employees.Role
FROM Buildings                      -- left table
LEFT JOIN Employees                 -- right table
    ON Buildings.Building_name = Employees.Building;

-- Q5: Buildings that have no employees (LEFT JOIN + IS NULL).
SELECT DISTINCT Building_name
FROM Buildings
LEFT JOIN Employees
    ON Buildings.Building_name = Employees.Building
WHERE Employees.Role IS NULL;

-- Q6: Orphans: maintenance logs whose asset_id does not exist in the assets table.
-- The table whose rows I want to keep goes on the left.
SELECT ml.*
FROM maintenance_logs ml
LEFT JOIN assets a
    ON a.asset_id = ml.asset_id
WHERE a.asset_id IS NULL;

-- Q7: Self join: find duplicate maintenance logs (same asset and same date, different log_id).
-- Using < instead of <> returns each pair once, not twice.
SELECT *
FROM maintenance_logs ml1
JOIN maintenance_logs ml2
    ON  ml1.asset_id = ml2.asset_id
    AND ml1.log_date = ml2.log_date
    AND ml1.log_id   < ml2.log_id;

-- Q8: Total sales per director, keeping directors without box office data.
SELECT
    Movies.Director,
    SUM(Boxoffice.Domestic_sales + Boxoffice.International_sales) AS total_sales
FROM Movies
LEFT JOIN Boxoffice
    ON Movies.Id = Boxoffice.Movie_id
GROUP BY Movies.Director;
