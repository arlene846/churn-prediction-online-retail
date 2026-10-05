CREATE OR REPLACE TABLE `Online_Retail.features_rfm` AS
SELECT
  f.fold_set,
  f.fold_id,
  v.CustomerID,
  DATE_DIFF(f.obs_end, MAX(DATE(v.InvoiceDate)), DAY) AS Recency,
  COUNT(*)                                            AS Frequency,
  ROUND(SUM(v.Spend), 2)                              AS Monetary,
  ROUND(AVG(v.Spend), 2)                              AS AverageSpend,
  ROUND(AVG(v.Total_Quantity), 2)                     AS BasketSize
FROM `Online_Retail.visits` AS v
JOIN `Online_Retail.folds` AS f
  ON DATE(v.InvoiceDate) BETWEEN f.obs_start AND f.obs_end
GROUP BY f.fold_set, f.fold_id, f.obs_end, v.CustomerID
HAVING COUNT(*) >= 2
