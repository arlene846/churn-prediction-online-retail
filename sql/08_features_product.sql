CREATE OR REPLACE TABLE `Online_Retail.features_product` AS
SELECT
  e.fold_set,
  e.fold_id,
  e.CustomerID,
  COUNT(DISTINCT t.StockCode) AS ProductType
FROM `Online_Retail.eligible_customers` AS e
JOIN `Online_Retail.folds` AS f
  ON f.fold_set = e.fold_set
 AND f.fold_id  = e.fold_id
JOIN `Online_Retail.clean_transactions_v2` AS t
  ON t.CustomerID = e.CustomerID
 AND DATE(t.InvoiceDate) BETWEEN f.obs_start AND f.obs_end
GROUP BY e.fold_set, e.fold_id, e.CustomerID
