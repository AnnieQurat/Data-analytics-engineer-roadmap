-- 03 Subqueries and CTEs

-- Q1: Subquery: job titles of the highest-paid workers, only counting workers
-- who have a matching record in the title table.
SELECT t.worker_title
FROM worker w
INNER JOIN title t
    ON w.worker_id = t.worker_ref_id
WHERE w.salary = (
    SELECT MAX(w2.salary)
    FROM worker w2
    INNER JOIN title t2
        ON w2.worker_id = t2.worker_ref_id
    WHERE t2.worker_title IS NOT NULL
)
ORDER BY t.worker_title ASC;

-- Q2: CTE: the most profitable company in the financial sector, with its continent.
WITH max_profits AS (
    SELECT MAX(profits) AS max_profit
    FROM forbes_global_2010_2014
    WHERE sector = 'Financials'
)
SELECT
    company,
    continent
FROM forbes_global_2010_2014
JOIN max_profits
    ON forbes_global_2010_2014.profits = max_profits.max_profit
WHERE sector = 'Financials';
