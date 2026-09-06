# Northwind Sales & Operations Analytics

End-to-end analytics project on Northwind Traders, a wholesale food & beverage distributor. I wanted a project that touched the full stack an analyst actually uses day to day — not just one tool in isolation — so this goes from raw messy CSVs all the way to a Power BI dashboard.

## The business question

Northwind sells to 91 customers in 21 countries, through 9 sales reps, sourcing from 29 suppliers, shipped by 3 carriers. If I were handed this data as a new analyst, the first thing leadership would want to know is: where's the revenue actually coming from, who's driving it, and where are the weak points (slow delivery, one-time customers, over-reliance on a single product)?

## Tools

- **Python (pandas)** — cleaning and transforming the raw data
- **SQL (SQLite)** — the actual analysis, joins, and window functions
- **Excel** — quick pivot-table reporting on top of the SQL output
- **Power BI** — the dashboard a manager would actually look at

## Data

Used the [Northwind sample database](https://github.com/neo4j-contrib/northwind-neo4j) — the classic Microsoft Access teaching dataset, now available as plain CSVs. 9 relational tables (customers, orders, order line items, products, employees, suppliers, categories, territories). Covers July 1996 through May 1998.

Worth noting: the raw CSVs weren't actually clean. Several address fields have unescaped commas in them (e.g. "24, place Kléber") which breaks a straightforward `pd.read_csv()` — had to write a small fix to re-merge the split fields before anything else would load properly. That's in the notebook.

## What's in here

```
notebooks/    -> the full pipeline notebook (built for Google Colab)
sql/          -> schema.sql and analysis.sql
data_raw/     -> original CSVs
data_clean/   -> cleaned versions after the pandas step
excel/        -> exported query results + the pivot workbooks
northwind.db  -> the SQLite database itself
```

## Pipeline, roughly

1. Load the 9 CSVs, fix the comma issue, handle nulls, convert dates, engineer a couple of derived columns (line revenue, delivery time in days).
2. Load into SQLite and write 10 queries against it — monthly revenue, top products, revenue by country, employee performance (using `RANK()`), an RFM cut for customers, delivery lateness by shipper, category revenue, month-over-month growth (`LAG()`), one-time buyers, and top suppliers.
3. Export a few of those query results and build pivot tables + conditional formatting in Excel.
4. Pull the same CSVs into Power BI for a one-page dashboard: total revenue card, monthly trend line, revenue-by-country bar chart, top products table.

## What actually came out of it

Total revenue across the ~22 months in the data was **$1.27M**. The USA and Germany are the two biggest markets ($245.6K and $230.3K), which together is over a third of everything.

One thing that stood out: a single product, **Côte de Blaye**, brought in $141.4K on its own — that's more than 11% of total revenue sitting in one SKU. If I were advising the business, that's a concentration risk worth flagging, not just a "top product" to celebrate.

Sales are also pretty concentrated on the people side — the top 3 of 9 employees (Margaret Peacock, Janet Leverling, Nancy Davolio) account for roughly half of all revenue. Might be worth digging into what they're doing differently before assuming it's random.

Retention isn't really the problem here — only 1 of 91 customers placed a single order and never came back, so almost everyone is a repeat buyer. The RFM query is more useful for finding the customers who order rarely or spend little, rather than flagging churn.

Delivery lateness sits between 3.6% and 5.1% across all three shippers, close enough that I wouldn't blame any one carrier — if delivery speed is a concern, the bottleneck is more likely internal order processing than the shipping leg itself.

## Running it yourself

Open the notebook in Colab, upload the `data_raw` CSVs to your Drive in the same folder structure, run all cells. It'll clean everything, build the SQLite db, run the queries, and drop CSVs into `excel/` for you to build on. Power BI can either read those CSVs directly or connect to `northwind.db`.
