{{ config(materialized='table') }}

SELECT
    review_id,
    order_id,
    product_id,
    user_id,
    rating,
    review_text,
    review_date
FROM {{ source('ecommerce', 'reviews') }}