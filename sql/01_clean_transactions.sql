CREATE OR REPLACE TABLE `Online_Retail.clean_transactions` AS
SELECT
  *
FROM `Online_Retail.raw_transactions`
WHERE
  (CustomerID is not null) AND (Not STARTS_WITH(InvoiceNo,'C'))