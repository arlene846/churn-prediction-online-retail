# Customer Churn Prediction — UCI Online Retail

A self-directed project predicting which e-commerce customers will churn,
built using the UCI Online Retail and Online Retail II transaction datasets.

## Data

- [UCI Online Retail](https://archive.ics.uci.edu/ml/datasets/online+retail) (Dec 2010 – Dec 2011)
- [UCI Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii) (Dec 2009 – Dec 2011)

Both datasets contain transaction-level records (invoice, customer ID, product, quantity, price)
for a UK-based online retailer. The two versions were combined and deduplicated to get a longer
history to work with.

## Approach

1. **Cleaning** — merged both dataset versions, removed rows with missing `CustomerID`, and
   removed canceled invoices.
2. **Feature engineering** — aggregated raw transactions to visit level (one row per
   invoice/customer), then removed "one-hit wonder" customers (a single visit isn't informative
   for churn modeling) and computed:
   - RFM metrics: Recency, Frequency, Monetary value
   - Average spend, average basket size, and unique product variety per customer
   - Purchase interval statistics (mean/std days between visits) and coefficient of variation
   - 30-day purchase velocity and category-spend dominance
3. **Time-based train/test folds** — built rolling observation / gap / label windows (3 folds
   each for train and test periods) rather than a random split, so churn labels reflect real
   future activity and features never leak information from the label window.
4. **Modeling** — trained and compared Logistic Regression, Random Forest, and XGBoost,
   evaluating each on ROC-AUC, F1, precision, and recall across folds.

## Data Pipeline (BigQuery)

The notebook's pandas feature engineering was rebuilt as a chain of BigQuery SQL tables, so every
step can be rerun, inspected, and validated on its own.

```
raw_transactions          1,033,035 rows    pipeline/load_raw_transactions.py, sql/00
  → clean_transactions      776,596 rows    sql/01-03  (missing IDs, cancellations, zero-price
                                                        and non-product codes removed; removal log)
  → visits                   36,594 rows    sql/04     (one row per invoice)
  → folds                         6 rows    sql/05     (3 train + 3 test time windows)
  → eligible_customers        8,866 rows    sql/06     (2+ visits inside the observation window)
  → features                  8,866 rows    sql/07-12  (RFM, product variety, interval CV,
                                                        30-day velocity, category dominance)
  → labels                    8,866 rows    sql/13     (churned = no visit in the label window)
  → training_data             8,866 rows    sql/14     (features + label, one row per customer per fold)
```

### Bugs found in the original notebook

1. **One-time-customer filter removed no one.** The mask compared the whole table to 1 instead of
   the visit-count column. Fixed by requiring 2+ visits *within each observation window*, which also
   avoids using future (label-window) visits.
2. **"ProductType" counted the wrong thing.** On visit-level data it counted distinct basket
   *sizes*, not distinct products. Fixed with `COUNT(DISTINCT StockCode)` on item-level data.
3. **Timestamp vs. date boundary.** Comparing visit timestamps to a midnight end date silently
   dropped every visit on the last day of a window: 190 visits (~1% of affected folds), and
   customers who returned only on that day could be mislabeled as churned. Fixed by comparing
   `DATE(InvoiceDate) BETWEEN start AND end`.

### Validation

- `training_data`: 8,866 rows = 8,866 unique (fold, customer) keys — no duplicates, nothing lost in joins.
- Churn rate: 21.8% train, 24.8% test. Label windows that include November catch holiday
  returners and show lower churn; test fold 1 (Jun–Sep 2011, no holiday) has the highest (29.9%).

## Tools

Python, pandas, NumPy, scikit-learn, XGBoost, matplotlib, seaborn, Google BigQuery (SQL)

## Status

Work in progress, built as a self-directed project to stay hands-on with data science during a
career break. All three models — Logistic Regression, Random Forest, and XGBoost — have been
trained and compared across folds. The feature and label pipeline now runs in BigQuery SQL
(`sql/`). Next step: building it with dbt and training the models from the BigQuery
`training_data` table.
