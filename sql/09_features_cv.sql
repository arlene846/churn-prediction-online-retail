CREATE OR REPLACE TABLE `Online_Retail.features_cv` AS
WITH visits_in_window AS (
  SELECT
    e.fold_set,
    e.fold_id,
    e.CustomerID,
    v.InvoiceDate
  FROM `Online_Retail.eligible_customers` AS e
  JOIN `Online_Retail.folds` AS f
    ON f.fold_set = e.fold_set
   AND f.fold_id  = e.fold_id
  JOIN `Online_Retail.visits` AS v
    ON v.CustomerID = e.CustomerID
   AND DATE(v.InvoiceDate) BETWEEN f.obs_start AND f.obs_end
),
gaps AS (
  SELECT
    fold_set,
    fold_id,
    CustomerID,
    -- whole days since the previous visit (same as pandas .diff().dt.days)
    DIV(DATETIME_DIFF(
          InvoiceDate,
          LAG(InvoiceDate) OVER (PARTITION BY fold_set, fold_id, CustomerID ORDER BY InvoiceDate),
          SECOND), 86400) AS gap_days
  FROM visits_in_window
)
SELECT
  fold_set,
  fold_id,
  CustomerID,
  COUNT(gap_days)                                         AS n_gaps,
  ROUND(AVG(gap_days), 2)                                 AS mean_interval,
  ROUND(STDDEV_SAMP(gap_days), 2)                         AS std_interval,
  -- NULL when undefined: only 1 gap (no std dev) or all visits on the same day (mean 0)
  ROUND(SAFE_DIVIDE(STDDEV_SAMP(gap_days), AVG(gap_days)), 3) AS CV
FROM gaps
GROUP BY fold_set, fold_id, CustomerID
