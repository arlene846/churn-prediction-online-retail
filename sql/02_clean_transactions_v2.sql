SELECT COUNT(*)
FROM `Online_Retail.clean_transactions`
WHERE UnitPrice <= 0
  AND StockCode IN ('POST', 'M', 'C2', 'ADJUST', 'BANK CHARGES', 'DOT', 'TEST001', 'D', 'ADJUST2', 'TEST002')