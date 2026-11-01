-- 06 Changing data and tables: INSERT, UPDATE, DELETE, CREATE, ALTER, DROP
-- Tip: run the WHERE as a SELECT first to see which rows will change.

-- Add a box office row for movie 4.
INSERT INTO Boxoffice (Movie_id, Rating, Domestic_sales, International_sales)
VALUES (4, 8.7, 340000000, 270000000);

-- Update one value.
UPDATE movies
SET Director = 'John Lasseter'
WHERE Id = 2;

-- Update several values at once.
UPDATE movies
SET title = 'Toy Story 3',
    director = 'Lee Unkrich'
WHERE id = 11;

-- Delete rows.
DELETE FROM movies
WHERE year < 2005;

DELETE FROM movies
WHERE director = 'Andrew Stanton';

-- Create a table.
CREATE TABLE movies_info (
    name TEXT,
    version FLOAT,
    download_count INTEGER
);

-- Add a column with a default value.
ALTER TABLE Movies
ADD COLUMN Language TEXT DEFAULT 'English';

-- Remove a table.
DROP TABLE IF EXISTS movies;
