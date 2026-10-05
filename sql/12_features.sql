CREATE OR REPLACE TABLE `Online_Retail.features` AS
SELECT
  r.fold_set,
  r.fold_id,
  r.CustomerID,
  -- RFM + basket (07)
  r.Recency,
  r.Frequency,
  r.Monetary,
  r.AverageSpend,
  r.BasketSize,
  -- product variety (08, Bug 2 fixed)
  p.ProductType,
  -- purchase rhythm (09); CV is NULL when undefined (1 gap or mean gap 0)
  c.n_gaps,
  c.mean_interval,
  c.std_interval,
  c.CV,
  -- recent activity (10)
  vel.Frequency_30,
  vel.Velocity_Ratio,
  -- spend concentration (11)
  d.TopProductShare
FROM `Online_Retail.features_rfm` AS r
LEFT JOIN `Online_Retail.features_product` AS p
  USING (fold_set, fold_id, CustomerID)
LEFT JOIN `Online_Retail.features_cv` AS c
  USING (fold_set, fold_id, CustomerID)
LEFT JOIN `Online_Retail.features_velocity` AS vel
  USING (fold_set, fold_id, CustomerID)
LEFT JOIN `Online_Retail.features_dominance` AS d
  USING (fold_set, fold_id, CustomerID)
