-- 04 Window functions: ROW_NUMBER and AVG ... OVER

-- Q1: The latest maintenance log for every asset.
-- ROW_NUMBER numbers each asset's logs from newest to oldest. Row 1 is the latest.
WITH ranked_logs AS (
    SELECT
        log_id,
        asset_id,
        log_date,
        status,
        ROW_NUMBER() OVER (PARTITION BY asset_id ORDER BY log_date DESC) AS row_num
    FROM maintenance_logs
)
SELECT *
FROM ranked_logs
WHERE row_num = 1;

-- Q2: Current salary per employee when old records are still in the table.
-- Assume salary never decreases, so the highest salary is the current one.
SELECT
    id,
    first_name,
    last_name,
    department_id,
    salary
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY salary DESC, department_id DESC) AS rn
    FROM ms_employee_salary
) s
WHERE rn = 1
ORDER BY id ASC;

-- Q3: Compare each employee's salary with the average of their department.
-- Solution A: window function (keeps every row, adds the average next to it).
SELECT
    department,
    first_name,
    salary,
    avg_salary_of_department
FROM (
    SELECT
        *,
        AVG(salary) OVER (PARTITION BY department) AS avg_salary_of_department
    FROM employee
) s;

-- Solution B: CTE with GROUP BY, then join back.
WITH dept_avg AS (
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employee
    GROUP BY department
)
SELECT
    e.department,
    e.first_name,
    e.salary,
    d.avg_salary
FROM employee e
JOIN dept_avg d
    ON e.department = d.department
ORDER BY e.department;

-- Q4: For each asset that exists in assets, return only its most recent log.
-- Assets with no logs at all are left out, so INNER JOIN is the right join here.
WITH asset_logs AS (
    SELECT
        log_id,
        asset_id,
        log_date,
        status,
        ROW_NUMBER() OVER (PARTITION BY asset_id ORDER BY log_date DESC) AS row_num
    FROM maintenance_logs
)
SELECT
    a.asset_id,
    a.asset_name,
    l.log_id,
    l.log_date,
    l.status
FROM assets a
JOIN asset_logs l
    ON a.asset_id = l.asset_id
WHERE l.row_num = 1
ORDER BY a.asset_id;
