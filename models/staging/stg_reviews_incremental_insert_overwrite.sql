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
  -- Snowflake specific syntax: DATEADD(unit, measure, date)
  WHERE review_date >= DATEADD(day, -3, CURRENT_DATE())
{% endif %}