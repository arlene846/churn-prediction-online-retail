CREATE OR REPLACE TABLE Online_Retail.training_data AS
SELECT
  ft.*,
  l.label_visits,
  l.churned
FROM Online_Retail.features ft
JOIN Online_Retail.labels l 
USING (fold_set, fold_id, CustomerID)