{{ config(
    materialized='table'
) }}

SELECT
    order_item_id,
    order_id,
    product_id,
    user_id,
    item_price,
    item_total,
    quantity
FROM {{ source('ecommerce', 'order_items') }}
