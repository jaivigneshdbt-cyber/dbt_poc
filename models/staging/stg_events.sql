{{ config(
    materialized='table'
) }}

SELECT
    EVENT_ID,
    EVENT_TIMESTAMP,
    EVENT_TYPE,
    PRODUCT_ID,
    USER_ID
FROM {{ source('ecommerce', 'events') }}