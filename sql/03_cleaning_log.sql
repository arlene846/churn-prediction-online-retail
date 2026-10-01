select 
  count(*) as row_before,
  sum(case when UnitPrice <= 0 then 1 else 0 end) as removed_zero_price,
  sum(case when StockCode IN ('POST', 'M', 'C2', 'ADJUST', 'BANK CHARGES', 'DOT', 'TEST001', 'D', 'ADJUST2', 'TEST002') then 1 else 0 end) as removed_non_product,
  sum(case when UnitPrice <= 0 and StockCode IN ('POST', 'M', 'C2', 'ADJUST', 'BANK CHARGES', 'DOT', 'TEST001', 'D', 'ADJUST2', 'TEST002') then 1 else 0 end) as removed_both,
  sum(case when UnitPrice <= 0 or StockCode IN ('POST', 'M', 'C2', 'ADJUST', 'BANK CHARGES', 'DOT', 'TEST001', 'D', 'ADJUST2', 'TEST002') then 0 else 1 end) as pass_both
from `online-retail-churn-prediction.Online_Retail.clean_transactions`