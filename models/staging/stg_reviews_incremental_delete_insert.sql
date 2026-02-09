{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='review_id'
) }}

SELECT
    review_id,
    order_id,
    product_id,
    user_id,
    rating,
    review_text,
    review_date,
    CURRENT_TIMESTAMP() as dbt_updated_at
FROM {{ source('ecommerce', 'reviews') }}

{% if is_incremental() %}
  -- Overwrite any reviews that were updated since the last run
  WHERE review_date >= (SELECT max(review_date) FROM {{ this }})
{% endif %}