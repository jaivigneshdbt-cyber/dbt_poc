{{ config(
    materialized='incremental',
    incremental_strategy='insert_overwrite',
    partition_by={
      "field": "review_date",
      "data_type": "date"
    }
) }}

SELECT
    review_id,
    order_id,
    product_id,
    user_id,
    rating,
    review_text,
    review_date
FROM {{ source('ecommerce', 'reviews') }}

{% if is_incremental() %}
  -- Only process reviews from the last 3 days to handle late entries
  WHERE review_date >= date_sub(current_date(), interval 3 day)
{% endif %}