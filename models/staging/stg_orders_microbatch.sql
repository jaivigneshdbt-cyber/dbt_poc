{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    concurrent_batches=true,
    unique_key='order_id',
    partition_by={
      "field": "order_date",
      "data_type": "timestamp",
      "granularity": "month"
    },
    event_time='order_date',
    batch_size='month',
    lookback=3,
    begin='2025-01-01',
    tags=['real-time', 'kafka_ingest']
) }}

SELECT
    order_id,
    user_id,
    order_date,
    trim(order_status) as status,
    {{ coalesce_nulls('total_amount') }} as total_amount,
    current_timestamp() as processed_at
FROM {{ source('ecommerce', 'orders') }}

{% if is_incremental() %}
  -- The microbatch strategy automatically handles the time filtering
  -- based on the 'event_time' and 'batch_size' config above.
{% endif %}