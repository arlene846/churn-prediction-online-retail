import pandas as pd
from google.cloud import bigquery

ONLINE_RETAIL_PATH = r"C:\Users\angua\Downloads\Online Retail.xlsx"
ONLINE_RETAIL_II_PATH = r"C:\Users\angua\Downloads\online+retail+ii\online_retail_II.xlsx"

online_retail_df = pd.read_excel(ONLINE_RETAIL_PATH)
online_retail_ii_df = pd.read_excel(ONLINE_RETAIL_II_PATH)

online_retail_ii_df = online_retail_ii_df.rename(columns={
    'Customer ID': 'CustomerID',
    'Invoice': 'InvoiceNo',
    'Price': 'UnitPrice',
})

retail_df = pd.concat([online_retail_df, online_retail_ii_df], ignore_index=True)

retail_df = pd.concat([online_retail_df, online_retail_ii_df], ignore_index=True)
print(f"Combined DataFrame shape before dropping duplicates: {retail_df.shape}")

    
retail_df.drop_duplicates(inplace=True)
print(f"Combined DataFrame shape after dropping duplicates: {retail_df.shape}")

retail_df["InvoiceNo"] = retail_df["InvoiceNo"].astype(str)
retail_df["StockCode"] = retail_df["StockCode"].astype(str)
retail_df["CustomerID"] = retail_df["CustomerID"].astype("Int64")
retail_df["Description"] = retail_df["Description"].astype("string")


 
# --- upload to BigQuery ---
client = bigquery.Client(project="online-retail-churn-prediction")
table_id = "online-retail-churn-prediction.Online_Retail.raw_transactions"

job_config = bigquery.LoadJobConfig(
    write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
)
job = client.load_table_from_dataframe(
    retail_df,
    table_id,
    job_config=job_config,
)
job.result()

print(f"print row numbers:{client.get_table(table_id).num_rows}")


