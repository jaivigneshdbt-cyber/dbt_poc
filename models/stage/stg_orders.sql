{{ config(
    materialized='table',
    tags=['finance', 'orders']
) }}

SELECT
    -- Primary Key
    order_id,
    
    -- Foreign Key
    user_id,
    
    -- Timestamps (using our macro)
    {{ to_timestamp('order_date') }} as order_at,
    {{ to_timestamp('CURRENT_TIMESTAMP()') }} as loaded_at,
    
    -- Categorical Data (using our cleaning macro)
    {{ clean_string('order_status', format='lower') }} as status,
    
    -- Metrics (using our null-handling macro)
    {{ default_zero('total_amount') }} as total_amount,

    -- Transformation: Flagging high-value orders (Example of business logic)
    CASE 
        WHEN total_amount > 500 THEN TRUE 
        ELSE FALSE 
    END as is_high_value_order

FROM {{ source('ecommerce', 'orders') }}