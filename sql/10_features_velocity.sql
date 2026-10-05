CREATE OR REPLACE TABLE `Online_Retail.features_velocity` AS
SELECT
  r.fold_set,
  r.fold_id,
  r.CustomerID,
  COUNT(v.InvoiceNo)                            AS Frequency_30,
  ROUND(COUNT(v.InvoiceNo) / r.Frequency, 3)    AS Velocity_Ratio
FROM `Online_Retail.features_rfm` AS r
JOIN `Online_Retail.folds` AS f
  ON f.fold_set = r.fold_set
 AND f.fold_id  = r.fold_id
-- LEFT JOIN keeps customers with no visits in the last 30 days (Frequency_30 = 0)
LEFT JOIN `Online_Retail.visits` AS v
  ON v.CustomerID = r.CustomerID
 AND DATE(v.InvoiceDate) BETWEEN DATE_SUB(f.obs_end, INTERVAL 30 DAY) AND f.obs_end
GROUP BY r.fold_set, r.fold_id, r.CustomerID, r.Frequency
