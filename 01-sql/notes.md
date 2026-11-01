# SQL notes

My notes from practising SQL, based on the SQLBolt lessons and a set of interview-style practice questions. Practice queries are in the `practice/` folder, and my interview answers are in `interview.md`.

## The basics

**SQL** (Structured Query Language) is used to query, change and transform data in a **relational database**: a collection of related, two-dimensional tables.

```sql
SELECT column1, column2
FROM table_name
WHERE condition1
  AND condition2   -- or OR
ORDER BY column1 ASC;   -- or DESC
```

`SELECT DISTINCT` removes rows that repeat the same value.

## Operators

| For numbers | Meaning | Example |
|---|---|---|
| `=`, `!=`, `<`, `<=`, `>`, `>=` | Compare | `col != 4` |
| `BETWEEN ... AND ...` | In a range (inclusive) | `col BETWEEN 1.5 AND 10.5` |
| `IN (...)` / `NOT IN (...)` | In (or not in) a list | `col IN (2, 4, 6)` |

| For text | Meaning | Example |
|---|---|---|
| `=`, `!=` or `<>` | Exact comparison | `col = 'abc'` |
| `LIKE` / `NOT LIKE` | Pattern match | `col LIKE '%AT%'` |
| `%` | Any number of characters (with `LIKE`) | `'%AT%'` matches AT, ATTIC, CAT |
| `_` | Exactly one character (with `LIKE`) | `'AN_'` matches AND, not AN |
| `IN (...)` | In a list | `col IN ('A', 'B')` |

Whether `LIKE` ignores upper and lower case depends on the database. In SQLite and MySQL it usually does. In Snowflake, as far as I know, `LIKE` is case-sensitive and `ILIKE` is the case-insensitive version (to be tested). The safe habit is `LOWER(col) LIKE '...'`.

## Aggregates and GROUP BY

| Function | What it does |
|---|---|
| `COUNT(*)` | Counts rows in the group |
| `COUNT(column)` | Counts rows where that column is not NULL |
| `MIN(column)`, `MAX(column)` | Smallest and largest value |
| `AVG(column)` | Average (NULLs are skipped) |
| `SUM(column)` | Total |

- Rule: every column in `SELECT` that is **not** inside an aggregate function must appear in `GROUP BY`.
- An aggregate with no other columns (for example `SELECT SUM(x) FROM t`) needs no `GROUP BY`.
- `WHERE` filters rows **before** grouping. `HAVING` filters groups **after** aggregation, so it is the place for conditions like `COUNT(*) > 1`.

## LIMIT and OFFSET

`LIMIT n` returns only n rows. `OFFSET m` skips the first m rows, for example `LIMIT 5 OFFSET 5` gives rows 6 to 10.

## Joins

- **INNER JOIN**: only rows that match in both tables.
- **LEFT JOIN**: all rows from the left table, plus matches from the right (NULL where there is none).
- **RIGHT JOIN**: the same, keeping all rows from the right table.
- **FULL JOIN**: all rows from both tables.
- **Self join**: a table joined to itself, for example to find duplicate records that have different IDs.
- **Orphans**: `LEFT JOIN ... WHERE right_table.key IS NULL` finds rows in the left table that have no match on the right.

## NULLs

`NULL` means "unknown or missing", not zero. Test it with `IS NULL` or `IS NOT NULL`, never `= NULL`. Aggregate functions skip NULLs. Use NULL for truly missing data, and a default value (0 or an empty string) only when it will not distort the analysis later, for example an average.

## Subqueries and CTEs

A **subquery** is a query inside another query, for example `WHERE salary = (SELECT MAX(salary) ...)`.

A **CTE** (`WITH name AS (...)`) gives a subquery a name so the main query is easier to read. It can be used several times and chained.

## Window functions

A window function calculates over a "window" of related rows **without collapsing them** into one row, which is what `GROUP BY` does.

```sql
function() OVER (PARTITION BY group_column ORDER BY order_column)
```

- `PARTITION BY` splits the rows into groups.
- `ORDER BY` sets the order inside each group.
- Frame clauses (`ROWS BETWEEN ...`) limit which rows are in the window.

Typical uses: `ROW_NUMBER()` to pick the latest record per entity, and `AVG(...) OVER (PARTITION BY ...)` to compare each row with its group average.

## CASE WHEN, COALESCE, TRIM

```sql
CASE
  WHEN condition THEN result
  WHEN another_condition THEN another_result
  ELSE fallback_result
END AS new_column
```

`CASE` labels every row and filters nothing out, so you see the full picture, not only the bad rows.

`COALESCE(column, fallback)` replaces NULL with a fallback value. For `SUM()` it makes no difference, because NULLs are skipped anyway. It matters for `AVG()`: with values 100, NULL and 200, `AVG` gives (100 + 200) / 2 = 150, but with `COALESCE(x, 0)` it gives (100 + 0 + 200) / 3 = 100.

`TRIM(text)` removes spaces at the start and end of text.

## Dates

`EXTRACT(YEAR FROM date_column)` and `EXTRACT(MONTH FROM date_column)` pull parts out of a date. `date_column::DATE` converts text to a date in PostgreSQL and Snowflake.

## Changing data

```sql
INSERT INTO table_name VALUES (...);

UPDATE table_name
SET column = 'new value'
WHERE id = 2;

DELETE FROM table_name
WHERE condition;
```

Before an `UPDATE` or `DELETE`, run the same `WHERE` in a `SELECT` first to check which rows will change. Text values use single quotes. Double quotes are for column and table names in most databases.

## Creating and changing tables

```sql
CREATE TABLE movies_info (
  name TEXT,
  version FLOAT,
  download_count INTEGER
);

ALTER TABLE movies_info ADD COLUMN language TEXT DEFAULT 'English';

DROP TABLE IF EXISTS movies_info;
```

| Data type | Use |
|---|---|
| `INTEGER`, `BOOLEAN` | Whole numbers, true/false |
| `FLOAT`, `DOUBLE`, `REAL` | Decimal numbers |
| `CHAR`, `VARCHAR`, `TEXT` | Text |
| `DATE`, `DATETIME` | Dates and timestamps (time zones can be tricky) |
| `BLOB` | Binary data |

| Constraint | Meaning |
|---|---|
| `PRIMARY KEY` | Unique value that identifies each row |
| `AUTOINCREMENT` | Number fills in automatically (not in every database) |
| `UNIQUE` | No repeated values in this column |
| `NOT NULL` | The value cannot be NULL |
| `CHECK (expression)` | The value must pass a test, such as being positive |
| `FOREIGN KEY` | The value must exist in a column of another table |

## Order of execution

The order I write a query is not the order the database runs it:

1. `FROM` and `JOIN`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT` (and `DISTINCT`)
6. `ORDER BY`
7. `LIMIT` and `OFFSET`

This is why `WHERE` cannot use an aggregate function, and why `HAVING` can.
