{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

WITH raw_orders AS (
    SELECT
        order_id,
        user_id,
        {{ to_timestamp('order_date') }} as order_at,
        {{ clean_string('order_status') }} as status,
        {{ default_zero('total_amount') }} as total_amount,
        current_timestamp() as dbt_updated_at
    FROM {{ source('ecommerce', 'orders') }}
)

SELECT * FROM raw_orders

{% if is_incremental() %}
  -- The 'Merge' strategy will look at these rows and 
  -- either update existing IDs or insert new ones.
  WHERE order_at >= (SELECT max(order_at) FROM {{ this }})
{% endif %}