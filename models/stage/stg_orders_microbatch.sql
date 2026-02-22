{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    unique_key='order_id',
    partition_by={
      "field": "order_date",
      "data_type": "timestamp",
      "granularity": "hour"
    },
    event_time='order_date',
    batch_size='hour',
    lookback=3,
    begin='2025-01-01',
    tags=['real-time', 'kafka_ingest']
) }}

SELECT
    order_id,
    user_id,
    order_date,
    {{ clean_string('order_status') }} as status,
    {{ default_zero('total_amount') }} as total_amount,
    current_timestamp() as processed_at
FROM {{ source('ecommerce', 'orders') }}

{% if is_incremental() %}
  -- The microbatch strategy automatically handles the time filtering
  -- based on the 'event_time' and 'batch_size' config above.
{% endif %}