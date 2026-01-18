{{
    config(
        materialized='incremental',
        unique_key='ORDER_ID',
        on_schema_change='fail'
    )
}}

SELECT
    ORDER_ID,
    USER_ID,
    ORDER_DATE,
    ORDER_STATUS,
    TOTAL_AMOUNT,
    CURRENT_TIMESTAMP() as dbt_updated_at
FROM {{ source('ecommerce', 'orders') }}

{% if is_incremental() %}

  -- This filter only runs on the 2nd run onwards
  -- It tells Snowflake: "Only give me rows newer than the ones I already have"
  WHERE ORDER_DATE > (SELECT MAX(ORDER_DATE) FROM {{ this }})

{% endif %}