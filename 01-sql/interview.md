# SQL interview questions

Questions I practise answering out loud in about a minute, with the answer I would give.

## Duplicates and data quality

**How would you find duplicate records in a table?**
I would `GROUP BY` the columns that should be unique, then use `HAVING COUNT(*) > 1` to show every group with more than one row.

**Two rows look identical but have different IDs. How do you identify them as duplicates?**
The same way, but I group by the fields that actually define uniqueness (for example name, date, region), not by the ID, because the ID is exactly what hides the duplicate.

**How would you check that every record in table A has a valid matching record in table B?**
I would `LEFT JOIN` A to B and filter `WHERE B.key IS NULL`. That isolates every row in A with no match in B.

**How do you find records that point to something that no longer exists, or was never created?**
The same pattern: `LEFT JOIN` plus `IS NULL` on the other table's key. It is the standard way to catch broken lineage.

**How would you check for missing or incomplete data across a table?**
Count the NULLs per column:

```sql
SELECT
    COUNT(CASE WHEN name  IS NULL THEN 1 END) AS name_nulls,
    COUNT(CASE WHEN age   IS NULL THEN 1 END) AS age_nulls,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS email_nulls
FROM users;
```

**How would you check that data follows a business rule, for example that an approved record always has a positive amount?**
I would use `CASE WHEN` to flag rows that break the rule:

```sql
CASE WHEN status = 'Approved' AND amount <= 0 THEN 'Violation' ELSE 'OK' END
```

That labels every row, so I can audit the full picture and not only filter out the bad rows.

## Latest record and source of truth

**If a record has been updated several times, how do you pull only the most recent version?**
I would use `ROW_NUMBER() OVER (PARTITION BY entity_id ORDER BY date DESC)` inside a CTE, then filter the outer query to `row_num = 1`.

**How would you find the single source of truth when there are conflicting or duplicate updates over time?**
The same window function: partition by the entity, order by the most recent timestamp, and row 1 in each partition is the current truth.

## WHERE, HAVING and NULLs

**What is the difference between WHERE and HAVING?**
`WHERE` filters individual rows before grouping. `HAVING` filters groups after aggregation, so it is the only place where I can filter on something like `COUNT(*)`.

**Why would this query fail?** (an aggregate in `WHERE`, or a column in `SELECT` that is not grouped)
Either an aggregate function is used in `WHERE`, which runs before aggregation exists, or a column is selected that is neither in the `GROUP BY` nor inside an aggregate, so SQL cannot reduce it to one value per group.

**How do NULL values affect an average or a count, and how do you handle that?**
Aggregate functions skip NULLs. They are not treated as zero, they are left out. `COUNT(*)` counts all rows, while `COUNT(column)` counts only the non-NULL values. For an average this matters: with values 100, NULL and 200, `AVG` gives 150, but treating the NULL as 0 gives 100. So I decide based on what the NULL means. If missing means zero, I use `COALESCE(column, 0)`. If it means unknown, I leave it out and report how many values are missing.

## Cleaning and first steps

**Walk me through how you would clean a messy dataset.**
I follow a structured sequence. First I understand the schema. Then I profile the data: ranges, NULLs and duplicates. Then I standardise formatting such as whitespace and casing, clean based on what I found, and finally validate the result before it is used downstream.

**If I gave you a table right now, what is the first thing you would check?**
Row counts, NULL counts per column, and a quick check for duplicate keys. That gives me a fast sense of how trustworthy the table is. To see the columns and types I would run `DESCRIBE my_table;` (MySQL and Snowflake; in PostgreSQL I would look at the information schema).
