import snowflake.snowpark.functions as F

def model(dbt, session):
    # 1. Configure the model
    dbt.config(
        materialized = "incremental",
        unique_key = "ORDER_ID"  # Prevents duplicates on updates
    )

    # 2. Reference the source table
    # Based on your image, the source is RAW_DB.ORDERS
    df = dbt.source("ecommerce", "orders")

    # 3. Apply incremental logic
    if dbt.is_incremental:
        # Get the max date already in the target table
        # dbt.this refers to the current model's table in Snowflake
        max_date_query = f"select max(ORDER_DATE) from {dbt.this}"
        max_date = session.sql(max_date_query).collect()[0][0]

        if max_date:
            # Filter for rows newer than the current max date
            df = df.filter(F.col("ORDER_DATE") > max_date)

    return df