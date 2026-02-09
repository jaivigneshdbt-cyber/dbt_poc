{{ config(
    materialized='incremental',
    incremental_strategy='append'
) }}

SELECT
    review_id,  -- Using your schema from the image
    user_id,    -- Treated here as Patient ID
    product_id, -- Treated here as Treatment/Device ID
    rating,     -- Measured value (e.g., heart rate)
    review_text,
    review_date,
    CURRENT_TIMESTAMP() as dbt_updated_at
FROM {{ source('ecommerce', 'reviews') }}

{% if is_incremental() %}
  -- This filter ensures we only process data since the last run
  -- It makes the query run faster and lowers cloud costs
  WHERE review_date > (SELECT max(review_date) FROM {{ this }})
{% endif %}