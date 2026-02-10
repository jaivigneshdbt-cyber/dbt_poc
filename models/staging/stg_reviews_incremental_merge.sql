-- models/staging/stg_reviews.sql

{{
    config(
        materialized='incremental',
        unique_key='review_id',  -- Assuming review_id is unique per review
        incremental_strategy='merge', -- This is the default for BigQuery incremental, but good to be explicit
        -- Optional: Add partitioning for better BigQuery performance
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
    -- This WHERE clause ensures only new or updated records from the source
    -- are considered during an incremental run.
    -- We're comparing the review_date in the source to the maximum review_date
    -- already present in the target incremental table.
    WHERE review_date > (SELECT MAX(review_date) FROM {{ this }})
{% endif %}