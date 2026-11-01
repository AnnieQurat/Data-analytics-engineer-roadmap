# ETL with Python and pandas: notes

High amount of data analyst's Python work is **ETL** (Extract, Transform, Load) and data cleaning, not machine learning.

## Starting my workspace

1. Open Anaconda Prompt and activate my environment: `conda activate analysis`
2. Start Jupyter: `jupyter lab` (or `python -m jupyterlab`)

## pandas in one paragraph

pandas is Python's main library for tables. Its core object is the **DataFrame**: rows and columns, like a spreadsheet or a SQL table, but something I can change with code. If I load a CSV of sales data, each row might be one order and the columns date, product, quantity and price.

## Extract: read the data

```python
import pandas as pd
import numpy as np

df = pd.read_csv("sales_data.csv")   # read the CSV into a DataFrame

df.head()          # first 5 rows (df.head(3) for 3 rows)
df.tail(3)         # last 3 rows
df.dtypes          # data type of each column
df.columns         # column names
df.describe()      # quick statistical summary
print(df.shape)    # (rows, columns)
df.T               # transpose
df.sort_values(by="Sales")   # sort by a column
```

## Transform: clean and reshape

```python
df.duplicated().sum()                    # number of duplicate rows
df[df.duplicated(keep=False)]            # show all duplicates side by side
df.isna().sum()                          # missing values per column

df["Customer ID"] = df["Customer ID"].fillna("Unknown")   # keep the rows for later customer analysis
df_clean = df.dropna()                   # drop rows with any missing value
df["price"] = df["price"].fillna(0)      # only if 0 is a sensible default
df["name"] = df["name"].replace("", np.nan)   # treat empty strings as missing

df["revenue"] = df["quantity"] * df["price"]  # new column, like a calculated field in Excel
high_value = df[df["revenue"] > 100]          # filter rows (like SQL WHERE)
monthly_revenue = df.groupby("month")["revenue"].sum()   # group and add up (like SQL GROUP BY)
```

## Load: write the result

```python
monthly_revenue.to_csv("monthly_summary.csv")
```

## A cleaning checklist for the Online Retail dataset

1. Handle the missing values (for example missing customer IDs) and decide why.
2. Check for duplicates.
3. Fix data types (dates as dates, numbers as numbers).
4. Find the cancellations: an invoice number starting with "C" marks a cancelled order, and the quantity is negative. Either filter these out for revenue analysis or study them separately as returns.
5. Create a `TotalPrice` column (quantity times unit price). Most later questions (revenue by country, month, product, customer) build on it.
6. Analyse: top products by revenue, monthly trend, revenue by country, top customers.
7. Optional: RFM segmentation (Recency, Frequency, Monetary value) to group customers.

## Concepts

**Real and nominal values** (economics): a *nominal* value is the raw number in current money. A *real* value is adjusted for inflation, so it can be compared across years. Both can be stored as decimals.

**Nominal data** (statistics) is something different: categories without an order, such as country names or jersey numbers. These are labels, so it makes no sense to average them.

## Translating pandas into SQL

| pandas | SQL |
|---|---|
| `df[df["revenue"] > 100]` | `WHERE revenue > 100` |
| `df.groupby("month")["revenue"].sum()` | `SELECT month, SUM(revenue) FROM t GROUP BY month` |
| `df.sort_values("revenue")` | `ORDER BY revenue` |
| `df.isna().sum()` | `COUNT(CASE WHEN col IS NULL THEN 1 END)` per column |
