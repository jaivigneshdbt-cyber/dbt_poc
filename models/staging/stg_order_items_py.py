import snowflake.snowpark.functions as F

def model(dbt, session):
    # Set materialization to table for full load
    dbt.config(materialized="table")

    # Reference the source data
    df = dbt.source("ecommerce", "order_items")

    # You can perform logic here, or just return the dataframe for a straight load
    final_df = df.select(
        "ORDER_ITEM_ID",
        "ORDER_ID",
        "PRODUCT_ID",
        "USER_ID",
        "ITEM_PRICE",
        "ITEM_TOTAL",
        "QUANTITY"
    )
    final_df = final_df.withColumn("timestamp_col", F.current_timestamp())

    return final_df