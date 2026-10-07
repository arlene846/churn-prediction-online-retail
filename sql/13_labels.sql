CREATE OR REPLACE TABLE `Online_Retail.labels` AS
  SELECT
    e.fold_set, 
    e.fold_id, 
    e.CustomerID, 
    COUNT(v.InvoiceNo) AS label_visits,
    CASE WHEN COUNT(v.InvoiceNo) = 0 THEN 1 ELSE 0 END AS churned
  FROM
    Online_Retail.eligible_customers e
  JOIN Online_Retail.folds f
  USING (fold_set,fold_id)
  LEFT JOIN `Online_Retail.visits` v
    ON  v.CustomerID = e.CustomerID
    AND DATE(v.InvoiceDate) BETWEEN f.label_start AND f.label_end
  GROUP BY 1,2,3