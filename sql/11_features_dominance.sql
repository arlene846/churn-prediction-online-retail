CREATE OR REPLACE TABLE `Online_Retail.features_dominance` AS
WITH product_spend AS (
  -- spend per customer per product (StockCode) inside each fold's observation window
  SELECT
    e.fold_set,
    e.fold_id,
    e.CustomerID,
    t.StockCode,
    SUM(t.Quantity * t.UnitPrice) AS spend
  FROM `Online_Retail.eligible_customers` AS e
  JOIN `Online_Retail.folds` AS f
    ON f.fold_set = e.fold_set
   AND f.fold_id  = e.fold_id
  JOIN `Online_Retail.clean_transactions_v2` AS t
    ON t.CustomerID = e.CustomerID
   AND DATE(t.InvoiceDate) BETWEEN f.obs_start AND f.obs_end
  GROUP BY 1, 2, 3, 4
)
SELECT
  fold_set,
  fold_id,
  CustomerID,
  -- share of total spend that went to the customer's single biggest product
  ROUND(SAFE_DIVIDE(MAX(spend), SUM(spend)), 3) AS TopProductShare
FROM product_spend
GROUP BY fold_set, fold_id, CustomerID
