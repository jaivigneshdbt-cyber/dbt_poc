{{ config(materialized='table') }}

SELECT
    ORDER_ID,
    USER_ID,
    ORDER_DATE,
    ORDER_STATUS,
    TOTAL_AMOUNT,
    -- Basic cleaning: Ensure status is lowercase for consistency
    LOWER(ORDER_STATUS) as clean_status,
    CURRENT_TIMESTAMP() as loaded_at
FROM {{ source('ecommerce', 'orders') }}