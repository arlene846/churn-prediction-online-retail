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

## Tools

Python, pandas, NumPy, scikit-learn, XGBoost, matplotlib, seaborn

## Status

Work in progress, built as a self-directed project to stay hands-on with data science during a
career break. All three models — Logistic Regression, Random Forest, and XGBoost — have been
trained and compared across folds. Next step: turning this into an automated, end-to-end pipeline
that can run on new data without manual intervention. 
