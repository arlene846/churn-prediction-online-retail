select
  count(*) as total_rows,
  sum(case when CustomerID is not null then 1 else 0 end) as total_CID,
  sum(case when CustomerID is not null and NOT STARTS_WITH(InvoiceNo, 'C') then 1 else 0 end) as total_CID_NonCancelled,
  count(distinct CustomerID) as customer_cnt,
  MIN(InvoiceDate) as first_Invoice,
  Max(InvoiceDate) as last_Invoice
from `Online_Retail.raw_transactions`