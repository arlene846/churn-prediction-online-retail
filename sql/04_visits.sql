CREATE OR REPLACE TABLE `Online_Retail.visits` AS
SELECT
  InvoiceNo,
  CustomerID,
  MIN(InvoiceDate) as InvoiceDate,
  SUM(Quantity) as Total_Quantity,
  SUM(Quantity * UnitPrice) as Spend,
  COUNT(Distinct StockCode) as ProductType
FROM `online-retail-churn-prediction.Online_Retail.clean_transactions_v2`
GROUP BY 1,2