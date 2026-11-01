-- 05 CASE WHEN, COALESCE, TRIM, LIKE, dates

-- Q1: CASE WHEN: label each asset's region (it labels every row, filters nothing).
SELECT
    asset_id,
    status,
    CASE
        WHEN region = 'DE' THEN 'EU'
        ELSE 'Non-EU'
    END AS region_flag
FROM assets;

-- Q2: COALESCE: total investment, treating NULL as 0.
-- For SUM it changes nothing, since NULLs are skipped anyway. For AVG it does:
-- values 100, NULL, 200 give 150 with AVG(x) but 100 with AVG(COALESCE(x, 0)).
SELECT SUM(COALESCE(investment_amount, 0)) AS total_investment_amount
FROM investments;

-- Q3: TRIM: clean asset names, only for assets with 'valve' in the name.
SELECT
    asset_id,
    TRIM(asset_name) AS clean_asset_name
FROM assets
WHERE asset_name LIKE '%valve%';

-- Q4: LIKE: workers whose first name has exactly 6 letters and ends with 'h'.
SELECT *
FROM worker
WHERE first_name LIKE '%h'
  AND LENGTH(first_name) = 6;

-- Q5: Case-insensitive search: files whose name starts with 'draft' and whose
-- contents include 'optimism'.
SELECT *
FROM google_file_store
WHERE LOWER(filename) LIKE 'draft%'
  AND LOWER(contents)  LIKE '%optimism%';

-- Q6: EXTRACT: employees in the Admin department who joined in April or later (any year).
SELECT COUNT(*) AS n_admins
FROM worker
WHERE LOWER(department) = 'admin'
  AND EXTRACT(MONTH FROM joining_date) >= 4;

-- Q7: Violations per year at one restaurant, in order of year.
SELECT
    EXTRACT(YEAR FROM inspection_date::DATE) AS inspection_year,   -- ::DATE makes sure it is a date
    COUNT(violation_id) AS n_violations
FROM sf_restaurant_health_violations
WHERE LOWER(business_name) = 'roxanne cafe'
GROUP BY inspection_year
ORDER BY inspection_year ASC;
