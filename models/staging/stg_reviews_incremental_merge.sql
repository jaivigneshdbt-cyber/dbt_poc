-- models/staging/stg_reviews.sql (or stg_reviews_incremental_merge.sql)

{{
    config(
        materialized='incremental',
        unique_key='review_id',
        incremental_strategy='merge',
        partition_by={
            "field": "review_date",
            "data_type": "date",
            "granularity": "day"
        }
    )
}}

SELECT
    review_id,
    order_id,
    product_id,
    user_id,
    rating,
    review_text,
    review_date
FROM
    {{ source('ecommerce', 'reviews') }}

{% if is_incremental() %}
    WHERE review_date > (SELECT MAX(review_date) FROM {{ this }})
{% endif %}