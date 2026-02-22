{{ config(
    materialized='incremental',
    incremental_strategy='insert_overwrite',
    partition_by={
      "field": "order_date",
      "data_type": "date",
      "granularity": "day"
    },
    tags=['daily', 'bi_layer']
) }}

WITH source_data AS (
    SELECT
        date(order_date) as order_date,
        order_id,
        status,
        total_amount
    FROM {{ ref('stg_orders') }}

    {% if is_incremental() %}
      -- This filter limits the scan of the source table for performance
      -- dbt will use these dates to identify which partitions to overwrite
      WHERE date(order_date) >= date_sub(current_date(), INTERVAL 7 DAY)
    {% endif %}
)

SELECT
    order_date,
    count(order_id) as total_orders,
    sum(total_amount) as daily_revenue,
    count(case when status = 'returned' then order_id end) as returned_orders
FROM source_data
GROUP BY 1