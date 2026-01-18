{{ config(
    materialized='table'
) }}

SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    BRAND,
    CATEGORY,
    PRICE,
    RATING
FROM {{ source('ecommerce', 'products') }}