CREATE OR REPLACE TABLE Online_Retail.eligible_customers AS
  SELECT 
    f.fold_set, 
    f.fold_id, 
    v.CustomerID,
    COUNT(*) AS n_visits
  FROM `Online_Retail.visits` AS v
  JOIN `Online_Retail.folds` AS f
    ON DATE(v.InvoiceDate) BETWEEN f.obs_start AND f.obs_end
  GROUP BY 1, 2, 3
  HAVING COUNT(*) >= 2