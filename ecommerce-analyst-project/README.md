# Northwind Traders — End-to-End Sales & Operations Analytics

**An end-to-end data analytics project covering the full pipeline: Python (cleaning) → SQL (analysis) → Excel (ad hoc reporting) → Power BI (executive dashboard).**

## Business Problem

Northwind Traders is a wholesale food & beverage distribution company selling to 91 customers across 21 countries, through 9 sales employees, sourcing from 29 suppliers, and shipping via 3 carriers. Leadership wants a clear view of company-wide sales performance, which customers/products/regions drive revenue, how the sales team is performing, and where delivery operations are underperforming — to guide decisions on staffing, retention campaigns, and carrier contracts.

## Tools Used

| Stage | Tool |
|---|---|
| Data cleaning & transformation | Python (pandas) |
| Data modeling & business queries | SQL (SQLite) |
| Ad hoc analysis & pivot reporting | Excel |
| Executive dashboard | Power BI |

## Data Source

[Northwind sample database](https://github.com/neo4j-contrib/northwind-neo4j) — a public-domain relational dataset originally distributed with Microsoft Access, widely used for SQL/BI training. 9 relational tables: `customers`, `orders`, `order_details`, `products`, `employees`, `suppliers`, `categories`, `territories`, `employee_territories`. Data spans **July 1996 – May 1998**.

## Pipeline

```
Raw CSVs (9 relational tables)
        │
        ▼
Python/pandas — clean nulls, fix dtypes, resolve messy unescaped-comma
fields in address columns, engineer revenue & delivery-time columns
        │
        ▼
SQLite database — 7 loaded tables, 10 business queries using JOINs,
GROUP BY, RANK()/LAG() window functions, and CTEs
        │
        ├──▶ Excel — pivot tables & charts on exported query results
        │
        └──▶ Power BI — KPI cards, trend lines, country map, DAX measures
```

## Repo Structure

```
├── notebooks/
│   └── 01_northwind_end_to_end_analysis.ipynb   # full pipeline, runs in Google Colab
├── sql/
│   ├── schema.sql        # CREATE TABLE statements
│   └── analysis.sql      # 10 business queries
├── data_raw/             # original CSVs
├── data_clean/           # cleaned CSVs after Python processing
├── excel/                # exported query results + pivot workbook
├── powerbi_export/       # .pbix file + dashboard screenshot
└── README.md
```

## Key Insights

*(computed directly from the cleaned dataset — see `sql/analysis.sql` for the exact queries)*

1. **Total company revenue was $1,265,793** across the ~22-month period (Jul 1996–May 1998), with the **USA ($245.6K)** and **Germany ($230.3K)** as the top two revenue markets — together over 37% of total sales.
2. **One product, Côte de Blaye, generated $141.4K alone** — over 11% of total company revenue from a single SKU, indicating meaningful concentration risk if that supplier relationship or stock availability were disrupted.
3. **Beverages ($267.9K) and Dairy Products ($234.5K) are the top two categories**, together accounting for ~40% of revenue — useful for prioritizing supplier negotiations and inventory investment.
4. **Sales are highly concentrated in 3 employees**: Margaret Peacock ($232.9K), Janet Leverling ($202.8K), and Nancy Davolio ($192.1K) — the top 3 of 9 employees drive roughly half of all company revenue, which may warrant analyzing what makes them effective for onboarding/training the rest of the team.
5. **Only 1 of 91 customers (1.1%) placed just a single order**, suggesting strong overall repeat-purchase behavior — retention isn't the primary growth lever here; the RFM query (`sql/analysis.sql` Q5) can be used to find lower-frequency/lower-monetary customers worth targeted upsell campaigns instead.
6. **Late delivery rates are fairly consistent across all 3 shippers (3.6%–5.1%)**, so delivery delays don't appear to stem from a single underperforming carrier — worth investigating order-processing time internally instead of the shipping leg.

## How to Reproduce

1. Open `notebooks/01_northwind_end_to_end_analysis.ipynb` in [Google Colab](https://colab.research.google.com).
2. Upload the CSVs in `data_raw/` to your Google Drive under `ecommerce-analyst-project/data_raw/` (the notebook creates the rest of the folder structure automatically).
3. Run all cells — this cleans the data, loads it into SQLite, runs the 10 business queries, and exports CSVs for Excel.
4. Open the exported CSVs in Excel to build pivot tables (see `excel/` for reference).
5. Open Power BI Desktop, connect to `data_clean/` or the exported query CSVs, and build the dashboard (KPI cards, monthly trend, country breakdown, top products, plus YoY/running-total DAX measures).

## Author

*(Your name here)* — built as part of a data analyst portfolio to demonstrate an end-to-end analytics workflow across Python, SQL, Excel, and Power BI.
